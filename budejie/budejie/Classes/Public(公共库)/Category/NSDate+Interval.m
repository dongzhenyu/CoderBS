//
//  NSDate+Interval.m
//  budejie
//
//  Created by dzy on 16/1/13.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "NSDate+Interval.h"
#import "NSCalendar+Init.h"

/****** DZYDateInterval - begin ******/
@implementation DZYDateInterval

@end
/****** DZYDateInterval - end ******/

/****** NSDate (Interval) - begin ******/
@implementation NSDate (Interval)

- (BOOL)dzy_isInThisYear
{
    NSCalendar *calendar = [NSCalendar dzy_calendar];
    
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    
    // NSDateComponents重写了isEqual:方法, 只要各种元素一样, 那么isEqual:就返回YES
    return [nowCmps isEqual:selfCmps];
}

- (BOOL)dzy_isInToday
{
    NSCalendar *calendar = [NSCalendar dzy_calendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    // NSDateComponents重写了isEqual:方法, 只要各种元素一样, 那么isEqual:就返回YES
    return [nowCmps isEqual:selfCmps];
    //    return nowCmps.year == selfCmps.year
    //    && nowCmps.month == selfCmps.month
    //    && nowCmps.day == selfCmps.day;
}

- (BOOL)dzy_isInYesterday
{
    // 判断self是否为昨天
    
    // self == 2016-01-31 23:10:10 -> 2016-01-31 00:00:00
    // now  == 2016-02-01 01:10:10 -> 2016-02-01 00:00:00
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    
    // 生成只有年月日的字符串(没有时分秒, 时分秒已经被抛弃了)
    NSString *selfString = [fmt stringFromDate:self]; // 20160131
    NSString *nowString = [fmt stringFromDate:[NSDate date]]; // 20160201
    
    // 生成只有年月日的日期(没有时分秒, 时分秒已经被抛弃了)
    NSDate *selfDate = [fmt dateFromString:selfString];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [[NSCalendar dzy_calendar] components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}

- (BOOL)dzy_isInTomorrow
{    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    
    // 生成只有年月日的字符串(没有时分秒, 时分秒已经被抛弃了)
    NSString *selfString = [fmt stringFromDate:self]; // 20160131
    NSString *nowString = [fmt stringFromDate:[NSDate date]]; // 20160201
    
    // 生成只有年月日的日期(没有时分秒, 时分秒已经被抛弃了)
    NSDate *selfDate = [fmt dateFromString:selfString];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [[NSCalendar dzy_calendar] components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == -1;
}

- (DZYDateInterval *)dzy_intervalSinceDate:(NSDate *)anotherDate
{
    // 时间间隔(单位:s)
    NSInteger interval = [self timeIntervalSinceDate:anotherDate];
    
    NSInteger secsPerMinute = 60;
    NSInteger secsPerHour = 60 * secsPerMinute;
    NSInteger secsPerDay = 24 * secsPerHour;
    
    DZYDateInterval *dateInterval = [[DZYDateInterval alloc] init];
    dateInterval.day = interval / secsPerDay;
    dateInterval.hour = (interval % secsPerDay) / secsPerHour;
    dateInterval.minute = ((interval % secsPerDay) % secsPerHour) / secsPerMinute;
    dateInterval.second = interval % secsPerMinute;
    return dateInterval;
}

- (void)dzy_intervalSinceDate:(NSDate *)anotherDate day:(NSInteger *)dayP hour:(NSInteger *)hourP minute:(NSInteger *)minuteP second:(NSInteger *)secondP
{
    // 时间间隔(单位:s)
    NSInteger interval = [self timeIntervalSinceDate:anotherDate];
    
    NSInteger secsPerMinute = 60;
    NSInteger secsPerHour = 60 * secsPerMinute;
    NSInteger secsPerDay = 24 * secsPerHour;
    
    *dayP = interval / secsPerDay;
    *hourP = (interval % secsPerDay) / secsPerHour;
    *minuteP = ((interval % secsPerDay) % secsPerHour) / secsPerMinute;
    *secondP = interval % secsPerMinute;
}

@end
/****** NSDate (Interval) - end ******/
