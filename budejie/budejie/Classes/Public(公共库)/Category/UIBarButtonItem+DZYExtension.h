//
//  UIBarButtonItem+DZYExtension.h
//  budejie
//
//  Created by dzy on 16/1/4.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DZYExtension)

/**
 *  快速把按钮包装成UIBarButtonItem
 *
 *  @param image     按钮图片
 *  @param highImage 按钮高亮图片
 *  @param target    按钮监听者
 *  @param action    调用监听者的哪个方法
 *
 *  @returnUIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;
/**
 *  快速把按钮包装成UIBarButtonItem
 *
 *  @param image     按钮图片
 *  @param highImage 按钮选中图片
 *  @param target    按钮监听者
 *  @param action    调用监听者的哪个方法
 *
 *  @returnUIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action;

/**
 *  快速把按钮包装成返回按钮
 *  @param title     返回按钮的标题
 *  @param image     返回按钮图片
 *  @param highImage 返回按钮高亮图片
 *  @param target    返回按钮监听者
 *  @param action    调用监听者的哪个方法
 *
 *  @returnUIBarButtonItem
 */
+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title;
@end
