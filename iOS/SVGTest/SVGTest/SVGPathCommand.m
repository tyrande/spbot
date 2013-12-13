//
//  SVGPathCommand.m
//  SVGTest
//
//  Created by tyrande on 13-12-4.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import "SVGPathCommand.h"

@implementation SVGPathCommand

-(id)initWithSvg:(SVGView *)svg
{
    self = [super init];
    if (self) {
        _svg = svg;
    }
    return self;
}

-(CGPoint)end{ return CGPointZero; }
-(CGPoint)reflectionOfEndControl{ return CGPointZero; }

-(CGFloat)maxLen{ return 0; }

-(CGPoint)deCasteljauPoint:(CGFloat)t { return [self end]; }

-(void)draw{}
-(void)drawWithLines
{
    CGFloat steps = ceilf([self maxLen]*self.svg.ratio/self.svg.minLen);
    CGPoint pointIter = CGPointZero;
    for (int i = 1; i <= steps; i++) {
        pointIter = [self deCasteljauPoint:(i/steps)];
        CGContextAddLineToPoint(self.svg.context, pointIter.x*self.svg.ratio, pointIter.y*self.svg.ratio);
    }
}
-(void)drawLines
{
    CGFloat steps = ceilf([self maxLen]/self.svg.minLen);
    CGPoint pointIter = CGPointZero;
    for (int i = 1; i <= steps; i++) {
        pointIter = CGPointApplyAffineTransform([self deCasteljauPoint:(i/steps)], self.svg.trans);
        CGContextAddLineToPoint(self.svg.context, pointIter.x, pointIter.y);
    }
}
-(void)addLinePointsToArray:(NSMutableArray *)ropeLens
{
    CGFloat steps = ceilf([self maxLen]/self.svg.minLen);
    CGPoint pointIter = CGPointZero;
    for (int i = 1; i <= steps; i++) {
        pointIter = CGPointApplyAffineTransform([self deCasteljauPoint:(i/steps)], self.svg.trans);
        [ropeLens addObject:[NSNumber numberWithFloat:pointIter.x]];
        [ropeLens addObject:[NSNumber numberWithFloat:pointIter.y]];
        [ropeLens addObject:[NSNumber numberWithBool:YES]];
    }
}
@end
