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

-(id)initWithSvg:(SVGView *)svg X:(CGFloat)x Y:(CGFloat)y;
-(id)initWithSvg:(SVGView *)svg CGPoint:(CGPoint)p;
-(id)initWithSvg:(SVGView *)svg Point:(SVGPoint *)p;

-(void)moveToPoint:(SVGPoint *)p;

@end
