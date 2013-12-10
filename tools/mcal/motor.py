#-*- coding:utf-8 -*-
import math

class motor:
    def __init__(self, t, ad, d, sa):
        # 扭矩 (kg*cm)
        self.torque = float(t)
        # 轴径/轮内径 (mm)
        self.axisD = float(ad)
        # 轮外径 (mm)
        self.d = float(d)
        self.stepAngle = float(sa)
        # 墙坐标 (mm) 
        self.x = 0.0
        self.y = 0.0
        
    def setRPM(self, rpm):
        # 转速 (r/s)
        self.rpm = float(rpm)
        
    def setD(self, d):
        self.d = float(d)
        
    def setPosition(self, x, y):
        self.x = float(x)
        self.y = float(y)
        
    def force(self):
        # 拉力 (kg)
        return self.torque*10*2/self.d
    
    def minLen(self):
        return self.d*math.pi/360*self.stepAngle
        
        
if __name__ == "__main__":
    m42BYGH47 = motor(5.5, 5, 32, 1.8)
    m57BYGH56 = motor(12, 6.38, 32, 1.8)
    print m57BYGH56.force()
    print m57BYGH56.minLen()