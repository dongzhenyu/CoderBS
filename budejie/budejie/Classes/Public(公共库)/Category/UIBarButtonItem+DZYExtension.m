//
//  UIBarButtonItem+DZYExtension.m
//  budejie
//
//  Created by dzy on 16/1/4.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "UIBarButtonItem+DZYExtension.h"

@implementation UIBarButtonItem (DZYExtension)

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action
{
    // 创建按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    // 把按钮包装成view 处理点击区域过大
    UIView *barButtonView = [[UIView alloc] initWithFrame:button.bounds];
    [barButtonView addSubview:button];
    // 把按钮包装成UIBarButtonItem就会有问题
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:barButtonView];
    return item;
}

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action
{
    // 创建按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image  forState:UIControlStateNormal];
    [button setImage:selImage forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    // 把按钮包装成view,处理点击区域太大
    UIView *barButtonView = [[UIView alloc] initWithFrame:button.bounds];
    [barButtonView addSubview:button];
    
    // 把按钮包装成UIBarButtonItem就会由问题
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:barButtonView];
    
    return item;
}

+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title
{
    // 设置返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:title forState:UIControlStateNormal];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn setImage:highImage forState:UIControlStateHighlighted];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *contentView = [[UIView alloc] initWithFrame:backBtn.bounds];
    [contentView addSubview:backBtn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:contentView];
}
@end
