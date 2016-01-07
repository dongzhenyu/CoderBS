//
//  NSString+Extension.m
//
//  Created by 董震宇 on 15/1/22.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "NSString+Extension.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (Extension)

#pragma mark - 去掉空格

+ (NSString *)trim:(NSString *)val trimCharacterSet:(NSCharacterSet *)characterSet {
    NSString *returnVal = @" ";
    if (val) {
        returnVal = [val stringByTrimmingCharactersInSet:characterSet];
    }
    return returnVal;
}

+ (NSString *)trimWhitespace:(NSString *)val {
    return [self trim:val trimCharacterSet:[NSCharacterSet whitespaceCharacterSet]]; //去掉前后空格
}

+ (NSString *)trimNewline:(NSString *)val {
    return [self trim:val trimCharacterSet:[NSCharacterSet newlineCharacterSet]]; //去掉前后回车符
}

+ (NSString *)trimWhitespaceAndNewline:(NSString *)val {
    return [self trim:val trimCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去掉前后空格和回车符
}


#pragma mark - 加密

- (NSString *)md5String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)sha1String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)sha256String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)sha512String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_SHA512_DIGEST_LENGTH];
}

- (NSString *)hmacSHA1StringWithKey:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:(int)mutableData.length];
}

- (NSString *)hmacSHA256StringWithKey:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:(int)mutableData.length];
}

- (NSString *)hmacSHA512StringWithKey:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:(int)mutableData.length];
}

#pragma mark - Helpers

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length
{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth addributes:(NSDictionary *)attributes
{
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = font;
    return [self sizeWithMaxWidth:maxWidth addributes:attributes];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - 时间处理
+ (NSString *)created_at:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换欧美这种时间，需要设置locale
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 设置日期的格式
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //目标时间
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]];
    
    // 当前时间
//    NSDate *now = [NSDate date];
//    // 日历对象
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    // NSCalendarUnit枚举代表想获取哪些差值
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期的差值
//    NSDateComponents *components = [calendar components:unit fromDate:createDate toDate:now options:0];
    if ([self isThisYear:createDate]) {
        if ([self isThisYesterday:createDate]) {
            formatter.dateFormat = @"昨天 HH:mm";
            return [formatter stringFromDate:createDate];
        }else if ([self isThisToDay:createDate]){
//            if (components.hour >= 1) {// 大于60分钟：xx小时前
//                return [NSString stringWithFormat:@"%d小时前",components.hour];
//            }else if (components.minute >= 1){// 1分~59分内：xx分钟前
//                return [NSString stringWithFormat:@"%d分钟前",components.minute];
//            }else{// 1分内： 刚刚
//                return @"刚刚";
//            }
            formatter.dateFormat = @"HH:mm";
            return [formatter stringFromDate:createDate];
        }else{// 今年的其他日子
//            formatter.dateFormat = @"HH:mm";
//            return [formatter stringFromDate:createDate];
            formatter.dateFormat = @"MM-dd HH:mm";
            return [formatter stringFromDate:createDate];
        }
    }else{// 非今年
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        return [formatter stringFromDate:createDate];
    }
}
+ (NSString *)created_time:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换欧美这种时间，需要设置locale
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 设置日期的格式
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //目标时间
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]];
    
    // 当前时间
        NSDate *now = [NSDate date];
        // 日历对象
        NSCalendar *calendar = [NSCalendar currentCalendar];
        // NSCalendarUnit枚举代表想获取哪些差值
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//     计算两个日期的差值
        NSDateComponents *components = [calendar components:unit fromDate:createDate toDate:now options:0];
    if ([self isThisYear:createDate]) {
        if ([self isThisYesterday:createDate]) {
            formatter.dateFormat = [NSString stringWithFormat:@"1天前"];
            return [formatter stringFromDate:createDate];
        }else if ([self isThisToDay:createDate]){
            if (components.hour >= 1) {// 大于60分钟：xx小时前
                if (components.hour <= 24) {
                    formatter.dateFormat = [NSString stringWithFormat:@"%ld小时前",(long)components.hour];
                }
                else
                {
                    formatter.dateFormat = [NSString stringWithFormat:@"%ld天前",(long)components.day];
                }
                }else if (components.minute >= 1){// 1分~59分内：xx分钟前
                formatter.dateFormat = [NSString stringWithFormat:@"%ld分钟前",(long)components.minute];
            }else{// 1分内： 刚刚
                            formatter.dateFormat = @"刚刚";
            }
            return [formatter stringFromDate:createDate];
        }else{// 今年的其他日子
            if (components.day <= 7) {
                formatter.dateFormat = [NSString stringWithFormat:@"%ld天前",(long)components.day];
                 return [formatter stringFromDate:createDate];
            }
            else
            {
            formatter.dateFormat = @"MM-dd";
            return [formatter stringFromDate:createDate];
            }
        }
    }else{// 非今年
        formatter.dateFormat = @"MM-dd";
        return [formatter stringFromDate:createDate];
    }
}
/**
 *  判断是否是今年
 */
+ (BOOL)isThisYear:(NSDate *)date
{
    // 当前的时间
    NSDate *now = [NSDate date];
    // 日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获取哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear;
    // 计算微博创建的时间
    NSDateComponents *components = [calendar components:unit fromDate:date];
    // 计算当前的时间
    NSDateComponents *nowComponents = [calendar components:unit fromDate:now];
    return components.year == nowComponents.year;
}

/**
 *  判断是否为昨天
 */
+ (BOOL)isThisYesterday:(NSDate *)date
{
    // 当前的时间
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    // 微博时间转化成字符串
    NSString *dateStr = [formatter stringFromDate:date];
    // 现在时间转化成字符串
    NSString *nowStr = [formatter stringFromDate:now];
    
    date = [formatter dateFromString:dateStr];
    now = [formatter dateFromString:nowStr];
    
    // 日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获取哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    // 计算微博创建的时间
    NSDateComponents *components = [calendar components:unit fromDate:date toDate:now options:NSCalendarWrapComponents];
    
    return components.year == 0 && components.month == 0 && components.day == 1;
}

/**
 *  判断是否是今天
 */
+ (BOOL)isThisToDay:(NSDate *)date
{
    // 当前的时间
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    // 微博时间转化成字符串
    NSString *dateStr = [formatter stringFromDate:date];
    // 现在时间转化成字符串
    NSString *nowStr = [formatter stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
}




@end
