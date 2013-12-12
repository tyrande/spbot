//
//  ViewController.m
//  SVGTest
//
//  Created by crane on 12/4/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import "ViewController.h"
#import "SVGView.h"

@interface ViewController ()
@property (strong, nonatomic) UISwitch *switchBtn;
@property (strong, nonatomic) UISwitch *switchBtn2;
@property (strong, nonatomic) UIButton *genData;
@property (strong, nonatomic) SVGView *svg;

@property (strong, nonatomic) UIView *svgwrap;
@property (strong, nonatomic) UIView *svg2;
@property (strong, nonatomic) UIImageView *imgv;
@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _svg = [[SVGView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    [_svg loadFromFile:@"light-bulb-4"];
    [self.view addSubview:_svg];
    
    ////////
    _svgwrap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    _svgwrap.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.05];
    _svgwrap.autoresizesSubviews = NO;
    _svgwrap.hidden = YES;
    _svgwrap.layer.anchorPoint = CGPointMake(0, 0);
    _svgwrap.center = CGPointMake(0, 0);
    [self.view addSubview:_svgwrap];
    
    _imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    _imgv.contentMode = UIViewContentModeTopLeft;
    _imgv.hidden = YES;
    [self.view addSubview:_imgv];
    
    _svg2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    _svg2.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.05];
    _svg2.layer.anchorPoint = CGPointMake(0, 0);
    _svg2.center = CGPointMake(0, 0);
    [_svgwrap addSubview:_svg2];
    
    
    CGAffineTransform t1 = CGAffineTransformMakeScale(0.8, 0.8);
    t1 = CGAffineTransformRotate(t1, 0.2);
    t1 = CGAffineTransformTranslate(t1, 100, 50);
    [_svgwrap setTransform:t1];
    
    CGAffineTransform t2 = CGAffineTransformMakeScale(0.8, 0.8);
    t2 = CGAffineTransformRotate(t2, 0.3);
    t2 = CGAffineTransformTranslate(t2, 50, 50);
    [_svg2 setTransform:t2];
    
    CGFloat r = 300.0 / _svg.width;
    CGAffineTransform t3 = CGAffineTransformMakeScale(r, r);
    CGAffineTransform tt = CGAffineTransformConcat(CGAffineTransformConcat(t3, t2), t1);
    
    NSLog(@"%f, %f, 0", tt.a, tt.b);
    NSLog(@"%f, %f, 0", tt.c, tt.d);
    NSLog(@"%f, %f, 1", tt.tx, tt.ty);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320.0f, 400.0f), FALSE, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_svg drawLines:context transform:tt mmPerPixel:4.0];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _imgv.image = img;
    
    
    /////
    _switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _switchBtn.center = CGPointMake(60, 420);
    _switchBtn.on = NO;
    [_switchBtn addTarget:self action:@selector(onChangeSwitch) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_switchBtn];
    
    _switchBtn2 = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _switchBtn2.center = CGPointMake(160, 420);
    _switchBtn2.on = NO;
    [_switchBtn2 addTarget:self action:@selector(onChangeSwitch2) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_switchBtn2];
    
    _genData = [[UIButton alloc] initWithFrame:CGRectMake(220, 400, 80, 40)];
    [_genData setTitle:@"Generate" forState:UIControlStateNormal];
    [_genData setTitleColor:[UIColor colorWithHue:203.0f/360.0f saturation:0.80f brightness:0.80f alpha:1.0f] forState:UIControlStateNormal];
    _genData.backgroundColor = [UIColor clearColor];
    [_genData addTarget:self action:@selector(onGenData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_genData];
}

-(void)onGenData
{
    CGAffineTransform t = CGAffineTransformMakeScale(0.5, 0.5);
    t = CGAffineTransformTranslate(t, 100, 100);
    [_svg genData:t mmPerPixel:4.0f p1:ccp(0, 0) p2:ccp(320, 0)];
}

-(void)onChangeSwitch
{
    _svg.linesDebug = _switchBtn.on;
    [_svg setNeedsDisplay];
}

-(void)onChangeSwitch2
{
    _svg.hidden = _switchBtn2.on;
    _svgwrap.hidden = !_switchBtn2.on;
    _imgv.hidden = !_switchBtn2.on;
}

@end
