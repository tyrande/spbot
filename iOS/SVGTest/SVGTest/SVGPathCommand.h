//
//  SVGPathCommand.h
//  SVGTest
//
//  Created by tyrande on 13-12-4.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DE_CTL(p1, p2, t) ccpAdd(ccpMult(p1, 1 - t), ccpMult(p2, t))

@interface SVGPathCommand : NSObject
-(CGPoint)end;
-(CGPoint)reflectionOfEndControl;

-(CGFloat)maxLen;

-(void)draw:(CGContextRef)context ratio:(CGFloat)ratio;
-(void)drawWithLines:(CGContextRef)context ratio:(CGFloat)ratio minLen:(CGFloat)minLen;
@end
