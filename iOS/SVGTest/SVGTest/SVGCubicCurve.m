//
//  SVGCubicCurve.m
//  SVGTest
//
//  Created by tyrande on 13-12-4.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import "SVGCubicCurve.h"

@implementation SVGCubicCurve

-(id)initWithStart:(CGPoint)start StartControl:(CGPoint)startControl EndControl:(CGPoint)endControl End:(CGPoint)end
{
    self = [super init];
    if (self) {
        _startPoint = start;
        _startControlPoint = startControl;
        _endControlPoint = endControl;
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
    return ccp(2*_endPoint.x - _endControlPoint.x, 2*_endPoint.y - _endControlPoint.y);
}

-(CGPoint)deCasteljauPoint:(CGFloat)t
{
    CGPoint k10 = DE_CTL(_startPoint, _startControlPoint, t);
    CGPoint k11 = DE_CTL(_startControlPoint, _endControlPoint, t);
    CGPoint k12 = DE_CTL(_endControlPoint, _endPoint, t);
    CGPoint k20 = DE_CTL(k10, k11, t);
    CGPoint k21 = DE_CTL(k11, k12, t);
    return DE_CTL(k20, k21, t);
}

-(CGFloat)maxLen
{
    CGFloat maxDist = ccpDistance(_startPoint, _startControlPoint);
    CGFloat dist = ccpDistance(_endControlPoint, _endPoint);
    if ( dist > maxDist) { maxDist = dist; }
    dist = ccpDistance(_startPoint, _endPoint);
    if ( dist > maxDist) { maxDist = dist; }
    dist = ccpDistance(_startControlPoint, _endControlPoint);
    if ( dist > maxDist) { maxDist = dist; }
    return maxDist;
}

-(void)draw:(CGContextRef)context ratio:(CGFloat)ratio
{
    CGContextAddCurveToPoint(context, _startControlPoint.x*ratio, _startControlPoint.y*ratio, _endControlPoint.x*ratio, _endControlPoint.y*ratio, _endPoint.x*ratio, _endPoint.y*ratio);
}

@end
