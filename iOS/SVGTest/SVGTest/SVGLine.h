//
//  SVGLine.h
//  SVGTest
//
//  Created by tyrande on 13-12-4.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVGPathCommand.h"

@interface SVGLine : SVGPathCommand
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;

-(id)initWithSvg:(SVGView *)svg Start:(CGPoint)start End:(CGPoint)end;

-(CGFloat)len;
@end
