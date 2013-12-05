//
//  SVGFactory.m
//  SVGTest
//
//  Created by crane on 12/4/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import "SVGView.h"
#import "SVGEleBase.h"

@implementation SVGView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _width = 0;
        _height = 0;
    }
    return self;
}

-(void)loadFromFile:(NSString *)fileName
{
    _elements = [NSMutableArray array];
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"xml"]];
    NSString *xml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(\\w+)[^>]+>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *regexAttr = [NSRegularExpression regularExpressionWithPattern:@" (\\w+)=['\"]([^'\"]*)['\"]" options:NSRegularExpressionCaseInsensitive error:&error];
    
    [regex enumerateMatchesInString:xml
                            options:0
                              range:NSMakeRange(0, xml.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString *ele = [xml substringWithRange:[result rangeAtIndex:0]];
        NSString *eleName = [xml substringWithRange:[result rangeAtIndex:1]];
        
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        [regexAttr enumerateMatchesInString:ele
                                    options:0
                                      range:NSMakeRange(0, ele.length)
                                 usingBlock:^(NSTextCheckingResult *resultEle, NSMatchingFlags flagsEle, BOOL *stopEle) {
            [attrs setObject:[ele substringWithRange:[resultEle rangeAtIndex:2]]
                      forKey:[ele substringWithRange:[resultEle rangeAtIndex:1]]];
        }];
                             
        NSLog(@"%@",eleName);
        NSLog(@"%@",attrs);
                             
        SVGEleBase *eleObj = [SVGEleBase create:eleName attrs:attrs];
        if (eleObj) {
            [_elements addObject:eleObj];
        }
        if ([eleName isEqualToString:@"svg"] && [attrs objectForKey:@"width"] && [attrs objectForKey:@"height"]){
            [self svgElement:attrs];
        }
    }];
}

-(void)svgElement:(NSDictionary *)attrs
{
    NSString *ws = [attrs objectForKey:@"width"];
    _width = [[ws stringByReplacingOccurrencesOfString:@"[^.0-9]+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, ws.length)] floatValue];
    NSString *hs = [attrs objectForKey:@"height"];
    _height = [[hs stringByReplacingOccurrencesOfString:@"[^.0-9]+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, hs.length)] floatValue];
    
    NSLog(@"%f,%f", _width, _height);
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (_width == 0) return;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 1.0f);
    [[UIColor blackColor] setStroke];
    
    CGFloat ratio = self.frame.size.width / _width;
    for (SVGEleBase *ele in _elements) {
//        [ele draw:contextRef ratio:ratio];
        [ele drawWithLines:contextRef ratio:ratio minLen:100];
    }
    
    CGContextStrokePath(contextRef);
}

@end
