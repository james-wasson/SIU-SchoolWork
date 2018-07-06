import time
from math import sqrt
import random

# impliments the square root function
def sqareRoot(radicand):
    if(radicand >= 0):
        times = 15

        X = 10

        for i in range(times):
            X = ( (X +(radicand/X))/2)
        return X
    else:
        return "Error"

### tests the square root function ###

def formatFloat(num,points):
    formater = "."+str(points)+"f"
    strNum = str(num)
    startDecimals = strNum.find(".") + 1
    if(startDecimals + points+2 <= len(strNum)):
        if(int(strNum[startDecimals + points+1]) >= 5):
            num = float(strNum[:startDecimals + points] + str(int(strNum[startDecimals + points+1])+1) + strNum[startDecimals + points+1:])
            
        
    return format(num,formater)

def testFloatEqual(num1,num2,equalToPnt):
    if(formatFloat(num1,equalToPnt) ==  formatFloat(num2,equalToPnt)):
       return True
    return False

maxNum = 1000000
equalToPoint = 11
times = 10000
totalTimeDiff = 0
for i in range(times):
    
    radicand = random.uniform(0,maxNum)

    timeSrt = time.time()
    mySqrt = sqareRoot(radicand)
    timeEnd = time.time()
    
    myTime = timeEnd-timeSrt

    timeSrt = time.time()
    theirSqrt = sqrt(radicand)
    timeEnd = time.time()
    
    theirTime = timeEnd-timeSrt

    totalTimeDiff += theirTime - myTime

    if(not(testFloatEqual(mySqrt, theirSqrt,equalToPoint))):
        print("Not Equal")
        print("num:",radicand)
        print("Mine:  ",mySqrt)
        print("Theirs:",theirSqrt)
        print("Formated")
        print("Mine:  ",formatFloat(mySqrt,equalToPoint))
        print("Theirs:",formatFloat(theirSqrt,equalToPoint))
        break
print("Average Time Difference:",formatFloat(totalTimeDiff/times,equalToPoint))

