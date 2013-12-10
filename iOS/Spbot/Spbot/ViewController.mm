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
#import "CvVideoPhotoCamera.h"
#import "SVGView.h"

using namespace cv;

@interface ViewController ()
@property (strong, nonatomic) LinesCanvas *canvas;
@property (strong, nonatomic) FixPinCircle *circle1;
@property (strong, nonatomic) FixPinCircle *circle2;
@property (strong, nonatomic) UIButton *pin1;
@property (strong, nonatomic) UIButton *pin2;
@property (nonatomic) int fixRadius;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) CvVideoPhotoCamera* videoCamera;

@property (nonatomic, strong) UIButton *startCaptrue;
@property (nonatomic, strong) NSArray *points;
@property (nonatomic, strong) UILabel *fps;
@property (nonatomic) int fps_num;
@property (strong, nonatomic) MWPhoto *photo;

@property (strong, nonatomic) UIView *svgWrap;
@property (strong, nonatomic) SVGView *svg;
@property (nonatomic) CGAffineTransform lastM;
@property (nonatomic) CGFloat firstX;
@property (nonatomic) CGFloat firstY;

@property (nonatomic) CGFloat pinDis;
@property (nonatomic) CGFloat pinAng;
@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    _fixRadius = 350;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 391)];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_imageView];
    
    _canvas = [[LinesCanvas alloc] initWithFrame:_imageView.frame];
    [self.view addSubview:_canvas];
    
    _circle1 = [[FixPinCircle alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _circle2 = [[FixPinCircle alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _circle2.rightPoint = YES;
    [self.view addSubview:_circle1];
    [self.view addSubview:_circle2];
    
    _pin1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    _pin1.frame = CGRectMake(50-10, 50-10, 20, 20);
    _pin1.frame = CGRectMake(-1, -100, 20, 20);
    [_pin1 setImage:[self pin_img] forState:UIControlStateNormal];
    [self.view addSubview:_pin1];
    _pin2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    _pin2.frame = CGRectMake(270-10, 50-10, 20, 20);
    _pin2.frame = CGRectMake(-1, -100, 20, 20);
    [_pin2 setImage:[self pin_img] forState:UIControlStateNormal];
    [self.view addSubview:_pin2];
    
    _videoCamera = [[CvVideoPhotoCamera alloc] initWithParentView:_imageView];
    _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    _videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    _videoCamera.defaultFPS = 15;
    _videoCamera.grayscaleMode = NO;
    _videoCamera.delegate = self;
    _videoCamera.delegatePhoto = self;
    
    _startCaptrue = [[UIButton alloc] initWithFrame:CGRectMake(0,400,100,40)];
    [_startCaptrue setTitle:@"Capture" forState:UIControlStateNormal];
    [_startCaptrue addTarget:self action:@selector(onCapture) forControlEvents:UIControlEventTouchUpInside];
    [_startCaptrue setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    _startCaptrue.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_startCaptrue];
    
    [self refreshCanvas];
    
    _fps = [[UILabel alloc] initWithFrame:CGRectMake(200, 400, 100, 40)];
    _fps.textColor = [UIColor grayColor];
    _fps.text = @"";
    _fps.textAlignment = NSTextAlignmentRight;
    _fps.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_fps];
    
    _svgWrap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 300)];
//    _svgWrap.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
    _svgWrap.layer.anchorPoint = CGPointMake(0, 0);
    _svgWrap.center = CGPointMake(0, 0);
    [self.view addSubview:_svgWrap];
    
    _svg = [[SVGView alloc] initWithFrame:CGRectMake(0, 0, 240, 300)];
    [_svg loadFromFile:@"light-bulb-4"];
    _svg.layer.anchorPoint = CGPointMake(0, 0);
    _svg.center = CGPointMake(0, 0);
    [_svgWrap addSubview:_svg];
//    _svg.hidden = YES;
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
	[pinchRecognizer setDelegate:self];
	[_svgWrap addGestureRecognizer:pinchRecognizer];
    
	UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
	[rotationRecognizer setDelegate:self];
	[_svgWrap addGestureRecognizer:rotationRecognizer];
    
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
	[_svgWrap addGestureRecognizer:panRecognizer];
    
    _pinDis = -1;
    
    //////////
//    Mat img = [self cvMatFromUIImage:[UIImage imageNamed:@"1386715683.jpg"]];
//    [self _processImage:img];
//    _imageView.image = [self UIImageFromCVMat:img];
}

