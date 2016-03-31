//
// Created by JOY on 14-7-31.
// Copyright (c) 2014 JOY. All rights reserved.


#import <Foundation/Foundation.h>

//提取bundle 资源的工具
@interface ResBundleUtils : NSObject

//获取images.bundle目录下的png图片
+ (UIImage *)imageNamedFromImagesBundlePNG:(NSString *)imageName;

//获取images.bundle目录下任意子目录的png图片
+ (UIImage *)imageNamedFromImagesBundlePNG:(NSString *)imageName withSubPath:(NSString *)subPath;

//根据文件名称和类型意见所在的bundle包下，来获取对应的文件相对路径（指定目录下）
+(NSString *)getFilePathByName:(NSString *)fileName andType:(NSString *)type fromBundle:(NSString *)bundleName withSubPath:(NSString *)subPath;

//根据imageName和类型以及所在的bundle包下，获取对应的图片资源（默认根目录下）,不需要考虑本地有1倍或2x图片
+ (UIImage *)imageNamed:(NSString *)imgName imgtype:(NSString *)imgtype fromBundle:(NSString *)bundleName withSubPath:(NSString *)pathName;

//根据名称获得bundle
+(NSBundle *)getBundleByName:(NSString *)bundleName;



@end