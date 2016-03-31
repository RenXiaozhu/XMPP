//
// Created by fengshuai on 15/10/31.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import "ServiceDataPacker.h"
#import "NSData+CommonCrypto.h"
#import "NSData+ZIP.h"
#import "GTMBase64.h"

const NSString *InitStreetCode = @"7B02 of 7F, Block D, KeShi Building, The Xinxi Road, Haidian District, Beijing";
const NSString *InitHttpCode = @"http://www.yundongsports.com";

const UInt32 TypeCodeLength=2;
const UInt32 ErrorCodeLength=4;
const UInt32 ContentLenghtCodeLength=4;
const UInt32 FileLenghtCodeLength=4;

@implementation ServiceDataPacker


- (NSData *)secretKey {
    NSData *firstPart = [InitStreetCode dataUsingEncoding:NSUTF8StringEncoding];
    NSData *secondPart = [InitHttpCode dataUsingEncoding:NSUTF8StringEncoding];
    if ((self.salt) && ([self.salt length])) {
        secondPart = [self.salt dataUsingEncoding:NSUTF8StringEncoding];
    }

    NSMutableData *code = [NSMutableData dataWithData:[firstPart MD5Sum]];
    [code appendData:[secondPart MD5Sum]];

    return [NSData dataWithData:code];
}

- (NSData *)packDataWithZip:(NSData *)aData
{
    // 1, zip
    NSData *zipData = [aData zip];

    // 2, encrypt
    CCCryptorStatus error = kCCSuccess;
    NSData *encryptData = [zipData dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                                                           key:[self secretKey]
                                                       options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                         error:&error];
    if (kCCSuccess != error) {
        //DDLogError(@"pack body error : %d", error);
        return nil;
    }

    return encryptData;
}

- (NSData *)packData:(NSData *)aData
{
    // 2, encrypt
    CCCryptorStatus error = kCCSuccess;
    NSData *encryptData = [aData dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                                                         key:[self secretKey]
                                                     options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                       error:&error];
    if (kCCSuccess != error) {
        //DDLogError(@"pack body error : %d", error);
        return nil;
    }

    return encryptData;
}

- (NSString *)packStringWithZip:(NSString *)aString
{
    NSData *orgData = [aString dataUsingEncoding:NSUTF8StringEncoding];
    // 1, zip
    NSData *zipData = [orgData zip];

    // 2, encrypt
    CCCryptorStatus error = kCCSuccess;
    NSData *encryptData = [zipData dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                                                           key:[self secretKey]
                                                       options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                         error:&error];
    if (kCCSuccess != error) {
        //DDLogError(@"pack body error : %d", error);
        return nil;
    }

    // 3, base64 URL encoding
    NSString *base64EncodeString = [GTMBase64 stringByWebSafeEncodingData:encryptData padded:YES];
    return base64EncodeString;
}

- (NSData *)unpackDataWithUnzip:(NSData *)aData
{
    // 1, decrypt
    CCCryptorStatus error = kCCSuccess;

    NSData *decryptData = [aData decryptedDataUsingAlgorithm:kCCAlgorithmAES128
                                                         key:[self secretKey]
                                                     options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                       error:&error];
    if (kCCSuccess != error) {
        //DDLogError(@"unpack body error : %d", error);
        return nil;
    }

    // 2, unzip
    NSData *unzipData = [decryptData unzip];

    return unzipData;
}

- (NSData *)unpackData:(NSData *)aData
{
    CCCryptorStatus error = kCCSuccess;

    NSData *decryptData = [aData decryptedDataUsingAlgorithm:kCCAlgorithmAES128
                                                         key:[self secretKey]
                                                     options:(kCCOptionECBMode | kCCOptionPKCS7Padding)
                                                       error:&error];
    if (kCCSuccess != error) {
        //DDLogError(@"unpack body error : %d", error);
        return nil;
    }
    return decryptData;
}

- (NSData *)generatePost:(NSData *)aContent forType:(UInt16)aType
{
    NSUInteger totalLen = 2 + 4 + [aContent length];
    char *totalBytes=malloc(sizeof(char)*totalLen);
    memset(totalBytes,0,sizeof(char)*totalLen);

    UInt16 type = htons(aType);
    UInt32 len = htonl([aContent length]);

    memcpy(totalBytes, &type, 2);
    memcpy((totalBytes + 2), &len, 4);
    memcpy((totalBytes + 2 + 4), [aContent bytes], [aContent length]);
    NSData *totalData = [[NSData alloc] initWithBytes:totalBytes length:totalLen];
    free(totalBytes);

    return totalData;
}

