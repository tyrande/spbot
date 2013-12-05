//
//  SVGPoint.h
//  SVGTest
//
//  Created by tyrande on 13-12-4.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVGPathCommand.h"

@interface SVGPoint : SVGPathCommand
@property (nonatomic) CGPoint point;

-(id)initWithX:(CGFloat)x Y:(CGFloat)y;
-(id)initWithCGPoint:(CGPoint)p;
-(id)initWithPoint:(SVGPoint *)p;

-(void)moveToPoint:(SVGPoint *)p;

@end
