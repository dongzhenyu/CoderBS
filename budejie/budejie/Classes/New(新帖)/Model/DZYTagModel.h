//
//  DZYTagModel.h
//  budejie
//
//  Created by dzy on 16/1/5.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZYTagModel : NSObject

/** 头像 */
@property (nonatomic, copy) NSString *image_list;

/** 名称 */
@property (nonatomic, copy) NSString *theme_name;

/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;

@end
