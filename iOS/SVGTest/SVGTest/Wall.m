//
//  Wall.m
//  SVGTest
//
//  Created by tyrande on 13-12-9.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import "Wall.h"

@implementation Wall

-(id)initWithPositionA:(CGPoint) pA PositionB:(CGPoint) pB
{
    self = [super init];
    if (self) {
        _motorA = [[Motor alloc] initWithPosition:pA];
        _motorB = [[Motor alloc] initWithPosition:pB];
        _spray = [[Spray alloc] initWithPosition:pA];
        _scale = 4;  // mm/px
    }
    return self;
}

-(CGFloat)ropeALen { return ccpDistance(_motorA.position, _spray.position); }
-(CGFloat)ropeBLen { return ccpDistance(_motorB.position, _spray.position); }

-(CGFloat)sinRopeAAngle
{
    if (_motorA.position.x == _spray.position.x) {
        return 0.0;
    }else{
        CGFloat dx = _spray.position.x - _motorA.position.x;
        CGFloat dy = _spray.position.y - _motorA.position.y;
        return sqrtf(powf(dx, 2)/(powf(dx, 2) + powf(dy, 2)));
    }
}

-(CGFloat)sinRopeBAngle
{
    if (_motorB.position.x == _spray.position.x) {
        return 0.0;
    }else{
        CGFloat dx = _spray.position.x - _motorB.position.x;
        CGFloat dy = _spray.position.y - _motorB.position.y;
        return sqrtf(powf(dx, 2)/(powf(dx, 2) + powf(dy, 2)));
    }
}

-(CGFloat)cosRopeAAngle
{
    if (_motorA.position.y == _spray.position.y) {
        return 0.0;
    }else{
        CGFloat dx = _spray.position.x - _motorA.position.x;
        CGFloat dy = _spray.position.y - _motorA.position.y;
        return sqrtf(powf(dy, 2)/(powf(dx, 2) + powf(dy, 2)));
    }
}

-(CGFloat)cosRopeBAngle
{
    if (_motorB.position.y == _spray.position.y) {
        return 0.0;
    }else{
        CGFloat dx = _spray.position.x - _motorB.position.x;
        CGFloat dy = _spray.position.y - _motorB.position.y;
        return sqrtf(powf(dy, 2)/(powf(dx, 2) + powf(dy, 2)));
    }
}

-(CGFloat)sinRopeABAngle
{
    return [self sinRopeBAngle]*[self cosRopeAAngle] + [self cosRopeBAngle]*[self sinRopeAAngle];
}

-(CGFloat)ropeAForce
{
//    CGFloat ropeAAngle = ccpAngle(_motorA.position, _spray.position);
//    CGFloat ropeBAngle = ccpAngle(_motorB.position, _spray.position);
//    return _spray.weight*sinf(ropeBAngle)/sinf(ropeAAngle + ropeBAngle);
    return _spray.weight*[self sinRopeBAngle]/[self sinRopeABAngle];
}

-(CGFloat)ropeBForce
{
//    CGFloat ropeAAngle = ccpAngle(_motorA.position, _spray.position);
//    CGFloat ropeBAngle = ccpAngle(_motorB.position, _spray.position);
//    NSLog(@"%f, %f", _spray.position.x, _spray.position.y);
//    NSLog(@"%f, %f", ropeAAngle, ropeBAngle);
//    return _spray.weight*sinf(ropeAAngle)/sinf(ropeAAngle + ropeBAngle);
    
    return _spray.weight*[self sinRopeAAngle]/[self sinRopeABAngle];
}

-(CGFloat)deltaRopeALenFromP1:(CGPoint)p1 ToP2:(CGPoint)p2
{
    return fabsf(ccpDistance(p1, _motorA.position) - ccpDistance(p2, _motorA.position));
}

-(CGFloat)deltaRopeBLenFromP1:(CGPoint)p1 ToP2:(CGPoint)p2
{
    return fabsf(ccpDistance(p1, _motorB.position) - ccpDistance(p2, _motorB.position));
}

-(void)setMotorRPM:(CGFloat)rpm
{
    _motorA.rpm = rpm;
    _motorB.rpm = rpm;
}

-(void)setMotorWheelDiameter:(CGFloat)diameter
{
    _motorA.wheelDiameter = diameter;
    _motorB.wheelDiameter = diameter;
}

