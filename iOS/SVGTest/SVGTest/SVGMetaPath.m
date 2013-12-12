//
//  SVGLine.m
//  SVGTest
//
//  Created by crane on 12/4/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import "SVGMetaPath.h"
#import "SVGPathCommand.h"
#import "SVGPoint.h"
#import "SVGLine.h"
#import "SVGCubicCurve.h"
#import "SVGQuadraticCurve.h"

#define If(x,y) [[x objectAtIndex:y] floatValue]
#define Ip(x,y,z) CGPointMake([[x objectAtIndex:y] floatValue], [[x objectAtIndex:z] floatValue])
#define LAST_END [(SVGPathCommand *)[_curves lastObject] end]
#define LAST_REF [(SVGPathCommand *)[_curves lastObject] reflectionOfEndControl]

@implementation SVGMetaPath

-(id)initWithPoints:(NSString *)points svg:(SVGView *)svg
{
    self = [super init];
    if (self) {
        _svg = svg;
        _points = points;
        [self loadPoints];
    }
    return self;
}

-(void)loadPoints
{
    NSLog(@"%@", _points);
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\w)[,.0-9-]*" options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *regexP = [NSRegularExpression regularExpressionWithPattern:@",?(-?\\d*\\.?\\d+)" options:NSRegularExpressionCaseInsensitive error:&error];
    
    _curves = [NSMutableArray array];
    
    [regex enumerateMatchesInString:_points options:0 range:NSMakeRange(0, _points.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             NSString *dt = [_points substringWithRange:[result rangeAtIndex:0]];
                             NSString *command = [_points substringWithRange:[result rangeAtIndex:1]];
                             
                             NSLog(@"= %@",dt);
                             NSMutableArray *ps = [NSMutableArray array];
                             [regexP enumerateMatchesInString:dt options:0 range:NSMakeRange(0, dt.length)
                                                   usingBlock:^(NSTextCheckingResult *resultP, NSMatchingFlags flagsP, BOOL *stopP) {
                                                       [ps addObject:[dt substringWithRange:[resultP rangeAtIndex:1]]];
                                                  }];
                             
                             NSLog(@"- %@",ps);
                             [self addCommand:command params:ps];
                         }];
}

-(void)addCommand:(NSString *)command params:(NSArray *)ps
{
    switch ([command characterAtIndex:0]) {
        case 'M':
            [_curves addObject:[[SVGPoint alloc] initWithSvg:self.svg
                                                     CGPoint:Ip(ps, 0, 1)]];
            break;
        case 'L':
            [_curves addObject:[[SVGLine alloc] initWithSvg:self.svg
                                                      Start:LAST_END
                                                        End:Ip(ps, 0, 1)]];
            break;
        case 'l':
            [_curves addObject:[[SVGLine alloc] initWithSvg:self.svg
                                                      Start:LAST_END
                                                        End:ccpAdd(LAST_END, Ip(ps, 0, 1))]];
            break;
        case 'H':
            [_curves addObject:[[SVGLine alloc] initWithSvg:self.svg
                                                      Start:LAST_END
                                                        End:ccp(If(ps, 0), LAST_END.y)]];
            break;
        case 'h':
            [_curves addObject:[[SVGLine alloc] initWithSvg:self.svg
                                                      Start:LAST_END
                                                        End:ccp(LAST_END.x + If(ps, 0), LAST_END.y)]];
            break;
        case 'V':
            [_curves addObject:[[SVGLine alloc] initWithSvg:self.svg
                                                      Start:LAST_END
                                                        End:ccp(LAST_END.x, If(ps, 0))]];
            break;
        case 'v':
            [_curves addObject:[[SVGLine alloc] initWithSvg:self.svg
                                                      Start:LAST_END
                                                        End:ccp(LAST_END.x, LAST_END.y + If(ps, 0))]];
            break;
        case 'C':
            [_curves addObject:[[SVGCubicCurve alloc] initWithSvg:self.svg
                                                            Start:LAST_END
                                                     StartControl:Ip(ps, 0, 1)
                                                       EndControl:Ip(ps, 2, 3)
                                                              End:Ip(ps, 4, 5)]];
            break;
        case 'c':
            [_curves addObject:[[SVGCubicCurve alloc] initWithSvg:self.svg
                                                            Start:LAST_END
                                                     StartControl:ccpAdd(LAST_END, Ip(ps, 0, 1))
                                                       EndControl:ccpAdd(LAST_END, Ip(ps, 2, 3))
                                                              End:ccpAdd(LAST_END, Ip(ps, 4, 5))]];
            break;
        case 'S':
            [_curves addObject:[[SVGCubicCurve alloc] initWithSvg:self.svg
                                                            Start:LAST_END
                                                     StartControl:LAST_REF
                                                       EndControl:Ip(ps, 0, 1)
                                                              End:Ip(ps, 2, 3)]];
            break;
        case 's':
            [_curves addObject:[[SVGCubicCurve alloc] initWithSvg:self.svg
                                                            Start:LAST_END
                                                     StartControl:LAST_REF
                                                       EndControl:ccpAdd(LAST_END, Ip(ps, 0, 1))
                                                              End:ccpAdd(LAST_END, Ip(ps, 2, 3))]];
            break;
        case 'Q':
            [_curves addObject:[[SVGQuadraticCurve alloc] initWithSvg:self.svg
                                                                Start:LAST_END
                                                              Control:Ip(ps, 0, 1)
                                                                  End:Ip(ps, 2, 3)]];
            break;
        case 'q':
            [_curves addObject:[[SVGQuadraticCurve alloc] initWithSvg:self.svg
                                                                Start:LAST_END
                                                              Control:ccpAdd(LAST_END, Ip(ps, 0, 1))
                                                                  End:ccpAdd(LAST_END, Ip(ps, 2, 3))]];
            break;
        case 'T':
            [_curves addObject:[[SVGQuadraticCurve alloc] initWithSvg:self.svg
                                                                Start:LAST_END
                                                              Control:LAST_REF
                                                                  End:Ip(ps, 0, 1)]];
            break;
        case 't':
            [_curves addObject:[[SVGQuadraticCurve alloc] initWithSvg:self.svg
                                                                Start:LAST_END
                                                              Control:LAST_REF
                                                                  End:ccpAdd(LAST_END, Ip(ps, 0, 1))]];
            break;
        default:
            break;
    }
}

-(void)draw
{
    for (SVGPathCommand *c in _curves) {
        [c draw];
    }
}

-(void)drawWithLines
{
    for (SVGPathCommand *c in _curves) {
        [c drawWithLines];
    }
}
-(void)drawLines
{
    for (SVGPathCommand *c in _curves) {
        [c drawLines];
    }
}

-(void)addRopeLensToArray:(NSMutableArray *)ropeLens
{
    for (SVGPathCommand *c in _curves) {
        [c addRopeLensToArray:ropeLens];
    }
    [ropeLens replaceObjectAtIndex:([ropeLens count] - 1) withObject:[NSNumber numberWithBool:NO]];
}
@end
