//
// Created by fengshuai on 15/10/24.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 * 编码规则:类型名称属性名称加下划线"_",再加上TAG对应的int值 .
 * 举个栗子: 类型Pserson_111的属性name_FF, age_FE, gender_FD . 对应的字段名为name,age,gender
 * 限制:数据类型只支持uint8_t,NSString,NSArray,NSData
 * 数据内容的字符编码为ASCII码
 * */
@interface TLVSerializableObject : NSObject

- (instancetype)initWithData:(NSData *)data;

- (NSData *)serializeToData;

@end

Generalize(SampleTLV);

@interface SampleTLV : TLVSerializableObject
@property(nonatomic, strong) NSString *name_FF;
@property(nonatomic, assign) uint8_t age_FE;
@property(nonatomic, assign) uint8_t gender_FD;
@property(nonatomic, strong) NSArray<SampleTLV *> <SampleTLV> *list_FC;
@end