#-*- coding:utf-8 -*-
from motor import motor
from spray import spray
import math

class pinSystem:    
    def __init__(self, m1, m2, sp):
        self.pinA = m1
        self.pinB = m2
        self.spray = sp
        
    def loadPosition(self, x1, y1, x2, y2):
        self.pinA.setPosition(x1, y1)
        self.pinB.setPosition(x2, y2)
        
    def sinA(self):
        if self.pinA.x == self.spray.x:
            return 0 
        return math.sqrt((self.spray.x - self.pinA.x)**2/((self.spray.x - self.pinA.x)**2 + (self.spray.y - self.pinA.y)**2))
    def sinB(self):
        if self.pinB.x == self.spray.x:
            return 0
        return math.sqrt((self.spray.x - self.pinB.x)**2/((self.spray.x - self.pinB.x)**2 + (self.spray.y - self.pinB.y)**2))
    def cosA(self):
        return math.sqrt(1 - self.sinA()**2)
    def cosB(self):
        return math.sqrt(1 - self.sinB()**2)
    
    def pinForceA(self):
        if 0 == self.sinB():
            return 0
        return self.spray.weight*self.sinB()/(self.sinB()*self.cosA()+self.cosB()*self.sinA())
    def pinForceB(self):
        if 0 == self.sinA():
            return 0
        return self.spray.weight*self.sinA()/(self.sinB()*self.cosA()+self.cosB()*self.sinA())
        
if __name__ == "__main__":
    m1 = motor(12, 6.38, 32, 1.8)
    m2 = motor(12, 6.38, 32, 1.8)
    sp = spray(20, 0.5)
    
    ps = pinSystem(m1, m2, sp)
    ps.loadPosition(0, 0, 10, 100)
    
    for i in range(10):
        for j in range(10):
            ps.spray.setPosition(j, i)
            print "%.2f,%.2f"%(ps.pinForceA(), ps.pinForceB())