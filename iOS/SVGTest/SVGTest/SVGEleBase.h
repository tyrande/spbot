//
//  SVGEleBase.h
//  SVGTest
//
//  Created by crane on 12/4/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SVGEleBase : NSObject
@property (strong, nonatomic) NSDictionary *attrs;

+(SVGEleBase *)create:(NSString *)eleName attrs:(NSDictionary *)attrs;

-(id)initWithAttrs:(NSDictionary *)attrs;

-(void)draw:(CGContextRef)context ratio:(CGFloat)ratio;
-(void)drawWithLines:(CGContextRef)context ratio:(CGFloat)ratio minLen:(CGFloat)minLen;
-(void)drawLines:(CGContextRef)contextRef transform:(CGAffineTransform)t minLen:(int)minLen;
@end
