from point import point
from line import line
from curve import curve
from qcurve import qcurve
import math, re

class metaPath:
    
    def __init__(self, dataStr):
        self.curves = []
        if not re.match(r"^[Mm]", dataStr):
            raise "no start point"
        _ds = re.sub(r"([Mm])", r"\1:", dataStr)
        _ds = re.sub(r"([LHVCSQTAZlhvcsqtaz])", r";\1:", _ds)
        _ds = re.sub(r"-", r",-", _ds)
        _ds = re.sub(r"([:,]),", r"\1", _ds)
        for c in _ds.split(";"):
            _dt = c.split(":")
            if len(_dt) < 2:
                break
            _command = re.sub(r"\s", "", _dt[0])
            _ss = re.sub("-", ",-", _dt[1])
            _ss = re.sub("\s", ",", _ss)
            _ss = re.sub(r"^[,]+", '', _ss)
            _ss = re.sub(r"[,]+", ',', _ss)
            _ps = _ss.split(",")
            
            if 'M' == _command or 'm' == _command:
                _obj = point(_ps[0], _ps[1])
            elif 'L' == _command:
                _obj = line(_obj.end, point(_ps[0], _ps[1]))
            elif 'l' == _command:
                _obj = line(_obj.end, _obj.end.move(_ps[0], _ps[1]))
            elif 'H' == _command:
                _obj = line(_obj.end, point(_ps[0], _obj.end.y))
            elif 'h' == _command:
                _obj = line(_obj.end, _obj.end.move(_ps[0], 0))
            elif 'V' == _command:
                _obj = line(_obj.end, point(_obj.end.x, _ps[1]))
            elif 'v' == _command:
                _obj = line(_obj.end, _obj.end.move(0, _ps[1]))
            elif 'C' == _command:
                _obj = curve(_obj.end, point(_ps[0], _ps[1]), point(_ps[2], _ps[3]), point(_ps[4], _ps[5]))
            elif 'c' == _command:
                _obj = curve(_obj.end, _obj.end.move(_ps[0], _ps[1]), _obj.end.move(_ps[2], _ps[3]), _obj.end.move(_ps[4], _ps[5]))
            elif 'S' == _command:
                _obj = curve(_obj.end, _obj.refCon(), point(_ps[0], _ps[1]), point(_ps[2], _ps[3]))
            elif 's' == _command:
                _obj = curve(_obj.end, _obj.refCon(), _obj.end.move(_ps[0], _ps[1]), _obj.end.move(_ps[2], _ps[3]))
            elif 'Q' == _command:
                _obj = qcurve(_obj.end, point(_ps[0], _ps[1]), point(_ps[2], _ps[3]))
            elif 'q' == _command:
                _obj = qcurve(_obj.end, _obj.end.move(_ps[0], _ps[1]), _obj.end.move(_ps[2], _ps[3]))
            elif 'T' == _command:
                _obj = qcurve(_obj.end, _obj.refCon(), point(_ps[0], _ps[1]))
            elif 't' == _command:
                _obj = qcurve(_obj.end, _obj.refCon(), _obj.end.move(_ps[0], _ps[1]))
            elif 'A' == _command:
                ''
            else: break
            
            
            self.curves.append(_obj)
    
    def output(self):
        str = ""
        for c in self.curves:
            str += c.output()
        return str
    
if __name__ == "__main__":
    ds = 'M352,368H160c-8.844,0-16-7.156-16-16s7.156-16,16-16h192c8.844,0,16,7.156,16,16S360.844,368,352,368z'
    g = metaPath(ds)
    print g.output()
    
    # ds1 = "M200,300 Q400,50 600,300 T1000,300"
    # g1 = metaPath(ds1)
    # print g1.output()