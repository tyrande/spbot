//
//  SVGQuadraticCurve.h
//  SVGTest
//
//  Created by tyrande on 13-12-4.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import "SVGPathCommand.h"

@interface SVGQuadraticCurve : SVGPathCommand
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint controlPoint;
@property (nonatomic) CGPoint endPoint;

-(id)initWithSvg:(SVGView *)svg Start:(CGPoint)start Control:(CGPoint)control End:(CGPoint)end;

@end
