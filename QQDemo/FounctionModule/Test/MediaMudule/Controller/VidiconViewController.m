//
//  VidiconViewController.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/6/17.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "VidiconViewController.h"

@interface VidiconViewController ()
{
    BOOL _isCameraCanUse;
    NSString *tempUrl;
    dispatch_queue_t queue;
}
@end

@implementation VidiconViewController
@synthesize captureSession;
@synthesize captureVideo;
@synthesize assetWriterInput;
@synthesize videoDataOut;
@synthesize assetWriterPixelBufferAdaptor;
@synthesize isExtra;
@synthesize dateFormatter;
@synthesize fps;
@synthesize packagesBufferMutableArray;
@synthesize audioOut;
@synthesize assetWriter;
@synthesize audioWriterInput;
@synthesize currentPackageMutableDictionary;

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    _isCameraCanUse = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
//    
//    if (_isCameraCanUse)
//    {
//        [self initCapture];
//    }
//    // Do any additional setup after loading the view.
//}


- (void)initCapture
{
    self.captureSession = [[AVCaptureSession alloc]init];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *inputDevice = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [self.captureSession addInput:inputDevice];
    
    AVCaptureVideoDataOutput *captureOut = [[AVCaptureVideoDataOutput alloc]init];
    captureOut.alwaysDiscardsLateVideoFrames = YES;
    captureOut.minFrameDuration = CMTimeMake(1.0, 24.0);
//    [captureOut setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    
    [captureOut setSampleBufferDelegate:self queue:queue];
    
    NSString *key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber *value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *setting = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOut setVideoSettings:setting];
    
    
    [self.captureSession addOutput:captureOut];
    
 
    NSString *preset = 0;
    
    if (NSClassFromString(@"NSOrderedSet")
        &&[UIScreen mainScreen].scale>1
        &&[device supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540 ]
        )
    {
        preset = AVCaptureSessionPreset1920x1080;
    }
    
    if (!preset)
    {
        preset = AVCaptureSessionPresetMedium;
    }
    self.captureSession.sessionPreset = preset;
    
    self.captureVideo = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    self.captureVideo.frame = self.view.bounds;
    self.captureVideo.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.captureVideo];
    [self.captureSession beginConfiguration];
    [self.captureSession commitConfiguration];
    [self.captureSession startRunning];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.packagesBufferMutableArray = [[NSMutableArray alloc]init];
    self.fps = 30;
    [self initDateFormatter];
    
    [self setupCaptureSession];
    
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.exclusiveTouch = YES;
    [save setTitle:@"save" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    save.frame = CGRectMake(0, 0, 40, 25);
    [save addTarget:self action:@selector(stopWork) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:save];
    
    self.navigationItem.rightBarButtonItem = item;
//    [item release];
    
//    [self performSelector:@selector(stopWork) withObject:nil afterDelay:5];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.isExtra = YES;
    
    [self.captureSession startRunning];
}

- (void)initDateFormatter {
    
    self.dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yy-MM-dd--HH-mm-ss"];
}

- (NSString *)generateFilePathForMovie {
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains( NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *url = [arr objectAtIndex:0];
    
    tempUrl = [NSString stringWithFormat:@"%@/%@.mov",
               url,[dateFormatter stringFromDate:[NSDate date]]];
    return tempUrl;
}

- (NSDictionary *)settingsForWriterInput {
    
    int bitRate = (300 + /*self.currentQuality*/5 * 90) * 1024;      //NORMAL 750 * 1024
    
    NSDictionary *codecSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:bitRate], AVVideoAverageBitRateKey,
                                   nil];
    
    
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:320], AVVideoWidthKey,
                                   [NSNumber numberWithInt:480], AVVideoHeightKey,
                                   codecSettings, AVVideoCompressionPropertiesKey,
                                   nil];
    
    
    return videoSettings;
}

- (AVAssetWriterInput *)createVideoWriterInput {
    
    NSDictionary *videoSettings = [self settingsForWriterInput];
    
    return [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                              outputSettings:videoSettings];
}

- (void)setupCaptureSession

{
    NSError *error = nil;
    
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Create a device input with the device and add it to the session.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input)
    {
        // Handling the error appropriately.
    }
    [self.captureSession addInput:input];
    
    [self initVideoDataOut];
    [self initAudioDataOut];
    [self initPreview];
    [self initVideoAudioWriter];
    
    // Start the session running to start the flow of data
    [assetWriter startWriting];
    [assetWriter startSessionAtSourceTime:kCMTimeZero];
    [self.captureSession commitConfiguration];
    [self.captureSession startRunning];
    
    // Assign session to an ivar.
}


