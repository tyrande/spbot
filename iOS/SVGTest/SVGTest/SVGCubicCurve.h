//
//  SVGCubicCurve.h
//  SVGTest
//
//  Created by tyrande on 13-12-4.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import "SVGPathCommand.h"

@interface SVGCubicCurve : SVGPathCommand
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint startControlPoint;
@property (nonatomic) CGPoint endControlPoint;
@property (nonatomic) CGPoint endPoint;

-(id)initWithSvg:(SVGView *)svg Start:(CGPoint)start StartControl:(CGPoint)startControl EndControl:(CGPoint)endControl End:(CGPoint)end;
@end
