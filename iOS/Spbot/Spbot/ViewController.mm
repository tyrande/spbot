//
//  ViewController.m
//  Spbot
//
//  Created by claire on 11/30/13.
//  Copyright (c) 2013 claire. All rights reserved.
//

#import "ViewController.h"
#import "FixPinCircle.h"
#import "LinesCanvas.h"
#import "GCDAsyncUdpSocket.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()
@property (strong, nonatomic) LinesCanvas *canvas;
@property (strong, nonatomic) FixPinCircle *circle1;
@property (strong, nonatomic) FixPinCircle *circle2;
@property (strong, nonatomic) UIButton *pin1;
@property (strong, nonatomic) UIButton *pin2;
@property (nonatomic) int fixRadius;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) CvVideoCamera* videoCamera;

@property (nonatomic, strong) UIButton *startCaptrue;
@property (strong, nonatomic) GCDAsyncUdpSocket *connSocket;
@property (strong, nonatomic) NSArray *thirdpin;
@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    _fixRadius = 300;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 427)];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_imageView];
    
    _canvas = [[LinesCanvas alloc] initWithFrame:_imageView.frame];
    [self.view addSubview:_canvas];
    
    _circle1 = [[FixPinCircle alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _circle2 = [[FixPinCircle alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:_circle1];
    [self.view addSubview:_circle2];
    
    _pin1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _pin1.frame = CGRectMake(50-10, 50-10, 20, 20);
    [_pin1 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [_pin1 setImage:[self pin_img] forState:UIControlStateNormal];
    [self.view addSubview:_pin1];
    _pin2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _pin2.frame = CGRectMake(270-10, 50-10, 20, 20);
    [_pin2 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [_pin2 setImage:[self pin_img] forState:UIControlStateNormal];
    [self.view addSubview:_pin2];
    
    _videoCamera = [[CvVideoCamera alloc] initWithParentView:_imageView];
    _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    _videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    _videoCamera.defaultFPS = 10;
    _videoCamera.grayscaleMode = NO;
    _videoCamera.delegate = self;
    
    _startCaptrue = [[UIButton alloc] initWithFrame:CGRectMake(0,430,100,30)];
    [_startCaptrue setTitle:@"Capture" forState:UIControlStateNormal];
    [_startCaptrue addTarget:self action:@selector(onCapture) forControlEvents:UIControlEventTouchUpInside];
    [_startCaptrue setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [self.view addSubview:_startCaptrue];
    
    _thirdpin = nil;
    [self refreshCanvasX:-1 Y:-1];
    
    
    NSError *error = nil;
    _connSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    int port = 9527;
    if (![_connSocket bindToPort:port error:&error]){
        NSLog(@"Error starting server (bind): %@", error);return;
    }
    if (![_connSocket beginReceiving:&error]) {
        [_connSocket close];
        NSLog(@"Error starting server (recv): %@", error);return;
    }
}

- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    UIControl *control = sender;
    control.center = point;
    
    [self refreshCanvasX:-1 Y:-1];
}

-(void)refreshCanvasX:(CGFloat)x Y:(CGFloat)y
{
    [_canvas setPoint:CGPointMake(x, y) point1:_pin1.center point2:_pin2.center];
    [_circle1 setRadius:_fixRadius x:_pin1.center.x y:_pin1.center.y];
    [_circle2 setRadius:_fixRadius x:_pin2.center.x y:_pin2.center.y];
}

-(void)onCapture
{
    [_videoCamera start];
}

-(UIImage *)pin_img{
    static UIImage *img;
    if (! img) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.0f, 20.0f), FALSE, [[UIScreen mainScreen] scale]);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor colorWithRed:97/255.0 green:177/255.0 blue:245/255.0 alpha:1] setFill];
        CGContextFillEllipseInRect(context, CGRectMake(7, 7, 6, 6));
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return img;
}

-(void)updatePins:(NSArray *)points
{
    CGFloat x1 = [[[points firstObject] firstObject] floatValue];
    CGFloat y1 = [[[points firstObject] lastObject] floatValue];
    CGFloat x2 = [[[points lastObject] firstObject] floatValue];
    CGFloat y2 = [[[points lastObject] lastObject] floatValue];
    CGFloat x3 = -10;
    CGFloat y3 = -10;
    
//    NSLog(@"%f,%f --- %f,%f", x1, y1, x2, y2);
    
    if (_thirdpin) {
        x3 = [[_thirdpin firstObject] floatValue];
        y3 = [[_thirdpin lastObject] floatValue];
    }
    
    CGFloat rate = 320.0/480.0;
    _pin1.center = CGPointMake(x1*rate, y1*rate);
    _pin2.center = CGPointMake(x2*rate, y2*rate);
    [self refreshCanvasX:x3*rate Y:y3*rate];
    
    NSData *send;
    if (_thirdpin) {
        send = [[NSString stringWithFormat:@"(%.1f,%.1f,%.1f,%.1f,%.1f,%.1f)",x1,y1,x2,y2,x3,y3] dataUsingEncoding:NSUTF8StringEncoding];
    }else{
        send = [[NSString stringWithFormat:@"(%.1f,%.1f,%.1f,%.1f)",x1,y1,x2,y2] dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    [_connSocket sendData:send toHost:@"192.168.101.8" port:9595 withTimeout:-1 tag:0];
}

#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
    Mat image_copy;
    cvtColor(image, image_copy, COLOR_BGRA2BGR);
    cvtColor(image_copy, image_copy, COLOR_BGR2HSV);
    medianBlur(image_copy, image_copy, 3);
    
    inRange(image_copy, Scalar(170,160,60), Scalar(180,256,256), image);
    
    vector<Vec3f> circles;
    HoughCircles(image, circles, CV_HOUGH_GRADIENT, 1, image.cols / 3,
                 1,1, 2,20);
    NSLog(@"-- %ld", circles.size());
    if (circles.size() >= 2){
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:circles.size()];
        for( size_t i = 0; i < circles.size(); i++ ){
            Vec3f c = circles[i];
            [points addObject:@[[NSNumber numberWithFloat:c[0]], [NSNumber numberWithFloat:c[1]]]];
        }
        
        [points sortUsingComparator:^ NSComparisonResult(NSArray *a, NSArray *b){
            return [[a lastObject] compare:[b lastObject]];
        }];
        if (points.count > 2) {
            _thirdpin = [points objectAtIndex:2];
            [points removeObjectsInRange:NSMakeRange(2, points.count - 2)];
        }else{
            _thirdpin = nil;
        }
        [points sortUsingComparator:^ NSComparisonResult(NSArray *a, NSArray *b){
            return [[a firstObject] compare:[b firstObject]];
        }];
        
        [self performSelectorInBackground:@selector(updatePins:) withObject:points];
    }
}
#endif

@end
