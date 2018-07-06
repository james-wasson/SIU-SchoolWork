(deftemplate father-of
  (slot father)
  (slot child))

(deftemplate mother-of
  (slot mother)
  (slot child))

(deftemplate male
  (slot person))

(deftemplate female
  (slot person))

(deftemplate wife-of
  (slot wife)
  (slot husband))

(deftemplate husband-of
  (slot husband)
  (slot wife))

(deftemplate me
  (slot person))

(deftemplate parent-of
  (slot parent)
  (slot child))

(deftemplate grandmother-of
  (slot grandmother)
  (slot grandchild))

(deftemplate grandfather-of
  (slot grandfather)
  (slot grandchild))

(deftemplate sibling-of
  (multislot siblings))

(deftemplate sister-of
  (slot sister)
  (slot person))

(deftemplate brother-of
  (slot brother)
  (slot person))

(deftemplate aunt-or-uncle-of
  (slot aunt-uncle)
  (slot person))

(deftemplate aunt-of
  (slot aunt)
  (slot person))

(deftemplate uncle-of
  (slot uncle)
  (slot person))

(deftemplate cousin-of
  (multislot cousins))


(deffacts family
  (male (person "Charles Duncan"))
  (male (person "Alfred Wasson"))
  
  (male (person "Andy Wasson"))
  (male (person "Philip Wasson"))
  (male (person "Brent Graham"))

  (male (person "Adam Wasson"))
  (male (person "Tad Wasson"))
  (male (person "Seth Wasson"))
  (male (person "Jason Wasson"))

  (female (person "Jean Duncan"))
  
  (female (person "Tracy Wasson"))
  (female (person "Sheri Wasson"))
  (female (person "Cassie Graham"))
  
  (female (person "Katelin Graham"))
  (female (person "Jessie Martin"))
  (female (person "Lindsay Wasson"))
  (female (person "Emma Wasson"))

  (father-of (father "Charles Duncan") (child "Tracy Wasson"))
  (father-of (father "Charles Duncan") (child "Cassie Graham"))
  (father-of (father "Alfred Wasson") (child "Andy Wasson"))
  (father-of (father "Alfred Wasson") (child "Philip Wasson"))

  (father-of (father "Andy Wasson") (child "Lindsay Wasson"))
  (father-of (father "Andy Wasson") (child "Adam Wasson"))
  (father-of (father "Andy Wasson") (child "Tad Wasson"))
  (father-of (father "Andy Wasson") (child "Seth Wasson"))
  
  (father-of (father "Brent Graham") (child "Katelin Graham"))
  (father-of (father "Brent Graham") (child "Jessie Martin"))
  
  (father-of (father "Philip Wasson") (child "Jason Wasson"))
  (father-of (father "Philip Wasson") (child "Emma Wasson"))
  
  (mother-of (mother "Jean Duncan") (child "Tracy Wasson"))
  
  (mother-of (mother "Tracy Wasson") (child "Lindsay Wasson"))
  (mother-of (mother "Tracy Wasson") (child "Adam Wasson"))
  (mother-of (mother "Tracy Wasson") (child "Tad Wasson"))
  (mother-of (mother "Tracy Wasson") (child "Seth Wasson"))
  
  (mother-of (mother "Sheri Wasson") (child "Jason Wasson"))
  (mother-of (mother "Sheri Wasson") (child "Emma Wasson"))
  
  (mother-of (mother "Cassie Graham") (child "Katelin Graham"))
  (mother-of (mother "Cassie Graham") (child "Jessie Martin"))

  (wife-of (wife "Tracy Wasson") (husband "Andy Wasson"))
  (wife-of (wife "Jean Duncan") (husband "Charles Duncan"))
  (wife-of (wife "Sheri Wasson") (husband "Philip Wasson"))
  (wife-of (wife "Cassie Graham") (husband "Brent Graham"))

  (husband-of (husband "Andy Wasson") (wife "Tracy Wasson"))
  (husband-of (husband "Charles Duncan") (wife "Jean Duncan"))
  (husband-of (husband "Philip Wasson") (wife "Sheri Wasson"))
  (husband-of (husband "Brent Graham") (wife "Cassie Graham"))
)

(defrule is-parent
  (or 
    (father-of (father ?x) (child ?y))
    (mother-of (mother ?x) (child ?y)))
  =>
  (assert (parent-of (parent ?x) (child ?y)))
)

(defrule is-grandfather
  (male (person ?grandP))
  (parent-of (parent ?grandP)(child ?conn))
  (parent-of (parent ?conn) (child ?grandC))
  =>
  (assert (grandfather-of (grandfather ?grandP) (grandchild ?grandC)))
)

(defrule is-grandmother
  (female (person ?grandP))
  (parent-of (parent ?grandP)(child ?conn))
  (parent-of (parent ?conn) (child ?grandC))
  =>
  (assert (grandmother-of (grandmother ?grandP) (grandchild ?grandC)))
)

(defrule is-sibling
  (parent-of (parent ?parent) (child ?child))
  (parent-of (parent ?parent) (child ?sibling))
  (test(neq ?child ?sibling))
  =>
  (assert (sibling-of (siblings ?child ?sibling)))
)

(defrule is-brother
  (male (person ?sibling))
  (sibling-of (siblings ?person ?sibling))
  =>
  (assert (brother-of (person ?person) (brother ?sibling)))
)

(defrule is-sister
  (female (person ?sibling))
  (sibling-of (siblings ?person ?sibling))
  =>
  (assert (sister-of (person ?person) (sister ?sibling)))
)

(defrule is-aunt-or-uncle
  (parent-of (parent ?parent) (child ?child))
  (sibling-of (siblings ?parent ?a-u))
  =>
  (assert (aunt-or-uncle-of (aunt-uncle ?a-u) (person ?child)))
)
; ---------------- Defines is aunt -------------------
(defrule is-aunt
  (female (person ?aunt))
  ?aunt-uncle-rule<-(aunt-or-uncle-of (person ?child) (aunt-uncle ?aunt))
  =>
  (retract ?aunt-uncle-rule)
  (assert (aunt-of (person ?child) (aunt ?aunt)))
)

(defrule is-aunt-by-marriage
  (uncle-of (person ?child) (uncle ?uncle))
  (husband-of (husband ?uncle) (wife ?aunt))
  =>
  (assert (aunt-of (aunt ?aunt) (person ?child)))
)
; ---------------- END Defines is aunt -------------------

; ---------------- Defines is uncle -------------------
(defrule is-uncle
  (male (person ?uncle))
  ?aunt-uncle-rule<-(aunt-or-uncle-of (person ?child) (aunt-uncle ?uncle))
  =>
  (retract ?aunt-uncle-rule)
  (assert (uncle-of (person ?child) (uncle ?uncle)))
)

(defrule is-uncle-by-marriage
  (aunt-of (person ?child) (aunt ?aunt))
  (wife-of (wife ?aunt) (husband ?uncle))
  =>
  (assert (uncle-of (uncle ?uncle) (person ?child)))
)
; ---------------- END Defines is uncle -------------------

(defrule is-cousin
  (aunt-or-uncle-of (aunt-uncle ?a-u) (person ?me))
  (parent-of (parent ?a-u) (child ?cousin))
  =>
  (assert (cousin-of (cousins ?me ?cousin)))
)
