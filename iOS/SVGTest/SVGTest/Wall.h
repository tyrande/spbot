//
//  Wall.h
//  SVGTest
//
//  Created by tyrande on 13-12-9.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Motor.h"
#import "Spray.h"

@interface Wall : NSObject
@property (strong, nonatomic) Motor *motorA;
@property (strong, nonatomic) Motor *motorB;

@property (strong, nonatomic) Spray *spray;

@property (nonatomic) CGFloat scale;

-(id)initWithPositionA:(CGPoint) pA PositionB:(CGPoint) pB;

-(void)draw:(CGContextRef)context Width:(int) width Height:(int) height;

@end