-(void)refreshCanvas
{
    if (_pin1.center.y > 0 && _pin1.center.y > 0 &&
        _pin1.center.y < 100 && _pin1.center.y < 100 &&
        _pin1.center.x < 160 && _pin2.center.x > 160) {
        _pin1.hidden = NO;
        _pin2.hidden = NO;
        _circle1.hidden = NO;
        _circle2.hidden = NO;
        _svgWrap.hidden = NO;
        
        CGFloat pD = ccpDistance(_pin1.center, _pin2.center);
        CGFloat pA = asinf((_pin1.center.y - _pin2.center.y) / pD);
        
        if (_pinDis < 0) {
            _pinDis = pD;
            _pinAng = pA;
        }
        
        CGFloat rate = pD * cos(_pinAng) / 240.0;
        CGAffineTransform t = CGAffineTransformMakeScale(rate, rate);
        t = CGAffineTransformRotate(t, _pinAng - pA);
        t = CGAffineTransformTranslate(t, _pin1.center.x, _pin1.center.y);
        [_svgWrap setTransform:t];
        
        [_canvas setPoints:_points];
        [_circle1 setRadius:_fixRadius x:_pin1.center.x y:_pin1.center.y];
        [_circle2 setRadius:_fixRadius x:_pin2.center.x y:_pin2.center.y];
    }else{
        _pin1.hidden = YES;
        _pin2.hidden = YES;
        _circle1.hidden = YES;
        _circle2.hidden = YES;
        _svgWrap.hidden = YES;
    }
}

-(void)onCapture
{
    if ([_startCaptrue.titleLabel.text isEqualToString:@"Take"]) {
        [_videoCamera stop];
        _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
        [_videoCamera start];
        [_videoCamera createStillImageOutput];
        [_videoCamera takePicture];
    }else{
        [_startCaptrue setTitle:@"Take" forState:UIControlStateNormal];
        _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
        [_videoCamera start];
        _fps_num = 0;
        [self performSelector:@selector(refreshFPS) withObject:nil afterDelay:1];
    }
}

-(void)refreshFPS
{
    _fps.text = [NSString stringWithFormat:@"%d fps",_fps_num];
    _fps_num = 0;
    if (_videoCamera.running) [self performSelector:@selector(refreshFPS) withObject:nil afterDelay:1];
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
//    NSLog(@"%f,%f --- %f,%f", x1, y1, x2, y2);
    
    if (y1 < 100 && y2 < 100 && x1 < 160 && x2 > 160) {
        _pin1.center = CGPointMake(x1*_RATE_, y1*_RATE_);
        _pin2.center = CGPointMake(x2*_RATE_, y2*_RATE_);
    }else{
        _pin1.center = CGPointMake(0, -100);
        _pin2.center = CGPointMake(0, -100);
    }
    [self refreshCanvas];
}

#ifdef __cplusplus
- (NSArray *)_processImage:(Mat&)image_org output:(Mat&)image
{
    cvtColor(image_org, image, COLOR_BGRA2BGR);
    cvtColor(image, image, COLOR_BGR2HSV);
    
    inRange(image, Scalar(160,160,100), Scalar(180,255,255), image);
    
    vector<Vec3f> circles;
    HoughCircles(image, circles, CV_HOUGH_GRADIENT, 1, image.cols/4, 1, 1, 1, 6);
    
    Canny(image, image_org, 1, 1);
    
    if (circles.size() >= 2){
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:circles.size()];
        for( size_t i = 0; i < circles.size(); i++ ){
            Vec3f c = circles[i];
            [points addObject:@[[NSNumber numberWithFloat:c[0]], [NSNumber numberWithFloat:c[2]], [NSNumber numberWithFloat:c[1]]]];
        }
        _points = [NSArray arrayWithArray:points];
        
        [points sortUsingComparator:^ NSComparisonResult(NSArray *a, NSArray *b){
            return [[a lastObject] compare:[b lastObject]];
        }];
        if (points.count > 2) {
            [points removeObjectsInRange:NSMakeRange(2, points.count - 2)];
        }
        [points sortUsingComparator:^ NSComparisonResult(NSArray *a, NSArray *b){
            return [[a firstObject] compare:[b firstObject]];
        }];
        
        return points;
    }
    return nil;
}

