//
//  Spray.h
//  SVGTest
//
//  Created by tyrande on 13-12-9.
//  Copyright (c) 2013年 crane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Spray : NSObject
@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat weight;
@property (nonatomic) CGFloat lineWeight;
@property (nonatomic) CGFloat flow;
@property (nonatomic) CGFloat lowerSpeed;

-(id)initWithPosition:(CGPoint)p;

-(void)moveTo:(CGPoint)p;
@end