- (void)initVideoDataOut
{
    videoDataOut = [[AVCaptureVideoDataOutput alloc]init];
    // Configure your output.
    
    queue = dispatch_queue_create("myQueue", NULL);
    
    [videoDataOut setSampleBufferDelegate:self queue:queue];
    
    // Specify the pixel format
    videoDataOut.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                                             forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    // If you wish to cap the frame rate to a known value, such as 15 fps, set
    // minFrameDuration.
    //    videoDataOut.minFrameDuration = CMTimeMakeWithSeconds(1, 15);
    [self.captureSession addOutput:videoDataOut];
    
    NSString *preset = 0;
    
    //    if (NSClassFromString(@"NSOrderedSet")
    //        &&[UIScreen mainScreen].scale>1
    //        &&[device supportsAVCaptureSessionPreset:AVCaptureSessionPresetiFrame960x540 ]
    //        )
    //    {
    preset = AVCaptureSessionPreset1920x1080;
    //    }
    //
    //    if (!preset)
    //    {
    //        preset = AVCaptureSessionPresetMedium;
    //    }
    self.captureSession.sessionPreset = preset;
    
    for (AVCaptureOutput* output in self.captureSession.outputs)
    {
        
        if ([output isKindOfClass:[AVCaptureVideoDataOutput class]])
        {
            AVCaptureConnection* connection = [output connectionWithMediaType:AVMediaTypeVideo];
            
            CMTimeShow(connection.videoMinFrameDuration);
            CMTimeShow(connection.videoMaxFrameDuration);
            
            CMTime frameDuration = CMTimeMake(1, self.fps);
            
            if (connection.isVideoMinFrameDurationSupported)
                connection.videoMinFrameDuration = frameDuration;
            if (connection.isVideoMaxFrameDurationSupported)
                connection.videoMaxFrameDuration = frameDuration;
            
            CMTimeShow(connection.videoMinFrameDuration);
            CMTimeShow(connection.videoMaxFrameDuration);
            
        }
        else
        {
            AVCaptureConnection* connection = [output connectionWithMediaType:AVMediaTypeVideo];
            
            CMTimeShow(connection.videoMinFrameDuration);
            CMTimeShow(connection.videoMaxFrameDuration);
            
            if (connection.isVideoMinFrameDurationSupported)
                connection.videoMinFrameDuration = CMTimeMake(1, 20);
            if (connection.isVideoMaxFrameDurationSupported)
                connection.videoMaxFrameDuration = CMTimeMake(1, 20);
            
            CMTimeShow(connection.videoMinFrameDuration);
            CMTimeShow(connection.videoMaxFrameDuration);
        }
    }

}


- (void)initAudioDataOut
{
    NSError *error = nil;
    
    AVCaptureDevice * audioDevice1 = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioInput1 = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice1 error:&error];
    audioOut = [[AVCaptureAudioDataOutput alloc] init];
    [audioOut setSampleBufferDelegate:self queue:queue];
    
    [self.captureSession addInput:audioInput1];
    [self.captureSession addOutput:audioOut];
}


- (void)initPreview
{
    self.captureVideo = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    self.captureVideo.frame = self.view.bounds;
    self.captureVideo.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.captureVideo];
}

-(void) initVideoAudioWriter

{
    
    CGSize size = CGSizeMake(1080, 1920);
    
    NSString *betaCompressionDirectory = [NSString stringWithFormat:@"%@/%@" ,[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0],@"Movie1.mov"];
    
    tempUrl = [betaCompressionDirectory copy];
    
    NSFileManager *manage = [NSFileManager defaultManager];
    
    BOOL ret = [manage fileExistsAtPath:betaCompressionDirectory];
    if (ret)
    {
        [manage removeItemAtPath:betaCompressionDirectory error:nil];
    }
    
    NSError *error = nil;

    unlink([betaCompressionDirectory UTF8String]);
    
    //----initialize compression engine
    
    self.assetWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:betaCompressionDirectory]
        fileType:AVFileTypeQuickTimeMovie
        error:&error];
    self.assetWriter.shouldOptimizeForNetworkUse = YES;
    self.assetWriter.movieTimeScale = 30;
    NSParameterAssert(self.assetWriter);
    
    if(error)
        
        NSLog(@"error = %@", [error localizedDescription]);
    
    //配置文件写入器属性
    
    //视频编码率，即比特率
    NSDictionary *videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithDouble:1600*1000],AVVideoAverageBitRateKey,
                                           nil ];
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                //编码方式h.264
                AVVideoCodecH264, AVVideoCodecKey,
                //视频宽度
                [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                //视频高度
                [NSNumber numberWithInt:size.height],AVVideoHeightKey,
                //编码率
                videoCompressionProps, AVVideoCompressionPropertiesKey, nil];
    
    //初始化文件写入器，设置为AVMediaTypeVideo类型
    self.assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    NSParameterAssert(assetWriterInput);
   
    //实时获取录制信息
    assetWriterInput.expectsMediaDataInRealTime = YES;
    
    //缓存转接器设置
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                           
                                                           [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    //初始化缓存转接器，加入文件写入器
    self.assetWriterPixelBufferAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:assetWriterInput
    sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    
    //判断是否可以加入文件写入器assetWriter
    NSParameterAssert(assetWriterInput);
    NSParameterAssert([assetWriter canAddInput:assetWriterInput]);
    
    if ([assetWriter canAddInput:assetWriterInput])
        NSLog(@"I can add this input");
    else
        NSLog(@"i can't add this input");
    
    // Add the audio input
  
//音频轨道设置
    AudioChannelLayout acl;
    bzero( &acl, sizeof(acl));
    acl.mChannelLayoutTag = kAudioChannelLayoutTag_Mono;
    
    NSDictionary* audioOutputSettings = nil;
    
    audioOutputSettings = [ NSDictionary dictionaryWithObjectsAndKeys:
        //编码方式 AAC
            [ NSNumber numberWithInt: kAudioFormatMPEG4AAC ], AVFormatIDKey,
        //码率 比特率
            [ NSNumber numberWithInt:64000], AVEncoderBitRateKey,
            [ NSNumber numberWithFloat: 44100.0 ], AVSampleRateKey,
        //轨道数
            [ NSNumber numberWithInt: 1 ], AVNumberOfChannelsKey,
        //轨道tag
            [ NSData dataWithBytes: &acl length: sizeof( acl ) ], AVChannelLayoutKey,nil ];
    
    //音频写入器
    audioWriterInput = [AVAssetWriterInput
                         assetWriterInputWithMediaType: AVMediaTypeAudio
                         outputSettings: audioOutputSettings ];
    audioWriterInput.expectsMediaDataInRealTime = YES;
    
    // add input
    
    [assetWriter addInput:audioWriterInput];
    [assetWriter addInput:assetWriterInput];
    
}

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    
    // Create a UIImage from the sample buffer data
    
