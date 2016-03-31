//
// Created by JOY on 14-7-31.
// Copyright (c) 2014 JOY. All rights reserved.


#import "ResBundleUtils.h"

#define DEFAULT_IMAGE_BUNDLE_NAME @"images.bundle"
#define BUNDLE_COMPOSE_FORMAT @"%@/%@/%@.%@"
#define BUNDLE_COMPOSE_FORMAT_DEFUALT_PATH @"%@/%@.%@"
#define IMAGE_EXTEND_DOUBLE_X @"@2x"
#define IMAGE_EXTEND_TRIBLE_X @"@3x"


@implementation ResBundleUtils

+ (BOOL)deviceIsIPAD
{
    NSString* deviceType = [[UIDevice currentDevice].model substringToIndex:4];
    NSRange range = [[deviceType lowercaseString] rangeOfString:@"ipad"];
    return range.location != NSNotFound;
}

//获取images.bundle目录下的png图片
+ (UIImage *)imageNamedFromImagesBundlePNG:(NSString *)imageName
{
    return [ResBundleUtils imageNamedFromImagesBundlePNG:imageName withSubPath:nil];
}


//获取images.bundle目录下子目录的png图片
+ (UIImage *)imageNamedFromImagesBundlePNG:(NSString *)imageName withSubPath:(NSString *)subPath
{
    return [ResBundleUtils imageNamed:imageName imgtype:@"png" fromBundle:DEFAULT_IMAGE_BUNDLE_NAME withSubPath:subPath];
}

//根据文件名称和类型意见所在的bundle包下，来获取对应的文件相对路径（指定目录下）
+(NSString *)getFilePathByName:(NSString *)fileName andType:(NSString *)type fromBundle:(NSString *)bundleName withSubPath:(NSString *)subPath
{
    NSBundle *bundle =[ResBundleUtils getBundleByName:bundleName];
    NSString *bundlepath = [bundle bundlePath];
    NSString *path= nil;
    if ([subPath length])
        path=[NSString stringWithFormat:BUNDLE_COMPOSE_FORMAT,bundlepath,subPath,fileName,type];
    else
        path=[NSString stringWithFormat:BUNDLE_COMPOSE_FORMAT_DEFUALT_PATH,bundlepath,fileName,type];

    return path;
}


//获得bundle
+(NSBundle *)getBundleByName:(NSString *)bundleName
{
    NSString *bundlePath = nil;
    if (bundleName != nil)
        bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:bundleName];
    else
        return nil;

    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return bundle;
}


//根据imageName和类型以及所在的bundle包下，获取对应的图片资源（默认根目录下）,不需要考虑本地有1倍或2x或3x图片
+ (UIImage *)imageNamed:(NSString *)imgName imgtype:(NSString *)imgtype fromBundle:(NSString *)bundleName withSubPath:(NSString *)pathName
{
    UIImage *image;

    NSString *imgFileName= [imgName stringByDeletingPathExtension];
    if ([imgFileName hasSuffix:@"@2x"]||[imgFileName hasSuffix:@"@3x"])
        imgFileName = [imgFileName substringToIndex:(imgFileName.length-3)];

    if ([ResBundleUtils deviceIsIPAD])
    {
        image = [UIImage imageWithContentsOfFile:[self getFilePathByName:[imgFileName stringByAppendingString:IMAGE_EXTEND_DOUBLE_X] andType:imgtype fromBundle:bundleName withSubPath:pathName]];
    }
    else
    {
        CGFloat scale = [UIScreen mainScreen].scale;

        if (scale>2.0f)
            image = [UIImage imageWithContentsOfFile:[self getFilePathByName:[imgFileName stringByAppendingString:IMAGE_EXTEND_TRIBLE_X]  andType:imgtype fromBundle:bundleName withSubPath:pathName]];
        else if (scale == 2.0f)
            image = [UIImage imageWithContentsOfFile:[self getFilePathByName:[imgFileName stringByAppendingString:IMAGE_EXTEND_DOUBLE_X]  andType:imgtype fromBundle:bundleName withSubPath:pathName]];

        if (image == nil) {
            image = [UIImage imageWithContentsOfFile:[self getFilePathByName:imgFileName  andType:imgtype fromBundle:bundleName withSubPath:pathName]];
        }

    }

    return image;
}



@end