//
//  NSString+Extension.h
//
//  Created by 董震宇 on 15/1/22.
//  Copyright (c) 2015年  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extension)

#pragma mark - 去掉空格

+ (NSString *)trim:(NSString *)val trimCharacterSet:(NSCharacterSet *)characterSet;
+ (NSString *)trimWhitespace:(NSString *)val;
+ (NSString *)trimNewline:(NSString *)val;
+ (NSString *)trimWhitespaceAndNewline:(NSString *)val;

#pragma mark - 加密

@property (readonly) NSString *md5String;
@property (readonly) NSString *sha1String;
@property (readonly) NSString *sha256String;
@property (readonly) NSString *sha512String;



- (NSString *)hmacSHA1StringWithKey:(NSString *)key;
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

/**
 *  计算显示文字需要的最小尺寸
 *
 *  @param text       需要计算的字符串
 *  @param maxWidth   最大宽度
 *  @param attributes 文字属性字体大小等
 */
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth addributes:(NSDictionary *)attributes;
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font;

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

#pragma mark - 时间处理
+ (NSString *)created_at:(NSString *)time;
+ (NSString *)created_time:(NSString *)time;

@end
