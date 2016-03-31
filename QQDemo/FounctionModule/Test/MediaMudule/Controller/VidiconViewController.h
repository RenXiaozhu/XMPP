//
//  VidiconViewController.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/6/17.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface VidiconViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>
{
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *captureVideo;
    AVCaptureVideoDataOutput *videoDataOut;
    AVCaptureAudioDataOutput *audioOut;

    AVAssetWriterInput *assetWriterInput;
    AVAssetWriterInputPixelBufferAdaptor *  assetWriterPixelBufferAdaptor;
    NSDateFormatter *dateFormatter;
    BOOL isExtra;
    NSMutableArray *packagesBufferMutableArray;
    int fps;
    NSMutableDictionary *currentPackageMutableDictionary;
    AVAssetWriter *assetWriter;
    AVAssetWriterInput * audioWriterInput;
}

@property (nonatomic,retain) AVCaptureSession *captureSession;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideo;
@property (nonatomic,retain) AVAssetWriterInput *assetWriterInput;
@property (nonatomic,retain) AVAssetWriterInput * audioWriterInput;
@property (nonatomic,retain) AVCaptureVideoDataOutput *videoDataOut;
@property (nonatomic,retain) AVCaptureAudioDataOutput *audioOut;
@property (nonatomic,retain) AVAssetWriter *assetWriter;
@property (nonatomic,retain) AVAssetWriterInputPixelBufferAdaptor *  assetWriterPixelBufferAdaptor;
@property (nonatomic,retain) NSDateFormatter *dateFormatter;
@property (nonatomic,assign) BOOL isExtra;
@property (nonatomic,retain) NSMutableArray *packagesBufferMutableArray;
@property (nonatomic,assign) int fps;
@property (nonatomic,retain) NSMutableDictionary *currentPackageMutableDictionary;
@end
