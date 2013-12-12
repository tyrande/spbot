//
//  SVGFactory.h
//  SVGTest
//
//  Created by crane on 12/4/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVGView : UIView

@property (nonatomic) CGFloat ratio;
@property (nonatomic) CGAffineTransform trans;
@property (nonatomic) CGFloat minLen;
@property (nonatomic) CGPoint p1;
@property (nonatomic) CGPoint p2;
@property (nonatomic) CGFloat mmPrePixel;
@property (nonatomic) CGContextRef context;


@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) BOOL linesDebug;

@property (strong, nonatomic) NSMutableArray *elements;

-(void)loadFromFile:(NSString *)fileName;
-(void)drawLines:(CGContextRef)contextRef transform:(CGAffineTransform)t mmPerPixel:(CGFloat)mmpp;
-(id)genData:(CGAffineTransform)t mmPerPixel:(CGFloat)mmpp p1:(CGPoint)p1 p2:(CGPoint)p2;
@end
