//
//  FixPoint.m
//  Spbot
//
//  Created by claire on 11/30/13.
//  Copyright (c) 2013 claire. All rights reserved.
//

#import "FixPinCircle.h"

@interface FixPinCircle ()
@end

@implementation FixPinCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setRadius:(CGFloat)r x:(CGFloat)x y:(CGFloat)y
{
    self.frame = CGRectMake(x-r, y, r*2, r);
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.2] setStroke];
    
    CGFloat r = self.frame.size.height;

	CGContextSetLineWidth(contextRef, r);
    if (_rightPoint) {
        CGContextAddArc(contextRef, r, 0, r/2.0, M_PI/180.0*100, M_PI/180.0*160, 0);
    }else{
        CGContextAddArc(contextRef, r, 0, r/2.0, M_PI/180.0*20, M_PI/180.0*80, 0);
    }
    
    CGContextStrokePath(contextRef);
}
@end
