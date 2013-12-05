from point import point
import math

class curve:
    def __init__(self, p1, pc1, pc2, p2):
        self.start = point(p1.x, p1.y)
        self.startCon = point(pc1.x, pc1.y)
        self.endCon = point(pc2.x, pc2.y)
        self.end = point(p2.x, p2.y)
        
    def refCon(self):
        return self.endCon.reflection(self.end)
    
    def sections(self, r):
        _sct = []
        for i in range(r):
            _sct.append(self.cpoint(float(i+1)/r))
        return _sct
    
    def output(self):
        str = ""
        for p in self.sections(10):
            str += "L%s,%s"%(p.x, p.y)
        return str
        
        # return "L%.2f,%.2fL%.2f,%.2fL%.2f,%.2f"%(self.startCon.x, self.startCon.y, self.endCon.x, self.endCon.y, self.end.x, self.end.y)    
        # return "L%.2f,%.2f"%(self.end.x, self.end.y)    
        
    # de casteljau
    def cpoint(self, t):
        k1 = []
        k1.append((self.start*(1-t))+(self.startCon*t))
        k1.append((self.startCon*(1-t))+(self.endCon*t))
        k1.append((self.endCon*(1-t))+(self.end*t))
        k2 = []
        k2.append(k1[0]*(1-t)+k1[1]*t)
        k2.append(k1[1]*(1-t)+k1[2]*t)
        return k2[0]*(1-t)+k2[1]*t
    
    def size(self):
        _ss = []
        _ss.append(self.start.distanceTo(self.startCon))
        _ss.append(self.end.distanceTo(self.endCon))
        _ss.append(self.start.distanceTo(self.end))
        _ss.append(self.startCon.distanceTo(self.endCon))
        return max(_ss)
    

if __name__ == "__main__":
    p1 = point(1, 2)
    pc1 = point(6, 8)
    p2 = point(16, 20)
    pc2 = point(18, 22)
    c = curve(p1, pc1, p2, pc2)
    print c.output()
    print c.size()