//
//  SVGPathCommand.m
//  SVGTest
//
//  Created by tyrande on 13-12-4.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import "SVGPathCommand.h"

@implementation SVGPathCommand

-(CGPoint)end{ return CGPointZero; }
-(CGPoint)reflectionOfEndControl{ return CGPointZero; }

-(CGFloat)maxLen{ return 0; }

-(CGPoint)deCasteljauPoint:(CGFloat)t { return [self end]; }

-(void)draw:(CGContextRef)context ratio:(CGFloat)ratio {}
-(void)drawWithLines:(CGContextRef)context ratio:(CGFloat)ratio minLen:(CGFloat)minLen
{
    CGFloat steps = ceilf([self maxLen]*ratio/minLen);
    CGPoint pointIter = CGPointZero;
    for (int i = 1; i <= steps; i++) {
        pointIter = [self deCasteljauPoint:(i/steps)];
        CGContextAddLineToPoint(context, pointIter.x*ratio, pointIter.y*ratio);
    }
}
@end
