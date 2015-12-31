//
//  DZYTabBar.m
//  budejie
//
//  Created by dzy on 16/1/1.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYTabBar.h"
#import "DZYPublishViewController.h"

@interface DZYTabBar ()

/** 发布按钮 */
@property (nonatomic, weak) UIButton *publishButton;

@end

@implementation DZYTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
        
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        [publishButton sizeToFit];
        
        [publishButton addTarget:self action:@selector(publishButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:publishButton];
        self.publishButton = publishButton;
        
    }
    return self;
}

- (void)publishButtonClick
{
    DZYPublishViewController *publishVc = [[DZYPublishViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:publishVc];
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}

/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // tabBar的尺寸
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    // 设置发布按钮的位置
    self.publishButton.center = CGPointMake(width * 0.5, height * 0.5);
    
    // 按钮索引
    int index = 0;
    
    // 按钮的尺寸
    CGFloat tabBarButtonW = width / 5;
    CGFloat tabBarButtonH = height;
    CGFloat tabBarBuutonY = 0;
    
    // 设置4个tabBarButton的frame
    for (UIView *tabBarButton in self.subviews) {

        if (![NSStringFromClass(tabBarButton.class) isEqualToString:@"UITabBarButton"]) continue;
        
        // 计算按钮X的值
        CGFloat tabBarButtonX = index * tabBarButtonW;
        if (index >= 2) {
            tabBarButtonX += tabBarButtonW;
        }
        
        tabBarButton.frame = CGRectMake(tabBarButtonX, tabBarBuutonY, tabBarButtonW, tabBarButtonH);
        
        index++;
    }
}

@end
