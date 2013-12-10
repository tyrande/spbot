//
//  SVGLine.h
//  SVGTest
//
//  Created by crane on 12/4/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVGMetaPath : NSObject
@property (strong, nonatomic) NSString *points;
@property (strong, nonatomic) NSMutableArray *curves;

-(id)initWithPoints:(NSString *)points;
-(void)draw:(CGContextRef)context ratio:(CGFloat)ratio;
-(void)drawWithLines:(CGContextRef)context ratio:(CGFloat)ratio minLen:(CGFloat)minLen;
-(void)drawLines:(CGContextRef)contextRef transform:(CGAffineTransform)t minLen:(int)minLen;
@end
