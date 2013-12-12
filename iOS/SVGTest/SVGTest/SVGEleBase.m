//
//  SVGEleBase.m
//  SVGTest
//
//  Created by crane on 12/4/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import "SVGEleBase.h"
#import "SVGPath.h"

@implementation SVGEleBase

+(SVGEleBase *)create:(NSString *)eleName attrs:(NSDictionary *)attrs svg:(SVGView *)svg{
    if ([eleName isEqualToString:@"path"]) {
        return [[SVGPath alloc] initWithAttrs:attrs svg:svg];
    }
    
    return nil;
}

-(id)initWithAttrs:(NSDictionary *)attrs svg:svg
{
    self = [self init];
    if (self) {
        _svg = svg;
        _attrs = [NSDictionary dictionaryWithDictionary:attrs];
    }
    return self;
}

-(void)draw {}
-(void)drawWithLines {}
-(void)drawLines{}
@end
