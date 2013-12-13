//
//  SVGFactory.h
//  SVGTest
//
//  Created by crane on 12/4/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVGView : UIView

@property (nonatomic) CGFloat ratio; //预览变换比例
@property (nonatomic) CGAffineTransform trans; //折线图输出变换矩阵
@property (nonatomic) CGFloat minLen; //切折线最短距离，svg自身坐标
@property (nonatomic) CGContextRef context; //画布


@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) BOOL linesDebug;

@property (strong, nonatomic) NSMutableArray *elements;

-(void)loadFromFile:(NSString *)fileName;
-(void)drawLines:(CGContextRef)contextRef transform:(CGAffineTransform)t mmPerPixel:(CGFloat)mmpp;
-(id)genData:(CGAffineTransform)t mmPerPixel:(CGFloat)mmpp p1:(CGPoint)p1 p2:(CGPoint)p2;
@end
