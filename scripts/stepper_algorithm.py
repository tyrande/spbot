import math

slotDelay = 200  # micro second
minSlotPerStep = 10

motor1_history = []
motor2_history = []

def motor1(level):
    motor1_history.append(level)

def motor2(level):
    motor2_history.append(level)

def delayMico(t):
    pass

def setDelta(steps1, steps2):
    stepsMax = max(steps1, steps2)
    slots = stepsMax * minSlotPerStep
    
    stepPerSlot1 = float(steps1) / slots
    stepPerSlot2 = float(steps2) / slots
    
    stepped1 = 0
    stepped2 = 0
    for i in range(int(slots)):
        n = i+1
        print math.ceil(n*stepPerSlot1)
        if stepped1 < math.ceil(n*stepPerSlot1):
            stepped1 = math.ceil(n*stepPerSlot1)
            motor1(1)
        else:
            motor1(0)
            
        if stepped2 < math.ceil(n*stepPerSlot2):
            stepped2 = math.ceil(n*stepPerSlot2)
            motor2(1)
        else:
            motor2(0)
        
        delayMico(slotDelay)

if __name__ == '__main__':
    setDelta(6, 8)
    for i in range(len(motor1_history)):
        print motor1_history[i], motor2_history[i]
        
    print '-'*20
    print sum(motor1_history), sum(motor2_history)

