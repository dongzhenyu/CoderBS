//
//  NSDate+Interval.h
//  budejie
//
//  Created by dzy on 16/1/13.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import <UIKit/UIKit.h>

/****** DZYDateInterval - begin ******/
@interface DZYDateInterval : NSObject
/** 相隔多少天 */
@property (nonatomic, assign) NSInteger day;
/** 相隔多少小时 */
@property (nonatomic, assign) NSInteger hour;
/** 相隔多少分钟 */
@property (nonatomic, assign) NSInteger minute;
/** 相隔多少秒 */
@property (nonatomic, assign) NSInteger second;
@end
/****** DZYDateInterval - end ******/

/****** NSDate (Interval) - begin ******/
@interface NSDate (Interval)
- (BOOL)dzy_isInToday;
- (BOOL)dzy_isInYesterday;
- (BOOL)dzy_isInTomorrow;
- (BOOL)dzy_isInThisYear;

/**
 *  计算self和anotherDate之间的时间间隔
 */
- (DZYDateInterval *)dzy_intervalSinceDate:(NSDate *)anotherDate;

- (void)dzy_intervalSinceDate:(NSDate *)anotherDate day:(NSInteger *)dayP hour:(NSInteger *)hourP minute:(NSInteger *)minuteP second:(NSInteger *)secondP;
@end
/****** NSDate (Interval) - begin ******/
