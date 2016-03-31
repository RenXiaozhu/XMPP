//
//  UIImage+SimplifyImage.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/6/25.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "UIImage+SimplifyImage.h"
#define MAX8(x)  ( (x)&0xFF )
#define R(x)     ( MAX8(x)  )
#define G(x)     ( MAX8(x>>8)  )
#define B(x)     ( MAX8(x>>16) )

@implementation UIImage (SimplifyImage)


- (UIImage *)processSimplifyImageWithSource
{
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    // 1：第一部分：把UIImage对象转换为需要被核心图形库调用的CGImage对象。同时，得到图形的宽度和高度。
    CGImageRef inputImg = [self CGImage];
    
    NSUInteger width = CGImageGetWidth(inputImg);
    NSUInteger height = CGImageGetHeight(inputImg);
    
    // 2：第二部分：由于你使用的是32位RGB颜色空间模式，你需要定义一些参数bytesPerPixel（每像素大小）和bitsPerComponent（每个颜色通道大小），然后计算图像bytesPerRow（每行有大）。最后，使用一个数组来存储像素的值。
    NSUInteger bytePerPixel = 4;//每像素大小
    NSUInteger bytePerRow   = bytePerPixel * width;//每行像素大小
    NSUInteger bytePerComponent = 8;//每像素通道大小
    
    //申请存放像素指针的数组空间
    UInt64 *pixels ;
    pixels = (UInt64 *)calloc( height*width , sizeof(UInt64));
    
    // 3：第三部分：创建一个RGB模式的颜色空间CGColorSpace和一个容器CGBitmapContext,将像素指针参数传递到容器中缓存进行存储。在后面的章节中将会进一步研究核图形库。

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate( pixels, width, height, bytePerComponent, bytePerRow, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);

    
//    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    // 4：第四部分：把缓存中的图形绘制到显示器上。像素的填充格式是由你在创建context的时候进行指定的。
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputImg);

//    UIGraphicsPushContext(context);
//    
//    UIGraphicsPopContext();
    NSMutableData *data = [self printBightnessOfImageWith:pixels width:width height:height];
    
    UIImage *img = [self imageFromdata:data width:width height:height];

    // 5：第五部分：清除colorSpace和context.
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return img;
}

- (NSMutableData *)printBightnessOfImageWith:(UInt64 *)pixels width:(NSUInteger)width height:(NSUInteger)height
{
    NSMutableData *data = [[NSMutableData alloc]init];
    UInt64 *currentPixels = pixels;
    
    for (int j=0; j<height/2; j++)
    {
        for (int i = 0; i<width/2; i++)
        {
            UInt64 *clr = currentPixels;
            [data appendBytes:clr length:4];
            
            UInt64 color = *clr;
            printf("(%3.0f ", (R(color)+G(color)+B(color))/3.0);
            currentPixels = currentPixels + 2;

            
            unsigned char *bytes =  malloc( 2*sizeof(unsigned char));
            UInt64 *cr ;
            cr = (UInt64 *)calloc( 4, sizeof(UInt64));
            [data getBytes:bytes range:NSMakeRange(i*4, 4)];
            
            UInt64 ccp = *bytes;
            
//            CLog(@"%lu" ,sizeof(unsigned char));
            
            printf("%3.0f )",  (R(ccp)+G(ccp)+B(ccp))/3.0);
            
        }
        currentPixels = currentPixels +width;
        printf("\n");
    }

printf("--------------------------------------------------------------------------\n");
    
    for (int j=0; j<(height/2); j++)
    {
        for (int i = 0; i<(width/2); i++)
        {
            UInt32 *color ;
            color = (UInt32 *)calloc( 4, sizeof(UInt32));
            [data getBytes:color range:NSMakeRange(i*4, 4)];
            
            UInt32 ccp = *color;
            printf("%3.0f ",  (R(ccp)+G(ccp)+B(ccp))/3.0);
            free(color);
        }
        printf("\n");
    }
    return data;
}



- (UIImage *) imageFromdata:(NSData *)data width:(NSUInteger)width1 height:(NSUInteger)height1
{
    UInt32 *baseAddress = alloca(4);
    baseAddress = (UInt32 *)calloc( 4, sizeof(UInt32));
    [data getBytes:baseAddress range:NSMakeRange( 0, 4)];
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
//    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = 4*width1/2;
    // Get the pixel buffer width and height
    size_t width = width1;
    size_t height = height1;
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    
    // Get the base address of the pixel buffer

    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = sizeof(data);
    
    // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize,
                                                              NULL);
    // Create a bitmap image from data supplied by our data provider
    CGImageRef cgImage =
    CGImageCreate(width,
                  height,
                  8,
                  32,
                  bytesPerRow,
                  colorSpace,
                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  provider,
                  NULL,
                  true,
                  kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    // Create and return an image object representing the specified Quartz image
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    
    return image;
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


@end
