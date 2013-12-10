//
//  Motor.m
//  SVGTest
//
//  Created by tyrande on 13-12-9.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import "Motor.h"

@implementation Motor

-(id)initWithPosition:(CGPoint)p
{
    self = [super init];
    if (self) {
        _position = p;
        _holdingTorque = 12;  // kg*cm
        _wheelDiameter = 32;  // mm
        _stepAngle = 1.8;     //  degree
        
        _rpmShift = @[@30, @100, @200, @300, @600, @900, @1500, @2000]; // r/min
        _pullOutTorqueShift = @[@6.0, @6.0, @5.7, @5.3, @4.0, @3.5, @2.5, @0.7]; // kg*cm
        _rpm = 30;             // r/min
 
    }
    return self;
}

-(void)moveTo:(CGPoint)p { _position = p; }

-(CGFloat)holdingForce { return _holdingTorque*10*2/_wheelDiameter; }

-(CGFloat)pullOutTorque
{
    CGFloat rpmLevel = 0;
    CGFloat lowerRPM = 0;
    CGFloat upperRPM = 0;
    int rpmShiftCount = [_rpmShift count];
    for (int i=1; i < rpmShiftCount; i++) {
        upperRPM = [[_rpmShift objectAtIndex:i] floatValue];
        if (_rpm < upperRPM) {
            lowerRPM = [[_rpmShift objectAtIndex:i - 1] floatValue];
            rpmLevel = i;
            break;
        }
    }
    
    if (_rpm <= lowerRPM) {
        return [[_pullOutTorqueShift objectAtIndex:0] floatValue];
    }else if (_rpm >= upperRPM) {
        return [[_pullOutTorqueShift objectAtIndex:rpmShiftCount - 1] floatValue];
    }else {
        CGFloat lowerTorque = [[_pullOutTorqueShift objectAtIndex:rpmLevel - 1] floatValue];
        CGFloat upperTorque = [[_pullOutTorqueShift objectAtIndex:rpmLevel] floatValue];
        return lowerTorque + (upperTorque - lowerTorque)*(_rpm - lowerRPM)/(upperRPM - lowerRPM);
    }
}

-(CGFloat)pullOutForce { return [self pullOutTorque]*10.0*2/_wheelDiameter; }


-(CGFloat)stepLen { return _wheelDiameter*M_1_PI*_stepAngle/360; }

-(CGFloat)maxRopeSpeed { return _wheelDiameter*M_1_PI*_rpm/60; }  // mm/s

-(CGFloat)stepSpeed { return _rpm*360/60/_stepAngle; }  // step/s

@end