//    //  UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    [self updateCurrentPackageWithFrameImage:image];
    
    static int64_t frame = 0;
    
//    CMTime presentationTime = CMTimeMakeWithSeconds( frame, 30);
    
    CMTime lastSampleTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    
    if( frame == 0 && self.assetWriter.status != AVAssetWriterStatusWriting  )
    {
        [self.assetWriter startWriting];
        [self.assetWriter startSessionAtSourceTime:lastSampleTime];
    }
    
    if (captureOutput == videoDataOut)//视频输出接口
    {
        if( self.assetWriter.status >= AVAssetWriterStatusWriting )
        {
            if( self.assetWriter.status == AVAssetWriterStatusFailed )
            {
                NSLog(@"Warning: writer status is %d", self.assetWriter.status);
                NSLog(@"Error: %@", self.assetWriter.error);
                return;
            }
            else
            {
                if ([assetWriterInput isReadyForMoreMediaData])
                {
//将sample返回的data转化为image
                    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
                    UIImage *image = [self imageFromSampleBuffer:imageBuffer];
//                    sampleBuffer = nil;
                    
                    //创建像素缓存块
                    CVPixelBufferRef buffer = NULL;
                    buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:image.CGImage size:CGSizeMake(1920, 1080)];
                    if (buffer)
                            {
//将缓存写入本地文件
                                if(![assetWriterPixelBufferAdaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame, 30)])
                                {
                                 NSLog(@"FAIL");
                                }
                                else
                                {
                                    NSLog(@"video already write into file");
                                    CFRelease(buffer);
                                }
                            }
                }
                else
                {
                    [NSThread sleepForTimeInterval:0.1];
                }
            }
            
        }
    }
//音频输出接口
   else if (captureOutput == audioOut)
   {
    
       if( self.assetWriter.status >= AVAssetWriterStatusWriting )
       {
         if( assetWriter.status == AVAssetWriterStatusFailed )
         {
            NSLog(@"Warning: writer status is %d", assetWriter.status);
            NSLog(@"Error: %@", assetWriter.error);
            return;
         }
        else
        {
            if ([audioWriterInput isReadyForMoreMediaData])
            {
                
                if( ![audioWriterInput appendSampleBuffer:sampleBuffer] )
                {
                    NSLog(@"Unable to write to audio input");
                }
                else
                {
                    NSLog(@"already write audio");
                    //写入音频
                    [audioWriterInput appendSampleBuffer:sampleBuffer];
                }
            }
        }
       
       }
   }
      if (frame == 3000)
      {
         [self stopWork];
      }
       frame ++;
}

- (void) image: (UIImage *) image
didFinishSavingWithError: (NSError *) error
   contextInfo: (void *) contextInfo
{
    
}

- (void)startWork
{
    
}

- (void)stopWork
{

    [self.captureSession stopRunning];
    
    //停止录像
    dispatch_async(queue, ^{
        [self.assetWriter finishWritingWithCompletionHandler:^{
            if (self.assetWriter.status != AVAssetWriterStatusFailed && self.assetWriter.status == AVAssetWriterStatusCompleted) {
               
                self.assetWriter = nil;

            } else {

                dispatch_async(dispatch_get_main_queue(), ^{

                });
            }
        }];
    });

    //将录制的视频保存到相册视频中
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:tempUrl] completionBlock:^(NSURL *assetUrl,NSError *error){
        
        if (error)
        {
            NSLog(@"%@",error);
        }
        else
        {
            NSLog(@"success");
        }
    }];
}

// 从sample（采样器）返回的data中创建image
- (UIImage *) imageFromSampleBuffer:(CVImageBufferRef) imageBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

//创建像素缓存块
- (CVPixelBufferRef )pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options, &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