- (NSArray *)_processImage2:(Mat&)image_org output:(Mat&)image
{
//    cvtColor(image_org, image, COLOR_BGRA2BGR);
    cvtColor(image, image, COLOR_BGR2HSV);
    
    inRange(image, Scalar(100,60,60), Scalar(140,255,255), image);
    
    vector<Vec3f> circles;
    HoughCircles(image, circles, CV_HOUGH_GRADIENT, 1, image.cols/4, 1, 1, 1, 15);
    
    if (circles.size() >= 2){
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:circles.size()];
        for( size_t i = 0; i < circles.size(); i++ ){
            Vec3f c = circles[i];
            [points addObject:@[[NSNumber numberWithFloat:c[0]], [NSNumber numberWithFloat:c[2]], [NSNumber numberWithFloat:c[1]]]];
        }
        _points = [NSArray arrayWithArray:points];
        
        [points sortUsingComparator:^ NSComparisonResult(NSArray *a, NSArray *b){
            return [[a lastObject] compare:[b lastObject]];
        }];
        if (points.count > 2) {
            [points removeObjectsInRange:NSMakeRange(2, points.count - 2)];
        }
        [points sortUsingComparator:^ NSComparisonResult(NSArray *a, NSArray *b){
            return [[a firstObject] compare:[b firstObject]];
        }];
        
        return points;
    }
    return nil;
}


- (void)processImage:(Mat&)image;
{
    Mat image_copy;
    NSArray *ret = [self _processImage:image output:image_copy];
    if (ret) {
        [self performSelectorInBackground:@selector(updatePins:) withObject:ret];
    }
    _fps_num++;
}

#endif

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

- (void)photoCamera:(CvPhotoCamera*)photoCamera capturedImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    Mat img = [self cvMatFromUIImage:image];
    NSArray *ps = [self _processImage2:img output:img];
    NSLog(@"%@",ps);
    NSLog(@"%f,%f",image.size.width, image.size.height);

    UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 1.0f);
    [[UIColor colorWithRed:0 green:1 blue:0 alpha:1] setStroke];
    for (NSArray *p in _points) {
        CGFloat x = [[p objectAtIndex:0] floatValue];
        CGFloat y = [[p objectAtIndex:2] floatValue];
        CGFloat r = [[p objectAtIndex:1] floatValue];
        CGContextAddEllipseInRect(contextRef, CGRectMake(x-r, y-r, 2*r, 2*r));
    }
    CGContextStrokePath(contextRef);
    
    
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    _photo = [MWPhoto photoWithImage:image2];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.wantsFullScreenLayout = YES;
    browser.zoomPhotosToFill = YES;
    [browser setCurrentPhotoIndex:0];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    
    [_videoCamera stop];
    [_startCaptrue setTitle:@"Capture" forState:UIControlStateNormal];
}

- (void)photoCameraCancel:(CvPhotoCamera*)photoCamera
{
    
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return _photo;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
}

#pragma mark - trans svg

-(void)scale:(id)sender {
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastM = _svg.transform;
        return;
    }
    CGFloat t = [(UIPinchGestureRecognizer*)sender scale];
    [_svg setTransform:CGAffineTransformScale(_lastM, t, t)];
}

-(void)rotate:(id)sender {
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastM = _svg.transform;
        return;
    }
    CGFloat t = [(UIRotationGestureRecognizer*)sender rotation];
    [_svg setTransform:CGAffineTransformRotate(_lastM, t)];
}

-(void)move:(id)sender {
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastM = _svg.transform;
        return;
    }
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:_svgWrap];
    [_svg setTransform:CGAffineTransformTranslate(_lastM, translatedPoint.x, translatedPoint.y)];
}

@end
