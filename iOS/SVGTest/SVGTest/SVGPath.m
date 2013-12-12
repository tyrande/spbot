//
//  SVGPath.m
//  SVGTest
//
//  Created by crane on 12/4/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import "SVGPath.h"
#import "SVGMetaPath.h"

@implementation SVGPath

-(id)initWithAttrs:(NSDictionary *)attrs svg:(id)svg
{
    self = [super initWithAttrs:attrs svg:svg];
    if (self) {
        [self parseLines];
    }
    return self;
}

-(void)parseLines
{
    NSString *d = [self.attrs objectForKey:@"d"];
    if (! d) return;
    
    d = [d stringByReplacingOccurrencesOfString:@",*(\\s+,*)+" withString:@"," options:NSRegularExpressionSearch range:NSMakeRange(0, d.length)];
    NSMutableArray * ls = [NSMutableArray array];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[Mm][^Mm]*" options:NSRegularExpressionCaseInsensitive error:&error];
    [regex enumerateMatchesInString:d
                            options:0
                              range:NSMakeRange(0, d.length)
                         usingBlock:^(NSTextCheckingResult *resultEle, NSMatchingFlags flagsEle, BOOL *stopEle) {
                             [ls addObject:[d substringWithRange:[resultEle rangeAtIndex:0]]];
                         }];
    
    _metaPaths = [NSMutableArray arrayWithCapacity:ls.count];
    for (NSString *l in ls) {
        if (l && l.length > 0) {
            [_metaPaths addObject:[[SVGMetaPath alloc] initWithPoints:l svg:self.svg]];
        }
    }
}

-(void)draw
{
    if (_metaPaths && _metaPaths.count > 0) {
        for (SVGMetaPath *l in _metaPaths) {
            [l draw];
        }
    }
}

-(void)drawWithLines
{
    if (_metaPaths && _metaPaths.count > 0) {
        for (SVGMetaPath *m in _metaPaths) {
            [m drawWithLines];
        }
    }
}

-(void)drawLines
{
    if (_metaPaths && _metaPaths.count > 0) {
        for (SVGMetaPath *m in _metaPaths) {
            [m drawLines];
        }
    }
}

@end
