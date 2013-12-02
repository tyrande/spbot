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
    self.frame = CGRectMake(x - r, y - r, r * 2, r * 2);
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.2] setFill];
    CGContextFillEllipseInRect(contextRef, CGRectMake(0, 0, self.frame.size.width, self.frame.size.width));
}
@end
