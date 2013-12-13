//
//  SVGPoint.m
//  SVGTest
//
//  Created by tyrande on 13-12-4.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import "SVGPoint.h"

@implementation SVGPoint

-(id)initWithSvg:(SVGView *)svg X:(CGFloat)x Y:(CGFloat)y
{
    self = [super initWithSvg:svg];
    if (self) {
        _point = CGPointMake(x, y);
    }
    return self;
}

-(id)initWithSvg:(SVGView *)svg CGPoint:(CGPoint)p
{
    self = [super initWithSvg:svg];
    if (self) {
        _point = p;
    }
    return self;
}

-(id)initWithSvg:(SVGView *)svg Point:(SVGPoint *)p
{
    self = [super initWithSvg:svg];
    if (self) {
        _point = p.point;
    }
    return self;
}

-(void)moveToPoint:(SVGPoint *)p { _point = p.point; }

-(CGPoint)end { return _point; }

-(CGPoint)reflectionOfEndControl { return _point; }

-(void)draw
{
    CGContextMoveToPoint(self.svg.context, _point.x*self.svg.ratio, _point.y*self.svg.ratio);
}

-(void)drawWithLines
{
    CGContextMoveToPoint(self.svg.context, _point.x*self.svg.ratio, _point.y*self.svg.ratio);
}

-(void)drawLines
{
    CGPoint point = CGPointApplyAffineTransform(_point, self.svg.trans);
    CGContextMoveToPoint(self.svg.context, point.x, point.y);
}

-(void)addLinePointsToArray:(NSMutableArray *)ropeLens
{
    CGPoint point = CGPointApplyAffineTransform(_point, self.svg.trans);
    [ropeLens addObject:[NSNumber numberWithFloat:point.x]];
    [ropeLens addObject:[NSNumber numberWithFloat:point.y]];
    [ropeLens addObject:[NSNumber numberWithBool:YES]];
}
@end
