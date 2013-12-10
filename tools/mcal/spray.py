#-*- coding:utf-8 -*-

class spray:
    def __init__(self, width, weight):
        # 线宽 (mm)
        self.lineWidth = width
        # 喷瓶+支架总重量 (kg)
        self.weight = weight
        # 墙坐标 (mm) 
        self.x = 0.0
        self.y = 0.0
        
    def setPosition(self, x, y):
        self.x = float(x)
        self.y = float(y)