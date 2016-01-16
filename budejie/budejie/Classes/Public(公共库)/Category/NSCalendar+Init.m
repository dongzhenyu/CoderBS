//
//  NSCalendar+Init.m
//  budejie
//
//  Created by dzy on 16/1/13.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "NSCalendar+Init.h"

@implementation NSCalendar (Init)

+ (instancetype)dzy_calendar
{
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    } else {
        return [NSCalendar currentCalendar];
    }
}

@end
