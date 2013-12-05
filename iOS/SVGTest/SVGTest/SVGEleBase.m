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

+(SVGEleBase *)create:(NSString *)eleName attrs:(NSDictionary *)attrs{
    if ([eleName isEqualToString:@"path"]) {
        return [[SVGPath alloc] initWithAttrs:attrs];
    }
    
    return nil;
}

-(id)initWithAttrs:(NSDictionary *)attrs
{
    self = [super init];
    if (self) {
        _attrs = [NSDictionary dictionaryWithDictionary:attrs];
    }
    return self;
}

-(void)draw:(CGContextRef)context ratio:(CGFloat)ratio
{
}

-(void)drawWithLines:(CGContextRef)context ratio:(CGFloat)ratio minLen:(CGFloat)minLen
{
}
@end
