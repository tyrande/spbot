//
//  SVGEleBase.h
//  SVGTest
//
//  Created by crane on 12/4/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SVGView.h"

@interface SVGEleBase : NSObject
@property (strong, nonatomic) NSDictionary *attrs;
@property (weak, nonatomic) SVGView *svg;

+(SVGEleBase *)create:(NSString *)eleName attrs:(NSDictionary *)attrs svg:(SVGView *)svg;

-(id)initWithAttrs:(NSDictionary *)attrs svg:svg;

-(void)draw;
-(void)drawWithLines;
-(void)drawLines;
-(void)addRopeLensToArray:(NSMutableArray *)ropeLens;
@end
