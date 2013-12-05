//
//  SVGPoint.m
//  SVGTest
//
//  Created by tyrande on 13-12-4.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import "SVGPoint.h"

@implementation SVGPoint

-(id)initWithX:(CGFloat)x Y:(CGFloat)y
{
    self = [super init];
    if (self) {
        _point = CGPointMake(x, y);
    }
    return self;
}

-(id)initWithCGPoint:(CGPoint)p
{
    self = [super init];
    if (self) {
        _point = p;
    }
    return self;
}

-(id)initWithPoint:(SVGPoint *)p
{
    self = [super init];
    if (self) {
        _point = p.point;
    }
    return self;
}

-(void)moveToPoint:(SVGPoint *)p { _point = p.point; }

-(CGPoint)end { return _point; }

-(CGPoint)reflectionOfEndControl { return _point; }

-(void)draw:(CGContextRef)context ratio:(CGFloat)ratio
{
    CGContextMoveToPoint(context, _point.x*ratio, _point.y*ratio);
}

-(void)drawWithLines:(CGContextRef)context ratio:(CGFloat)ratio minLen:(CGFloat)minLen
{
    CGContextMoveToPoint(context, _point.x*ratio, _point.y*ratio);
}
@end
