//
//  PhotoAnalyzer.h
//  SpbotPhoto
//
//  Created by crane on 12/11/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoAnalyzer : NSObject
@property (nonatomic) CGFloat mmPerPixel;

@property (nonatomic) CGPoint p1;
@property (nonatomic) CGPoint p2;
@property (nonatomic) CGPoint p3;

-(UIImage *)procImage:(UIImage *)image;
@end
