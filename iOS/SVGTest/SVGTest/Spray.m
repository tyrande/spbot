//
//  Spray.m
//  SVGTest
//
//  Created by tyrande on 13-12-9.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import "Spray.h"

@implementation Spray

-(id)initWithPosition:(CGPoint)p
{
    self = [super init];
    if (self) {
        _position = p;
        _weight = 0.5;  // kg
        _lineWeight = 50;  // mm
        _lowerSpeed = 300/2.5;      // mm/s
        _flow = 10000;      // point/s
        
    }
    return self;
}

-(void)moveTo:(CGPoint)p { _position = p; }

@end
