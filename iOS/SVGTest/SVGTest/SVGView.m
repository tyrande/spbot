//
//  SVGFactory.m
//  SVGTest
//
//  Created by crane on 12/4/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import "SVGView.h"
#import "SVGEleBase.h"
#import "Wall.h"

@implementation SVGView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _width = 0;
        _height = 0;
        _linesDebug = NO;
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
                             
        SVGEleBase *eleObj = [SVGEleBase create:eleName attrs:attrs svg:self];
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
    
    _context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(_context, self.frame.size.width/100.0f);
    [[UIColor blackColor] setStroke];
    _minLen = 100;
    
    _ratio = self.frame.size.width / _width;
    for (SVGEleBase *ele in _elements) {
        if (_linesDebug) {
            [ele drawWithLines];
        }else{
            [ele draw];
        }
    }
    
    CGContextStrokePath(_context);
    
//    Wall *wall = [[Wall alloc] initWithPositionA:ccp(20, 40) PositionB:ccp(300, 50)];
//    [wall draw:contextRef Width:self.frame.size.width Height:self.frame.size.height];
}

-(void)drawLines:(CGContextRef)contextRef transform:(CGAffineTransform)t mmPerPixel:(CGFloat)mmpp;
{
    CGContextSetLineWidth(contextRef, 22.0/mmpp);
    [[UIColor blackColor] setStroke];
    
    _trans = t;
    _minLen = 100;
    _context = contextRef;
    
    for (SVGEleBase *ele in _elements) {
        [ele drawLines];
    }
    
    CGContextStrokePath(contextRef);
}

-(void)genData:(CGAffineTransform)t mmPerPixel:(CGFloat)mmpp p1:(CGPoint)p1 p2:(CGPoint)p2
{
    _trans = t;
    _minLen = 100;
    _mmPrePixel = mmpp;
    _p1 = p1;
    _p2 = p2;
    
    for (SVGEleBase *ele in _elements) {
    }
}
@end
