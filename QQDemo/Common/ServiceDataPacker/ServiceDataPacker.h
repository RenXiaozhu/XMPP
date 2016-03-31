//
// Created by fengshuai on 15/10/31.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServiceDataPacker : NSObject
@property (nonatomic,copy) NSString *salt;

- (NSData *)packDataWithZip:(NSData *)aData;
- (NSData *)packData:(NSData *)aData;

- (NSString *)packStringWithZip:(NSString *)aString;

- (NSData *)unpackDataWithUnzip:(NSData *)aData;
- (NSData *)unpackData:(NSData *)aData;

- (NSData *)generatePost:(NSData *)aContent forType:(UInt16)aType;
- (NSData *)generatePost:(NSData *)aContent forType:(UInt16)aType withFile:(NSData *)aFile;


- (void)getResponseInfo:(NSData *)rawData
                   type:(UInt16 *)aType
              errorCode:(UInt32 *)aErrorCode
                content:(NSData **)aContent
                   file:(NSData **)aFile;

@end