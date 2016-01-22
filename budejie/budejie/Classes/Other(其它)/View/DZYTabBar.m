//
//  DZYTabBar.m
//  budejie
//
//  Created by dzy on 16/1/1.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYTabBar.h"
#import "DZYPublishViewController.h"
//#import "DZYNavigationController.h"
//#import "DZYAddTagViewController.h"


@interface DZYTabBar ()

/** 发布按钮 */
@property (nonatomic, weak) UIButton *publishButton;

@end

@implementation DZYTabBar

// 懒加载 按钮只会加载一次
- (UIButton *)publishButton
{
    if (!_publishButton) {
        
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        [publishButton sizeToFit];
        
        [publishButton addTarget:self action:@selector(publishButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return _publishButton;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];

//        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
//        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
//        [publishButton sizeToFit];
//        
//        [publishButton addTarget:self action:@selector(publishButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        
//        [self addSubview:publishButton];
//        self.publishButton = publishButton;
        
//    }
//    return self;
//}

- (void)publishButtonClick
{
    DZYPublishViewController *publishVc = [[DZYPublishViewController alloc] init];
    
    [self.window.rootViewController presentViewController:publishVc animated:YES completion:nil];
    
//    DZYAddTagViewController *addVc = [[DZYAddTagViewController alloc] init];
//    DZYNavigationController *nav = [[DZYNavigationController alloc] initWithRootViewController:addVc];
//    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    
}

/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    // tabBar的尺寸
//    CGFloat width = self.width;
//    CGFloat height = self.height;
//    
//    // 按钮索引
//    int index = 0;
//    
//    // 按钮的尺寸
//    CGFloat tabBarButtonW = width / 5;
//    CGFloat tabBarButtonH = height;
//    CGFloat tabBarBuutonY = 0;
//    
//    // 设置4个tabBarButton的frame
//    for (UIView *tabBarButton in self.subviews) {
//
//        if (![NSStringFromClass(tabBarButton.class) isEqualToString:@"UITabBarButton"]) continue;
//        
//        // 计算按钮X的值
//        CGFloat tabBarButtonX = index * tabBarButtonW;
//        if (index >= 2) {
//            tabBarButtonX += tabBarButtonW;
//        }
//        
//        tabBarButton.frame = CGRectMake(tabBarButtonX, tabBarBuutonY, tabBarButtonW, tabBarButtonH);
//        
//        index++;
//    }
    
    // 另外一种方法
    CGFloat btnW = self.width / (self.items.count + 1);
    CGFloat btnH = self.height;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    // 按钮索引
    int i = 0;
    
    for (UIView *tabBarButton in self.subviews) {
        
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            if (i == 2) {
                i += 1;
            }
            
            btnX = i * btnW;
            // 调整子控件位置
            tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
            i++;
        }
    }
    
    
    // 设置发布按钮的位置
    self.publishButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}

@end
