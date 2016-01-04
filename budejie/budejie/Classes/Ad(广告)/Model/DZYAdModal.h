//
//  DZYAdModal.h
//  budejie
//
//  Created by dzy on 16/1/4.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import <Foundation/Foundation.h>
// w_picurl: w:图片宽度 h:图片高度 ori_curl:点击广告图片,进入界面
@interface DZYAdModal : NSObject

/** 广告图片 */
@property (nonatomic, copy) NSString *w_picurl;

/** 点击广告进入界面 */
@property (nonatomic, copy) NSString *ori_curl;

/** <#type#> */
@property (nonatomic, assign) CGFloat w;

/** <#type#> */
@property (nonatomic, assign) CGFloat h;

@end
