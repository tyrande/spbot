//
//  ViewController.h
//  Spbot
//
//  Created by claire on 11/30/13.
//  Copyright (c) 2013 claire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/cap_ios.h>
#import "MWPhotoBrowser.h"

#define _RATE_ (320.0f/288.0f)


@interface ViewController : UIViewController <CvVideoCameraDelegate, CvPhotoCameraDelegate, MWPhotoBrowserDelegate>

@end
