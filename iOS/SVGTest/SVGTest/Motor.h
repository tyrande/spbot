//
//  Motor.h
//  SVGTest
//
//  Created by tyrande on 13-12-9.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Motor : NSObject
@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat holdingTorque;
@property (nonatomic) CGFloat wheelDiameter;
@property (nonatomic) CGFloat stepAngle;
@property (nonatomic) CGFloat rpm;

@property (strong, nonatomic) NSArray *rpmShift;
@property (strong, nonatomic) NSArray *pullOutTorqueShift;

-(id)initWithPosition:(CGPoint)p;

-(void)moveTo:(CGPoint)p;

-(CGFloat)holdingForce;
-(CGFloat)pullOutTorque;
-(CGFloat)pullOutForce;
-(CGFloat)stepLen;
-(CGFloat)maxRopeSpeed;
-(CGFloat)stepSpeed;
@end
