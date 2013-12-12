//
//  SVGLine.h
//  SVGTest
//
//  Created by crane on 12/4/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVGView.h"

@interface SVGMetaPath : NSObject
@property (strong, nonatomic) SVGView *svg;
@property (strong, nonatomic) NSString *points;
@property (strong, nonatomic) NSMutableArray *curves;

-(id)initWithPoints:(NSString *)points svg:(SVGView *)svg;
-(void)draw;
-(void)drawWithLines;
-(void)drawLines;
@end
