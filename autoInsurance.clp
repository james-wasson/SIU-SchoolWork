(deftemplate driver 
  (slot person)
  (slot age (type NUMBER)(default 0))
  (slot car-cost (type NUMBER)(default 0))
  (slot commute-distance (type NUMBER)(default 0))
  (slot offence-points (type NUMBER)(default 0))
  (slot credit-score (type NUMBER)(default 0))
)

(deftemplate total-average-risk-of-driver
  (slot person)
  (slot risk (type NUMBER) (default 0))
)

(deftemplate insurance-premium-of-driver
  (slot person)
  (slot premium (type NUMBER) (default 0))
)

(deffacts drivers
  (driver
    (person "sarah")
    (age 18.5)
    (car-cost 5000)
    (commute-distance 20)
    (offence-points 10)
    (credit-score 700.5)
  )
  
  (driver
    (person "daniel")
    (age 18)
    (car-cost 5001)
    (commute-distance 20.5)
    (offence-points 11)
    (credit-score 700)
  )
)

(defrule calc-age-risk
  (declare (salience 10))
  (driver 
    (person ?driver)
    (age ?age)
  )
  =>
  (if (or ( <= ?age 18)(>= ?age 75))
    then (assert (age-risk ?driver .05))
    else (assert (age-risk ?driver 0))
  )
)

(defrule calc-car-cost-risk
  (declare (salience 10))
  (driver 
    (person ?driver)
    (car-cost ?car-cost)
  )
  =>
  (if (<= ?car-cost 5000)
    then (assert (car-cost-risk ?driver 0))
    else (if (<= ?car-cost 20000)
      then (assert (car-cost-risk ?driver .05))
      else (assert (car-cost-risk ?driver .1))
    )
  )
)

(defrule calc-commute-distance-risk
  (declare (salience 10))
  (driver 
    (person ?driver)
    (commute-distance ?commute-distance)
  )
  =>
  (if (<= ?commute-distance 20)
    then (assert (commute-distance-risk ?driver 0))
    else (if (<= ?commute-distance 50)
      then (assert (commute-distance-risk ?driver .02))
      else (assert (commute-distance-risk ?driver .05))
    )
  )
)

(defrule calc-offence-points-risk
  (declare (salience 10))
  (driver 
    (person ?driver)
    (offence-points ?offence-points)
  )
  =>
  (if (<= ?offence-points 10)
    then (assert (offence-points-risk ?driver 0))
    else (if (<= ?offence-points 20)
      then (assert (offence-points-risk ?driver .02))
      else (assert (offence-points-risk ?driver .1))
    )
  )
)

(defrule calc-credit-score-risk
  (declare (salience 10))
  (driver 
    (person ?driver)
    (credit-score ?credit-score)
  )
  =>
  (if (> ?credit-score 700)
    then (assert (credit-score-risk ?driver 0))
    else (if (> ?credit-score 600)
      then (assert (credit-score-risk ?driver .02))
      else (assert (credit-score-risk ?driver .05))
    )
  )
)

(defrule calc-total-avg-risk
  (driver (person ?driver))
  ?ageF<-(age-risk ?driver ?ageRisk)
  ?carF<-(car-cost-risk ?driver ?costRisk)
  ?commF<-(commute-distance-risk ?driver ?distRisk)
  ?offF<-(offence-points-risk ?driver ?offRisk)
  ?credF<-(credit-score-risk ?driver ?credRisk)
  =>
  (retract ?ageF ?carF ?commF ?offF ?credF)
  (bind ?risk (+ ?ageRisk (+ ?costRisk (+ ?distRisk (+ ?offRisk ?credRisk)))))
  (assert (total-average-risk-of-driver (person ?driver) (risk (/ ?risk 5))))
)

(defrule calc-insurance-premium
  (total-average-risk-of-driver (person ?driver) (risk ?risk))
  =>
  (assert (insurance-premium-of-driver 
    (person ?driver)
    (premium (* 700 (+ 1 ?risk)))
    )
  )
)