-(void)drawForceArea:(CGContextRef)context Width:(int) width Height:(int) height
{
    CGFloat mForce = [_motorA pullOutForce];
    CGFloat df = 0;
    for (int j=0; j<height; j++) {
        for (int i=0; i<width; i++) {
            [_spray moveTo:ccp(i, j)];
            df = (_motorB.position.y - _motorA.position.y)*i + (_motorA.position.x - _motorB.position.x)*j + (_motorB.position.x*_motorA.position.y - _motorA.position.x*_motorB.position.y);
            if (i > _motorA.position.x && i < _motorB.position.x && df < 0) {
                if ( mForce > [self ropeAForce] && mForce > [self ropeBForce]) {
                    CGContextFillRect(context, CGRectMake(i-0.5, j-0.5, 1, 1));
                }
            }
        }
    }
}

-(void)drawStepArea:(CGContextRef)context Width:(int) width Height:(int) height
{
    NSLog(@"max rope speed %f", [_motorA maxRopeSpeed]);
    CGFloat maxDelta = [_motorA maxRopeSpeed]*_scale/_spray.lowerSpeed;
    
    CGFloat df = 0;
    for (int j=0; j<height; j++) {
        for (int i=0; i<width; i++) {
            df = (_motorB.position.y - _motorA.position.y)*i + (_motorA.position.x - _motorB.position.x)*j + (_motorB.position.x*_motorA.position.y - _motorA.position.x*_motorB.position.y);
            if (i > _motorA.position.x && i < _motorB.position.x && df < 0) {
                CGFloat dau = [self deltaRopeALenFromP1:ccp(i, j) ToP2:ccp(i, j - 1)];
                CGFloat dar = [self deltaRopeALenFromP1:ccp(i, j) ToP2:ccp(i + 1, j)];
                CGFloat dad = [self deltaRopeALenFromP1:ccp(i, j) ToP2:ccp(i, j + 1)];
                CGFloat dal = [self deltaRopeALenFromP1:ccp(i, j) ToP2:ccp(i - 1, j)];
                
                CGFloat dbu = [self deltaRopeBLenFromP1:ccp(i, j) ToP2:ccp(i, j - 1)];
                CGFloat dbr = [self deltaRopeBLenFromP1:ccp(i, j) ToP2:ccp(i + 1, j)];
                CGFloat dbd = [self deltaRopeBLenFromP1:ccp(i, j) ToP2:ccp(i, j + 1)];
                CGFloat dbl = [self deltaRopeBLenFromP1:ccp(i, j) ToP2:ccp(i - 1, j)];
                
                if (dau < maxDelta && dar < maxDelta && dad < maxDelta && dal < maxDelta && dbu < maxDelta && dbr < maxDelta && dbd < maxDelta && dbl < maxDelta) {
                    CGContextFillRect(context, CGRectMake(i-0.5, j-0.5, 1, 1));
                }
            }
        }
    }
}

-(void)draw:(CGContextRef)context Width:(int) width Height:(int) height
{
    
    [self setMotorRPM:300];
    [self setMotorWheelDiameter:23];
    
    CGContextSetRGBFillColor(context, 0.0, 0.5, 0.0, 0.5);
    [self drawForceArea:context Width:width Height:height];
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.5, 0.5);
    [self drawStepArea:context Width:width Height:height];
    
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(context);
    CGContextAddArc(context, _motorA.position.x, _motorA.position.y, 4, 0, 2*M_PI, YES);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, _motorB.position.x, _motorB.position.y, 4, 0, 2*M_PI, YES);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    [_spray moveTo:ccp(100, 100)];
    CGContextBeginPath(context);
    CGContextAddArc(context, _spray.position.x, _spray.position.y, 4, 0, 2*M_PI, YES);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    NSLog(@"view width %dpx, height %dpx", width, height);
    NSLog(@"wall width %.2fm, height %.2fm", width*_scale/1000, height*_scale/1000);
    NSLog(@"motor A position %.2f, %.2f", _motorA.position.x, _motorA.position.y);
    NSLog(@"motor B position %.2f, %.2f", _motorB.position.x, _motorB.position.y);
    NSLog(@"spray position %.2f, %.2f", _spray.position.x, _spray.position.y);
    NSLog(@"motor rpm %.2fr/min", _motorA.rpm);
    NSLog(@"motor step speed %.2fstep/s", [_motorA stepSpeed]);
    NSLog(@"spray weight %.2fg", _spray.weight*1000);
    NSLog(@"rope force A %.2fg, B %.2fg", [self ropeAForce]*1000, [self ropeBForce]*1000);
    
    NSLog(@"motor pull out torque %.2fkg force %.2fkg", [_motorA pullOutTorque], [_motorA pullOutForce]);
}
@end
