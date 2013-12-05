//
//  SVGFactory.h
//  SVGTest
//
//  Created by crane on 12/4/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVGView : UIView
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) BOOL linesDebug;

@property (strong, nonatomic) NSMutableArray *elements;

-(void)loadFromFile:(NSString *)fileName;
@end
