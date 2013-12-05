from point import point
import math

class line:
    def __init__(self, p1, p2):
        self.start = point(p1.x, p1.y)
        self.end = point(p2.x, p2.y)
        
    def size(self):
        return math.sqrt((self.start.x - self.end.x)**2 + (self.start.y - self.end.y)**2)
        
    def slope(self):
        if self.start.x == self.end.x:
            return None
        else:
            return (self.end.y - self.start.y)/(self.end.x - self.start.x)
            
    def refCon(self):
        return self.end
        
    def cpoint(self, t):
        return self.start*(1-t)+self.end*t
        
    def sections(self, r):
        _sct = []
        for i in range(r):
            _sct.append(self.cpoint(float(i+1)/r))
        return _sct
        
    def output(self):
        return "L%.2f,%.2f"%(self.end.x, self.end.y)
        
if __name__ == "__main__":
    p1 = point(2, 4)
    p2 = point(3, 6)
    l = line(p1, p2)
    print l.start.x
    print l.end.y
    print l.size()
    print l.slope()
    print l.output()
    for p in l.sections(10):
        print "%.2f,%.2f"%(p.x, p.y)
    
    p3 = point(5, 4)
    p4 = point(8, 6)
    l1 = line(p3, p4)
    print l1.output()