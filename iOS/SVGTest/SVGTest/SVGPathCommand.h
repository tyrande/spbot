//
//  SVGPathCommand.h
//  SVGTest
//
//  Created by tyrande on 13-12-4.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVGView.h"

#define DE_CTL(p1, p2, t) ccpAdd(ccpMult(p1, 1 - t), ccpMult(p2, t))

@interface SVGPathCommand : NSObject
@property (strong, nonatomic) SVGView *svg;

-(id)initWithSvg:(SVGView *)svg;

-(CGPoint)end;
-(CGPoint)reflectionOfEndControl;

-(CGFloat)maxLen;

-(void)draw;
-(void)drawWithLines;
-(void)drawLines;
-(void)addLinePointsToArray:(NSMutableArray *)ropeLens;
@end
