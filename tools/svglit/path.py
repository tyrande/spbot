from point import point
from metaPath import metaPath
import re

class path:
    def __init__(self, dataStr):
        self.metas = []
        self.width = 512
        for gs in re.finditer(r"[Mm][^Mm]*", re.sub(r"\n", "", dataStr)):
            self.metas.append(metaPath(gs.group()))

    def toLines(self, mm, minStep):
        _lines = []
        _ratio = self.width/float(mm)
        for mt in self.metas:
            for c in mt.curves:
                for p in c.sections(int(round(c.size()*_ratio/(float(minStep))))):
                    _lines.append([p.x, p.y, True])
            _lines[-1][2] = False
                    
        return _lines

    def toRopeLen(self, lp, rp, mm, minStep):
        _lines = []
        _ratio = self.width/float(mm)
        for mt in self.metas:
            for c in mt.curves:
                for p in c.sections(int(round(c.size()*_ratio/(float(minStep))))):
                    _lines.append([p.distanceTo(lp), p.distanceTo(rp), True])
            _lines[-1][2] = False
                    
        return _lines

    def output(self):
        for g in self.metas:
            print g.output()




if __name__ == "__main__":
    d = '''M352,368H160c-8.844,0-16-7.156-16-16s7.156-16,16-16h192c8.844,0,16,7.156,16,16S360.844,368,352,368z M368,400
	c0-8.844-7.156-16-16-16H160c-8.844,0-16,7.156-16,16s7.156,16,16,16h192C360.844,416,368,408.844,368,400z M336,448
	c0-8.844-7.156-16-16-16H192c-8.844,0-16,7.156-16,16s7.156,16,16,16h128C328.844,464,336,456.844,336,448z M138.719,316.188
	c6.563-5.906,7.094-16.031,1.156-22.594c-56.813-62.969-53.563-158.438,7.406-217.344c60.969-58.938,156.5-58.938,217.438,0
	c60.969,58.906,64.219,154.375,7.406,217.344c-5.938,6.563-5.406,16.688,1.156,22.594s16.688,5.375,22.594-1.156
	c68.438-75.844,64.531-190.844-8.906-261.781c-73.406-71-188.469-71-261.938,0c-73.438,70.938-77.344,185.938-8.906,261.781
	c3.156,3.5,7.5,5.281,11.875,5.281C131.813,320.313,135.656,318.938,138.719,316.188z M304,496c0-8.844-7.156-16-16-16h-64
	c-8.844,0-16,7.156-16,16s7.156,16,16,16h64C296.844,512,304,504.844,304,496z'''
    # path(d).output()
    ds = 'M'
    for p in path(d).toLines(1000, 10):
        if p[2]:
            ds += "%.2f,%.2fL"%(p[0], p[1])
        else:
            ds += "%.2f,%.2fZ M"%(p[0], p[1])
    print ds
    
    print path(d).toRopeLen(point(0, 0), point(1000, 1000), 1000, 6)