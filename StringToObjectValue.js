var obj = {
  a: {
    b: {
      c: 5
    }
  }
}

function getValueAtDotString(str, obj) {
    var movingObj = obj;
    var keys = str.split('.');
    for (var i in keys) {
        keys[i] = keys[i].trim();
        movingObj = movingObj[keys[i]];
        if (typeof movingObj === 'undefined' || movingObj === null)
            return null;
    }
    return movingObj;
}
    
var result = getValueAtDotString("a.b.c", obj); // returns 5