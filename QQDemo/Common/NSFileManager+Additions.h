//
// Created by fengshuai on 13-12-14.
// Copyright (c) 2013 winchannel. All rights reserved.


#import <Foundation/Foundation.h>


@interface NSFileManager(Additions)
// offer a stirng to create a non-exist directory ,BOOL value will be return

+(BOOL)createDirectoryByPath:(NSString *)directorypath;

// test the file is exist, BOOL value will be return
+(BOOL)FileExist:(NSString *)filepath;
// get the runtime file path
+(NSString *)getRuntimeDocumentPath;
//写文件到路径下
+(BOOL)writeFileFrom:(NSString *)path toPath:(NSString*)destpath;

+(BOOL)writeStringContent:(NSString *)content toPath:(NSString *)destpath;

+(BOOL)writeDataContent:(NSData *)data toPath:(NSString *)destpath;

//获取文件的时间
+(NSDate *)getFileLastDateInfo:(NSString  *)localfilepath;

//获取文件的大小
+(float) getFileSizeByFilePath:(NSString *)localfilepath;

//按照路径删除文件
+(BOOL)  deleteFileByPath:(NSString *)filepath;

+ (size_t)archiver:(id<NSCoding>)obj withKey:(NSString *)key toPath:(NSString *)path;

+ (id)unarchiverWithKey:(NSString *)key fromPath:(NSString *)path;

+ (NSDictionary *)getFileAttributes:(NSString *)fpath;

@end