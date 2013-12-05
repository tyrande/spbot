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
@property (strong, nonatomic) SVGView *svg;
@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _svg = [[SVGView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    [_svg loadFromFile:@"light-bulb-4"];
    [self.view addSubview:_svg];
    
    _switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _switchBtn.center = CGPointMake(160, 420);
    _switchBtn.on = NO;
    [_switchBtn addTarget:self action:@selector(onChangeSwitch) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_switchBtn];
}

-(void)onChangeSwitch
{
    _svg.linesDebug = _switchBtn.on;
    [_svg setNeedsDisplay];
}

@end
