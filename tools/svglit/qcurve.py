from point import point
import math

class qcurve:
    def __init__(self, p1, pc, p2):
        self.start = point(p1.x, p1.y)
        self.con = point(pc.x, pc.y)
        self.end = point(p2.x, p2.y)
        
    def refCon(self):
        return self.con.reflection(self.end)
    
    def output(self):
        str = ""
        for i in [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]:
            _p = self.cpoint(i)
            str += "L%s,%s"%(_p.x, _p.y)
        return str
        # return "L%.2f,%.2fL%.2f,%.2f"%(self.con.x, self.con.y, self.end.x, self.end.y)    
        # return "L%.2f,%.2f"%(self.end.x, self.end.y)                                                             
        
        
    # de casteljau
    def cpoint(self, t):
        k1 = []
        k1.append((self.start*(1-t))+(self.con*t))
        k1.append((self.con*(1-t))+(self.end*t))
        return k1[0]*(1-t)+k1[1]*t

if __name__ == "__main__":
    p1 = point(1, 2)
    pc = point(6, 8)
    p2 = point(16, 20)
    c = qcurve(p1, pc, p2)
    