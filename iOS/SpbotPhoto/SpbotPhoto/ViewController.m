//
//  ViewController.m
//  SpbotPhoto
//
//  Created by crane on 12/10/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import "ViewController.h"
#import "PhotoAnalyzer.h"
#import "SVGView.h"

@interface ViewController ()
@property (strong, nonatomic) UIView *buttons;
@property (strong, nonatomic) UIButton *takePhotoBtn;
@property (strong, nonatomic) UIButton *selectPhotoBtn;

@property (strong, nonatomic) UIScrollView *scroll;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *genData;

@property (strong, nonatomic) UIView *svgWrap;
@property (strong, nonatomic) SVGView *svg;
@property (strong, nonatomic) UIImageView *svgCanvas;
@property (nonatomic) CGAffineTransform lastM;

@property (strong, nonatomic) PhotoAnalyzer *photoAnalyzer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _buttons = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 400)];
    [self.view addSubview:_buttons];
    
    _takePhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 220, 64)];
    [_takePhotoBtn setBackgroundColor:[UIColor colorWithHue:203.0f/360.0f saturation:0.80f brightness:0.80f alpha:1.0f]];
    [_takePhotoBtn setTitle:@"Take Photo" forState:UIControlStateNormal];
    [_takePhotoBtn addTarget:self action:@selector(onTakePhoto) forControlEvents:UIControlEventTouchUpInside];
    [_buttons addSubview:_takePhotoBtn];
    
    _selectPhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 220, 64)];
    [_selectPhotoBtn setBackgroundColor:[UIColor colorWithHue:203.0f/360.0f saturation:0.80f brightness:0.80f alpha:1.0f]];
    [_selectPhotoBtn setTitle:@"Select Photo" forState:UIControlStateNormal];
    [_selectPhotoBtn addTarget:self action:@selector(onSelectPhoto) forControlEvents:UIControlEventTouchUpInside];
    [_buttons addSubview:_selectPhotoBtn];
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    _scroll.hidden = YES;
    _scroll.backgroundColor = [UIColor blackColor];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _imageView.userInteractionEnabled = YES;
    [_scroll addSubview:_imageView];
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [_scroll addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [_scroll addGestureRecognizer:twoFingerTapRecognizer];
    
    _svgWrap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
//    _svgWrap.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
    _svgWrap.layer.anchorPoint = CGPointMake(0, 0);
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
    [_imageView addSubview:_svgWrap];
    
    _genData = [[UIButton alloc] initWithFrame:CGRectMake(120, 400, 80, 60)];
    [_genData setTitle:@"Generate" forState:UIControlStateNormal];
    [_genData setTitleColor:[UIColor colorWithHue:203.0f/360.0f saturation:0.80f brightness:0.80f alpha:1.0f] forState:UIControlStateNormal];
    _genData.backgroundColor = [UIColor clearColor];
    _genData.hidden = YES;
    [_genData addTarget:self action:@selector(onGenData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_genData];
}

-(void)onTakePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)onSelectPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _scroll.hidden = NO;
    _genData.hidden = NO;
    _buttons.hidden = YES;
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    _photoAnalyzer = [[PhotoAnalyzer alloc] init];
    image = [_photoAnalyzer procImage:image];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    _imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    _imageView.image = image;
    _scroll.contentSize = image.size;
    
    CGRect scrollViewFrame = _scroll.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / _scroll.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / _scroll.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    _scroll.minimumZoomScale = minScale;
    
    _scroll.maximumZoomScale = 1.0f;
    _scroll.zoomScale = minScale;
    
    [self centerScrollViewContents];
    
    _svgWrap.frame = (CGRect){0.0f, 0.0f, image.size.width, image.size.height};
    _svgWrap.center = CGPointMake(0, 0);
    
    _svg = [[SVGView alloc] initWithFrame:CGRectMake(0, 0, _svgWrap.frame.size.width, _svgWrap.frame.size.height)];
    [_svg loadFromFile:@"light-bulb-4"];
    [_svgWrap addSubview:_svg];
    
    CGAffineTransform t = CGAffineTransformMakeScale(0.33, 0.33);
    t = CGAffineTransformTranslate(t, image.size.width, image.size.height);
    [_svgWrap setTransform:t];
    
    _svgCanvas = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [_imageView addSubview:_svgCanvas];
    [self refreshCanvas];
}

-(void)refreshCanvas
{
    CGFloat r = _imageView.image.size.width / _svg.width;
    CGAffineTransform t2 = CGAffineTransformMakeScale(r, r);
    CGAffineTransform tt = CGAffineTransformConcat(t2, _svgWrap.transform);
    
    UIGraphicsBeginImageContextWithOptions(_imageView.image.size, FALSE, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_svg drawLines:context transform:tt mmPerPixel:_photoAnalyzer.mmPerPixel];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _svgCanvas.image = img;
    
    _svgCanvas.hidden = NO;
    _svg.hidden = YES;
}

-(void)onGenData
{
    CGFloat r = _imageView.image.size.width / _svg.width;
    CGAffineTransform t2 = CGAffineTransformMakeScale(r, r);
    CGAffineTransform tt = CGAffineTransformConcat(t2, _svgWrap.transform);
    
    [_svg genData:tt mmPerPixel:_photoAnalyzer.mmPerPixel p1:_photoAnalyzer.p1 p2:_photoAnalyzer.p2];
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    CGFloat newZoomScale = _scroll.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, _scroll.maximumZoomScale);
    
    CGSize scrollViewSize = _scroll.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [_scroll zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    CGFloat newZoomScale = _scroll.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, _scroll.minimumZoomScale);
    [_scroll setZoomScale:newZoomScale animated:YES];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollViewContents];
}

- (void)centerScrollViewContents {
    CGSize boundsSize = _scroll.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}


-(void)scale:(id)sender {
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastM = _svgWrap.transform;
        return;
    }
    _svg.hidden = NO;
    _svgCanvas.hidden = YES;
    CGFloat t = [(UIPinchGestureRecognizer*)sender scale];
    [_svgWrap setTransform:CGAffineTransformScale(_lastM, t, t)];
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        [self refreshCanvas];
    }
}

-(void)rotate:(id)sender {
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastM = _svgWrap.transform;
        return;
    }
    _svg.hidden = NO;
    _svgCanvas.hidden = YES;
    CGFloat t = [(UIRotationGestureRecognizer*)sender rotation];
    [_svgWrap setTransform:CGAffineTransformRotate(_lastM, t)];
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        [self refreshCanvas];
    }
}

-(void)move:(id)sender {
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastM = _svgWrap.transform;
        return;
    }
    _svg.hidden = NO;
    _svgCanvas.hidden = YES;
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:_svgWrap];
    [_svgWrap setTransform:CGAffineTransformTranslate(_lastM, translatedPoint.x, translatedPoint.y)];
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        [self refreshCanvas];
    }
}
@end
