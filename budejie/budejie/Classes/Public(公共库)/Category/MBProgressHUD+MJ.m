//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"
#import "NSString+Extension.h"
#import <objc/runtime.h>
//#import "Constant.h"

@implementation MBProgressHUD (MJ)

static char *AnmationImageViewKey = "AnmationImageViewKey";

 - (void)setAnmationImageView:(UIImageView *)anmationImageView
{
    objc_setAssociatedObject(self, &AnmationImageViewKey, anmationImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)anmationImageView
{
    return objc_getAssociatedObject(self, &AnmationImageViewKey);
}

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if ((text == nil || [text isEqualToString:@""]) && icon == nil) {
        return;
    }
    
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    
    // 设置图片
    if (icon) {
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    }

    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // N秒之后再消失
    [hud hide:YES afterDelay:2.0];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:nil view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:nil view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (MBProgressHUD *)showCustomMessage:(NSString *)message view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    UIView *contentView = [[UIView alloc] init];

    UIImageView *anmationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 19, 18)];
    hud.anmationImageView = anmationImageView;
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < 24; i ++) {
        NSString *imageStr = [NSString stringWithFormat:@"fx_loading%02d",i];
        [images addObject:[UIImage imageNamed:imageStr]];
    }
    anmationImageView.animationImages = images;
    anmationImageView.animationDuration = 1;
    anmationImageView.animationRepeatCount = GID_MAX;
    [anmationImageView startAnimating];
    
    UILabel *textL = [[UILabel alloc] init];
    textL.font = [UIFont systemFontOfSize:11.0];
    textL.textColor = [UIColor lightGrayColor];
    textL.text = message;
    CGSize textRealSize = [message sizeWithMaxWidth:MAXFLOAT font:[UIFont systemFontOfSize:11.0]];

    CGFloat W = textRealSize.width;
    CGFloat H = textRealSize.height;
    CGFloat X = CGRectGetMaxX(anmationImageView.frame) + 10;
    CGFloat Y = (anmationImageView.frame.size.height - H) * 0.5;
    textL.frame = CGRectMake(X, Y, W, H);
    [contentView addSubview:textL];
    [contentView addSubview:anmationImageView];
    contentView.frame = CGRectMake(0, 0, CGRectGetMaxX(textL.frame), CGRectGetMaxY(anmationImageView.frame));
    hud.customView = contentView;
    hud.color = [UIColor clearColor];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [self HUDForView:view];
    [hud.anmationImageView stopAnimating];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:NO];
    }
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end
