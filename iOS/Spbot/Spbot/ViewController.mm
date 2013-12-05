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
@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    _fixRadius = 300;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 391)];
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
    [_pin1 setImage:[self pin_img] forState:UIControlStateNormal];
    [self.view addSubview:_pin1];
    _pin2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _pin2.frame = CGRectMake(270-10, 50-10, 20, 20);
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
}

-(void)refreshCanvas
{
    [_canvas setPoints:_points];
    [_circle1 setRadius:_fixRadius x:_pin1.center.x y:_pin1.center.y];
    [_circle2 setRadius:_fixRadius x:_pin2.center.x y:_pin2.center.y];
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

    _pin1.center = CGPointMake(x1*_RATE_, y1*_RATE_);
    _pin2.center = CGPointMake(x2*_RATE_, y2*_RATE_);
    [self refreshCanvas];
}

#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
    Mat image_copy;
    cvtColor(image, image_copy, COLOR_BGRA2BGR);
    cvtColor(image_copy, image_copy, COLOR_BGR2HSV);
//    medianBlur(image_copy, image_copy, 1);
    
    inRange(image_copy, Scalar(170,160,60), Scalar(180,256,256), image_copy);
    
    vector<Vec3f> circles;
    HoughCircles(image_copy, circles, CV_HOUGH_GRADIENT, 1, image.cols/3, 1, 1, 1, 6);
    
    NSLog(@"-- %ld", circles.size());
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
        
        [self performSelectorInBackground:@selector(updatePins:) withObject:points];
    }
    
    _fps_num++;
}
#endif

- (void)photoCamera:(CvPhotoCamera*)photoCamera capturedImage:(UIImage *)image
{
    _photo = [MWPhoto photoWithImage:image];
    
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

@end
