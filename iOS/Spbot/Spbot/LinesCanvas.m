//
//  LinesCanvas.m
//  Spbot
//
//  Created by claire on 11/30/13.
//  Copyright (c) 2013 claire. All rights reserved.
//

#import "LinesCanvas.h"
#import "ViewController.h"

@interface LinesCanvas ()
@property (nonatomic) NSArray *points;
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

- (void)setPoints:(NSArray *)points
{
    _points = points;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(contextRef, 1.0f);
    
    [[UIColor colorWithRed:1 green:0 blue:0 alpha:1] setStroke];
    CGContextMoveToPoint(contextRef, 0, 100);
    CGContextAddLineToPoint(contextRef, 320, 100);
    CGContextMoveToPoint(contextRef, 160, 0);
    CGContextAddLineToPoint(contextRef, 160, 100);
    CGContextStrokePath(contextRef);
    
    [[UIColor colorWithRed:0 green:1 blue:0 alpha:1] setStroke];
    for (NSArray *p in _points) {
        CGFloat x = [[p objectAtIndex:0] floatValue]*_RATE_;
        CGFloat y = [[p objectAtIndex:2] floatValue]*_RATE_;
        CGFloat r = [[p objectAtIndex:1] floatValue]*_RATE_;
        
        CGContextAddEllipseInRect(contextRef, CGRectMake(x-r, y-r, 2*r, 2*r));
    }
    CGContextStrokePath(contextRef);
}

@end
