//
//  PhotoAnalyzer.m
//  SpbotPhoto
//
//  Created by crane on 12/11/13.
//  Copyright (c) 2013 crane. All rights reserved.
//

#import "PhotoAnalyzer.h"
#import <opencv2/opencv.hpp>
#import "CGPointExtension.h"

using namespace cv;

@implementation PhotoAnalyzer

- (NSArray *)_processImage:(Mat&)image
{
    Mat image_gray;
    cvtColor(image, image, COLOR_BGR2HSV);
    inRange(image, Scalar(100,160,20), Scalar(140,255,255), image);
    
    vector<Vec3f> circles;
    HoughCircles(image, circles, CV_HOUGH_GRADIENT, 1, image.cols/10, 1, 1, 1, 20);
    
    if (circles.size() >= 3){
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:circles.size()];
        for( size_t i = 0; i < circles.size(); i++ ){
            Vec3f c = circles[i];
            [points addObject:@[[NSNumber numberWithFloat:c[0]], [NSNumber numberWithFloat:c[2]], [NSNumber numberWithFloat:c[1]]]];
        }
        [points sortUsingComparator:^ NSComparisonResult(NSArray *a, NSArray *b){
            return [[a lastObject] compare:[b lastObject]];
        }];
        if (points.count > 3) {
            [points removeObjectsInRange:NSMakeRange(3, points.count - 3)];
        }
        if ([points[0][0] compare:points[1][0]] == NSOrderedDescending) {
            NSArray *a = points[0];
            NSArray *b = points[1];
            [points replaceObjectAtIndex:0 withObject:b];
            [points replaceObjectAtIndex:1 withObject:a];
        }
        
        _p1 = ccp([points[0][0] floatValue], [points[0][2] floatValue]);
        _p2 = ccp([points[1][0] floatValue], [points[1][2] floatValue]);
        _p3 = ccp([points[2][0] floatValue], [points[2][2] floatValue]);
        
//        int x = 210;
//        int y = 176;
//        int h = image.at<Vec3b>(x, y)[0];
//        int s = image.at<Vec3b>(x, y)[1];
//        int v = image.at<Vec3b>(x, y)[2];
//        
//        NSLog(@"===== %d,%d %d,%d,%d", x, y, h, s, v);
        
        return points;
    }
    return nil;
}

-(UIImage *)procImage:(UIImage *)image
{
    CGFloat w = image.size.width/3.0;
    CGFloat h = image.size.height/3.0;
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [image drawInRect:CGRectMake(0, 0, w, h)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    Mat img = [self cvMatFromUIImage:image];
    NSArray *ps = [self _processImage:img];
    NSLog(@"%@",ps);
    NSLog(@"%f,%f",w, h);
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [image drawInRect:CGRectMake(0, 0, w, h)];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 1.0f);
    [[UIColor colorWithRed:0 green:1 blue:0 alpha:1] setStroke];
    for (NSArray *p in ps) {
        CGFloat x = [[p objectAtIndex:0] floatValue];
        CGFloat y = [[p objectAtIndex:2] floatValue];
        CGFloat r = [[p objectAtIndex:1] floatValue];
        CGContextAddEllipseInRect(contextRef, CGRectMake(x-r, y-r, 2*r, 2*r));
    }
    CGContextStrokePath(contextRef);
    
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _mmPerPixel = 300.0 / ccpDistance(_p1, _p3);
    NSLog(@"mm/pixel: %f", _mmPerPixel);
    
//    return [self UIImageFromCVMat:img];
    return image2;
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}
@end
