#export VERSIONER_PYTHON_PREFER_32_BIT=yes
import socket, re, thread, wx, time

UDP_IP = "0.0.0.0"
UDP_PORT = 9595
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))

isTracking = False
trackingBMP = None
trackingDC = None
lastX = -1
lastY = -1

class Monitor(wx.Frame):
    def __init__(self, parent=None, id=-1, title=None):
        wx.Frame.__init__(self, parent, id, title, size=(480, 640))
        self.statbmp1 = wx.StaticBitmap(self)
        self.statbmp2 = wx.StaticBitmap(self)
        self.Bind(wx.EVT_LEFT_DOWN, self.OnLeftDown)
        
    def OnLeftDown(self, event):
        global isTracking, trackingDC, trackingBMP
        if isTracking:
            self.statbmp1.SetBitmap(wx.EmptyBitmap(480, 640))
            trackingBMP = None
            trackingDC = None
            isTracking = False
        else:
            trackingBMP = wx.EmptyBitmap(480, 640)
            trackingDC = wx.MemoryDC(trackingBMP)
            trackingDC.SetPen(wx.Pen('blue', 1))
            isTracking = True

app = wx.App(0)
frame = Monitor(title='Monitor')
frame.Show()


def receive_udp():
    global w, lastY, lastX, trackingDC, trackingBMP
    while True:
        data, addr = sock.recvfrom(1024)
        print time.time(), data
        
        draw_bmp = wx.EmptyBitmap(480, 640)
        canvas_dc = wx.MemoryDC(draw_bmp)
        canvas_dc.SetBrush(wx.Brush('white'))
        canvas_dc.Clear()
        canvas_dc.SetPen(wx.Pen('black', 1))
        canvas_dc.SetBrush(wx.Brush('red'))
        
        for l in re.findall('\([.,0-9-]+\)', data):
            nums = l.strip('()').split(',')
            if len(nums) > 0 and len(nums) % 2 == 0:
                for i in range(len(nums)/2):
                    x = float(nums[i*2])
                    y = float(nums[i*2+1])
                    canvas_dc.DrawCircle(x-2, y-2, 4)
                
                if len(nums) > 4 and isTracking:
                    x = float(nums[4])
                    y = float(nums[5])
                    if lastX > 0:
                        print '--',lastX, lastY, x, y
                        trackingDC.DrawLine(lastX, lastY, x, y)
                        frame.statbmp2.SetBitmap(trackingBMP)
                    lastX = x
                    lastY = y
                    
        frame.statbmp1.SetBitmap(draw_bmp)

thread.start_new_thread(receive_udp,()) 
app.MainLoop()

