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
        if (_linesDebug) {
            [ele drawWithLines:contextRef ratio:ratio minLen:100];
        }else{
            [ele draw:contextRef ratio:ratio];
        }
    }
    
    CGContextStrokePath(contextRef);
    
//    Wall *wall = [[Wall alloc] initWithPositionA:ccp(20, 40) PositionB:ccp(300, 50)];
//    [wall draw:contextRef Width:self.frame.size.width Height:self.frame.size.height];
}

-(void)drawLines:(CGContextRef)contextRef transform:(CGAffineTransform)t minLen:(int)minLen
{
    CGContextSetLineWidth(contextRef, 1.0f);
    [[UIColor blackColor] setStroke];
    
    for (SVGEleBase *ele in _elements) {
//        [ele drawWithLines:contextRef ratio:ratio minLen:100];
        [ele drawLines:contextRef transform:t minLen:100];
    }
    
//    CGPoint p1 = CGPointMake(0, 100);
//    CGPoint p2 = CGPointMake(512, 0);
//    p1 = CGPointApplyAffineTransform(p1, t);
//    p2 = CGPointApplyAffineTransform(p2, t);
//    NSLog(@"%f,%f %f,%f", p1.x, p1.y, p2.x, p2.y);
//    CGContextMoveToPoint(contextRef, p1.x, p1.y);
//    CGContextAddLineToPoint(contextRef, p2.x, p2.y);
//    
//    CGPoint pa = CGPointMake(0, 200);
//    CGPoint pb = CGPointMake(200, 200);
//    CGPoint pc = CGPointMake(200, 0);
//    CGPoint pd = CGPointMake(0, 0);
//    pa = CGPointApplyAffineTransform(pa, t);
//    pb = CGPointApplyAffineTransform(pb, t);
//    pc = CGPointApplyAffineTransform(pc, t);
//    pd = CGPointApplyAffineTransform(pd, t);
//    CGContextMoveToPoint(contextRef, pa.x, pa.y);
//    CGContextAddLineToPoint(contextRef, pb.x, pb.y);
//    CGContextAddLineToPoint(contextRef, pc.x, pc.y);
//    CGContextAddLineToPoint(contextRef, pd.x, pd.y);
//    CGContextAddLineToPoint(contextRef, pa.x, pa.y);
    
    CGContextStrokePath(contextRef);
}

@end
