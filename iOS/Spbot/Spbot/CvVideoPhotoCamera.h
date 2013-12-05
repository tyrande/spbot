//
//  CvVideoPhotoCamera.h
//  Spbot
//
//  Created by crane on 12/5/13.
//  Copyright (c) 2013 claire. All rights reserved.
//

#import <opencv2/highgui/cap_ios.h>

@interface CvVideoPhotoCamera : CvAbstractCamera<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureVideoDataOutput *videoDataOutput;
    
    dispatch_queue_t videoDataOutputQueue;
    CALayer *customPreviewLayer;
    
    BOOL grayscaleMode;
    
    BOOL recordVideo;
    BOOL rotateVideo;
    AVAssetWriterInput* recordAssetWriterInput;
    AVAssetWriterInputPixelBufferAdaptor* recordPixelBufferAdaptor;
    AVAssetWriter* recordAssetWriter;
    
    CMTime lastSampleTime;
    
    ////// photo
    AVCaptureStillImageOutput *stillImageOutput;
}

@property (nonatomic, assign) id<CvVideoCameraDelegate> delegate;
@property (nonatomic, assign) BOOL grayscaleMode;

@property (nonatomic, assign) BOOL recordVideo;
@property (nonatomic, assign) BOOL rotateVideo;
@property (nonatomic, retain) AVAssetWriterInput* recordAssetWriterInput;
@property (nonatomic, retain) AVAssetWriterInputPixelBufferAdaptor* recordPixelBufferAdaptor;
@property (nonatomic, retain) AVAssetWriter* recordAssetWriter;

- (void)adjustLayoutToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)layoutPreviewLayer;
- (void)saveVideo;
- (NSURL *)videoFileURL;

////////photo
@property (nonatomic, assign) id<CvPhotoCameraDelegate> delegatePhoto;
- (void)takePicture;
- (void)createStillImageOutput;
@end
