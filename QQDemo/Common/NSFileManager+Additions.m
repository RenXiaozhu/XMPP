//
// Created by fengshuai on 13-12-14.
// Copyright (c) 2013 winchannel. All rights reserved.


#import "NSFileManager+Additions.h"


@implementation NSFileManager(Additions)
+(BOOL)createDirectoryByPath:(NSString *)directorypath{

    NSFileManager *filemanager=[NSFileManager defaultManager];

    BOOL isok=[filemanager createDirectoryAtPath:directorypath withIntermediateDirectories:YES attributes:nil error:nil];

    // [filemanager release];

    return isok;

}


+(BOOL)FileExist:(NSString *)filepath{
    NSFileManager * filemanager=[NSFileManager defaultManager];

    if([filemanager fileExistsAtPath:filepath]==YES){

        //[filemanager release];

        return  YES;

    }else{

        //[filemanager release];

        return NO;

    }
}

+(BOOL)deleteFileByPath:(NSString *)filepath{

    NSFileManager * filemanager=[NSFileManager defaultManager];

    NSError  *error = nil;
    return [filemanager removeItemAtPath:filepath error:&error];
}

+(BOOL)writeFileFrom:(NSString *)path toPath:(NSString *)destpath{
    BOOL iswrite=NO;

    NSFileManager *filemanager=[NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:destpath]==YES) {
        return YES;
    }else{
        iswrite=[filemanager copyItemAtPath:path toPath:destpath error:NULL];

    }
    return iswrite;
}


+(BOOL)writeStringContent:(NSString *)content toPath:(NSString *)destpath{



    NSFileManager *filemanager=[NSFileManager defaultManager];

    if ([filemanager fileExistsAtPath:destpath]==NO) {

        [filemanager createFileAtPath:destpath contents:nil attributes:nil];
    }


    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

    NSData *data = [content dataUsingEncoding:enc];

    return [data writeToFile: destpath atomically: NO];

}


+(BOOL)writeDataContent:(NSData *)data toPath:(NSString *)destpath{


    NSFileManager *filemanager=[NSFileManager defaultManager];

    if ([filemanager fileExistsAtPath:destpath]==NO) {

        [filemanager createFileAtPath:destpath contents:nil attributes:nil];
    }

    return [data writeToFile:destpath atomically:NO];

}

+(NSString *)getRuntimeDocumentPath{

    NSArray *patharray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    return [patharray objectAtIndex:0];
}


+(NSDate *)getFileLastDateInfo:(NSString  *)localfilepath{
    NSDate   *filelastmodifidate =nil;
    NSFileManager *filemanager=[NSFileManager defaultManager];
    NSError *error=nil;
    NSDictionary  *dict = [filemanager  attributesOfItemAtPath:localfilepath error:&error];

    return filelastmodifidate =[dict valueForKey:@"NSFileModificationDate"];
}


+(float) getFileSizeByFilePath:(NSString *)localfilepath{


    NSFileManager *filemanager=[NSFileManager defaultManager ];
    NSError *error=nil;
    NSDictionary  *dict = [filemanager  attributesOfItemAtPath:localfilepath error:&error];


    return [(NSString *)[dict valueForKey:@"NSFileSize"] floatValue];
}


+ (size_t)archiver:(id<NSCoding>)obj withKey:(NSString *)key toPath:(NSString *)path
{
    NSString *directory = [path stringByDeletingLastPathComponent];
    [NSFileManager deleteFileByPath:path];
    [NSFileManager createDirectoryByPath:directory];

    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

    @try {
        [archiver encodeObject:obj forKey:key];
        [archiver finishEncoding];
    }
    @catch (NSException *exception) {
        return 0;
    }

    if (![data writeToFile:path atomically:YES]) return 0;

    return [data length];
}

+ (id)unarchiverWithKey:(NSString *)key fromPath:(NSString *)path
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) return nil;

    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];

    id obj = nil;

    @try {
        obj = [unarchiver decodeObjectForKey:key];
        [unarchiver finishDecoding];
    }
    @catch (NSException *exception) {
        return nil;
    }

    return obj;
}

+ (NSDictionary *)getFileAttributes:(NSString *)fpath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fpath error:&error];
    if (fileAttributes)
    {
        return fileAttributes;
    }
    return nil;
}

@end