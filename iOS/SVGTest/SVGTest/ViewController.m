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

@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    SVGView *svg = [[SVGView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    [svg loadFromFile:@"light-bulb-4"];
    [self.view addSubview:svg];
}

@end
