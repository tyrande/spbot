//
//  SVGLine.m
//  SVGTest
//
//  Created by tyrande on 13-12-4.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import "SVGLine.h"

@implementation SVGLine

-(id)initWithStart:(CGPoint)start End:(CGPoint)end
{
    self = [super init];
    if (self) {
        _startPoint = start;
        _endPoint = end;
    }
    return self;
}

-(CGPoint)end { return _endPoint; }

-(CGPoint)reflectionOfEndControl { return _endPoint; }

-(CGPoint)deCasteljauPoint:(CGFloat)t
{
    return DE_CTL(_startPoint, _endPoint, t);
}

-(CGFloat)len { return ccpDistance(_startPoint, _endPoint); }

-(CGFloat)maxLen { return [self len]; }

-(void)draw:(CGContextRef)context ratio:(CGFloat)ratio
{
    CGContextAddLineToPoint(context, _endPoint.x*ratio, _endPoint.y*ratio);
}

@end
