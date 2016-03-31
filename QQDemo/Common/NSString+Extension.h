//
//  NSString+Hash.h
//  winCRM
//
//  Created by Cai Lei on 12/26/12.
//  Copyright (c) 2012 com.cailei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSString *)MD5Hash;

@end

@interface NSString (UUID)

+ (NSString *)standardUUIDString;

+ (NSString *)UUIDStringWithMD5;

- (NSString *)replaceUnicode;

-(NSDecimal)decimalValue;
@end

@interface NSString (Ext)
+ (NSString *)stringWithObject:(id)obj;

+ (NSString *)string:(NSString *)str withStringURLEncoding:(NSStringEncoding)stringEncoding;

- (NSString *)stringWithTrimWhiteSpcace;

@end