- (NSData *)generatePost:(NSData *)aContent forType:(UInt16)aType withFile:(NSData *)aFile
{
    NSUInteger totalLen = 2 + 4 + [aContent length] + 4 + [aFile length];
    char *totalBytes=malloc(sizeof(char)*totalLen);
    memset(totalBytes,0,sizeof(char)*totalLen);

    UInt16 type = htons(aType);
    UInt32 len = htonl([aContent length]);
    UInt32 len2 =htonl([aFile length]);
    memcpy(totalBytes, &type, 2);
    memcpy((totalBytes + 2), &len, 4);
    memcpy((totalBytes + 2 + 4), [aContent bytes], [aContent length]);
    memcpy((totalBytes + 2 + 4 + [aContent length]), &len2, 4);
    memcpy((totalBytes + 2 + 4 + [aContent length] + 4), [aFile bytes], [aFile length]);
    NSData *totalData = [[NSData alloc] initWithBytes:totalBytes length:totalLen];
    free(totalBytes);
    return totalData;
}

- (UInt16)getResponseTwoBytes:(const char *)aResponse
                       offset:(NSUInteger)aOffset
{
    UInt16 result = 0;
    memcpy(&result, (aResponse+aOffset), 2);
    return ntohs(result);
}

- (UInt32)getResponseFourBytes:(const char *)aResponse
                        offset:(NSUInteger)aOffset
{
    UInt32 result = 0;
    memcpy(&result, (aResponse+aOffset), 4);
    return ntohl(result);
}

- (NSData *)getResponseContent:(const char *)aResponse
                        offset:(NSUInteger)aOffset
                        length:(NSUInteger)aLength

{
    NSData *content = [NSData dataWithBytes:(aResponse+aOffset) length:aLength];
    return content;
}

- (void)getResponseInfo:(NSData *)rawData type:(UInt16 *)aType errorCode:(UInt32 *)aErrorCode content:(NSData **)aContent file:(NSData **)aFile
{
    if (!rawData)
        return;

    const char *aResponse= [rawData bytes];
    UInt32 dataLength= [rawData length];
    if (dataLength>=TypeCodeLength+ErrorCodeLength)
    {
        *aType = [self getResponseTwoBytes:aResponse offset:0];
        *aErrorCode = [self getResponseFourBytes:aResponse offset:TypeCodeLength];

        //content and file
        if (dataLength >= TypeCodeLength+ErrorCodeLength+ContentLenghtCodeLength)
        {
            // 检查content
            UInt32 contentLength = [self getResponseFourBytes:aResponse offset:TypeCodeLength+ErrorCodeLength];
            if (contentLength == 0)
            {
                // 没有content，检查是否有file
                if (dataLength >= TypeCodeLength+ErrorCodeLength+ContentLenghtCodeLength+FileLenghtCodeLength)
                {
                    UInt32 fileLength= [self getResponseFourBytes:aResponse offset:TypeCodeLength+ErrorCodeLength+contentLength];
                    if (fileLength&&dataLength==TypeCodeLength+ErrorCodeLength+ContentLenghtCodeLength+FileLenghtCodeLength+fileLength)
                    {
                        // 有file，且file长度正确
                        *aFile= [self getResponseContent:aResponse offset:TypeCodeLength+ErrorCodeLength+ContentLenghtCodeLength+contentLength length:fileLength];
                    }
                }
            }
            else
            {
                UInt32 dataOffset = TypeCodeLength+ErrorCodeLength+ContentLenghtCodeLength + contentLength;
                // 有content
                if (dataLength >= dataOffset)
                {
                    // 取出content
                    *aContent = [self getResponseContent:aResponse offset:TypeCodeLength+ErrorCodeLength+ContentLenghtCodeLength length:contentLength];

                    // 检查有没有file
                    if (dataLength >= (dataOffset + FileLenghtCodeLength))
                    {
                        UInt32 fileLength= [self getResponseFourBytes:aResponse offset:TypeCodeLength+ErrorCodeLength+contentLength];
                        if (fileLength>0&&dataLength == (dataOffset +FileLenghtCodeLength+ fileLength))
                        {
                            // 有file，且file长度正确
                            *aFile= [self getResponseContent:aResponse offset:TypeCodeLength+ErrorCodeLength+ContentLenghtCodeLength+contentLength length:fileLength];
                        }
                    }
                }
            }
        }
    }
}


@end