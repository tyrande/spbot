import math

class point:
    def __init__(self, _x, _y):
        self.x = float(_x)
        self.y = float(_y)
        self.end = self
        
    def __add__(self, p):
        return point(self.x + p.x, self.y + p.y)
        
    def __mul__(self, t):
        return point(self.x * float(t), self.y * float(t))
        
    def moveTo(self, p):
        self.x = p.x
        self.y = p.y
        
    def move(self, dx, dy):
        return point(self.x + float(dx), self.y + float(dy))
        
        
    def size(self):
        return 0
        
    def sections(self, r):
        return [self]
        
    def refCon(self):
        return self
    
    def reflection(self, p):
        return point(2*p.x - self.x, 2*p.y - self.y)
        
    def reflectionTwo(self, p1, p2):
        if p1.x == p2.x:
            return point(self.x, p1.y + p2.y - self.y)
        elif p1.y == p2.y:
            return point(p1.x + p2.x - self.x, self.y)
        else:
            _a = (p2.y-p1.y)/(p2.x-p1.x)
            _ccx = ((p2.x+p1.x)/2.0/_a+_a*self.x+(p2.y+p1.y-2*self.y)/2.0)/(_a+1/_a)
            _ccy = (p2.y-p1.y)/(p2.x-p1.x)*(_ccx-self.x)+self.y
            return point(2*_ccx - self.x, 2*_ccy - self.y)
        
    def distanceTo(self, p):
        return math.sqrt((self.x - p.x)**2 + (self.y - p.y)**2)
        
    def output(self):
        return "M%.2f,%.2f"%(self.x, self.y)

if __name__ == "__main__":
    p = point(2, 4)
    print p.x
    print p.y
    p2 = point(3, 6)
    p.moveTo(p2)
    print p.x
    print p.y
    
    p3 = p + p2
    print p3.x
    print p3.y