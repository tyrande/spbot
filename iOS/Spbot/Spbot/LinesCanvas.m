//
//  LinesCanvas.m
//  Spbot
//
//  Created by claire on 11/30/13.
//  Copyright (c) 2013 claire. All rights reserved.
//

#import "LinesCanvas.h"
@interface LinesCanvas ()
@property (nonatomic) CGPoint point;
@property (nonatomic) CGPoint point1;
@property (nonatomic) CGPoint point2;
@end

@implementation LinesCanvas

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setPoint:(CGPoint)p point1:(CGPoint)p1 point2:(CGPoint)p2
{
    _point = p;
    _point1 = p1;
    _point2 = p2;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(contextRef, 1.0f);
    [[UIColor colorWithRed:97/255.0 green:177/255.0 blue:245/255.0 alpha:1] setStroke];
	CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, _point1.x, _point1.y);
    CGContextAddLineToPoint(contextRef, _point2.x, _point2.y);
    CGContextStrokePath(contextRef);
    
    if (_point.x > 0 && _point.y > 0) {
        [[UIColor colorWithRed:149/255.0 green:27/255.0 blue:39/255.0 alpha:1] setStroke];
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, _point1.x, _point1.y);
        CGContextAddLineToPoint(contextRef, _point.x, _point.y);
        CGContextStrokePath(contextRef);
        
        [[UIColor colorWithRed:9/255.0 green:95/255.0 blue:15/255.0 alpha:1] setStroke];
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, _point2.x, _point2.y);
        CGContextAddLineToPoint(contextRef, _point.x, _point.y);
        CGContextStrokePath(contextRef);
    }
}

@end
