//
//  SVGQuadraticCurve.m
//  SVGTest
//
//  Created by tyrande on 13-12-4.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import "SVGQuadraticCurve.h"

@implementation SVGQuadraticCurve

-(id)initWithStart:(CGPoint)start Control:(CGPoint)control End:(CGPoint)end
{
    self = [super init];
    if (self) {
        _startPoint = start;
        _controlPoint = control;
        _endPoint = end;
    }
    return self;
}

-(CGPoint)end
{
    return _endPoint;
}

-(CGPoint)reflectionOfEndControl
{
    return ccp(2*_endPoint.x - _controlPoint.x, 2*_endPoint.y - _controlPoint.y);
}

-(CGPoint)deCasteljauPoint:(CGFloat)t
{
    CGPoint k10 = DE_CTL(_startPoint, _controlPoint, t);
    CGPoint k11 = DE_CTL(_controlPoint, _endPoint, t);
    return DE_CTL(k10, k11, t);
}

-(CGFloat)maxLen
{
    CGFloat maxDist = ccpDistance(_startPoint, _controlPoint);
    CGFloat dist = ccpDistance(_controlPoint, _endPoint);
    if ( dist > maxDist) { maxDist = dist; }
    dist = ccpDistance(_startPoint, _endPoint);
    if ( dist > maxDist) { maxDist = dist; }
    return maxDist;
}

-(void)draw:(CGContextRef)context ratio:(CGFloat)ratio
{
    CGContextAddQuadCurveToPoint(context, _controlPoint.x*ratio, _controlPoint.y*ratio, _endPoint.x*ratio, _endPoint.y*ratio);
}
@end
