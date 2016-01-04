//
//  DZYTabBarViewController.m
//  baisibudeijie
//
//  Created by dzy on 15/12/31.
//  Copyright © 2015年 董震宇. All rights reserved.
//

#import "DZYTabBarViewController.h"
#import "DZYEssenceViewController.h"
#import "DZYFriendTrendsViewController.h"
#import "DZYMeViewController.h"
#import "DZYNewViewController.h"
#import "DZYPublishViewController.h"

#import "DZYTabBar.h"
#import "DZYNavigationController.h"

#define DZYTabBarButtonTitleFont [UIFont systemFontOfSize:14]

@interface DZYTabBarViewController ()

@end

@implementation DZYTabBarViewController

// 当前加载内存的时候就会调用一次 只会调用一次
+ (void)load
{
    // 获取整个应用程序下所有的tabBarItem [UITabBarItem appearance]
    // 获取当前类中的所有tabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    
    // UITabBarItem字体是由默认状态决定
    // 1.设置默认状态下的标题字体
    // 1.1描述字符串的属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = DZYTabBarButtonTitleFont;
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    
    // 2.设置tabBarButton按钮选中标题颜色
    // 2.1 描述字符串的属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupAllChildViewController];
    
    [self setupAllTabBarButton];
    
    [self setupTabBar];
}

#pragma mark - 添加所有的子控制器
- (void)setupAllChildViewController
{
    DZYEssenceViewController *essenceVc = [[DZYEssenceViewController alloc] init];
    DZYNavigationController *nav = [[DZYNavigationController alloc] initWithRootViewController:essenceVc];
    // initWithRootViewController -> push(vc)
    [self addChildViewController:nav];
    
    DZYNewViewController *newVc = [[DZYNewViewController alloc] init];
    DZYNavigationController *nav3 = [[DZYNavigationController alloc] initWithRootViewController:newVc];
    [self addChildViewController:nav3];
    
    DZYFriendTrendsViewController *friendTrendsVc = [[DZYFriendTrendsViewController alloc] init];
    DZYNavigationController *nav1 = [[DZYNavigationController alloc] initWithRootViewController:friendTrendsVc];
    [self addChildViewController:nav1];
    
    DZYMeViewController *meVc = [[DZYMeViewController alloc] init];
    DZYNavigationController *nav2 = [[DZYNavigationController alloc] initWithRootViewController:meVc];
    [self addChildViewController:nav2];
    
}

#pragma mark - 设置tabBar上面所有按钮内容
- (void)setupAllTabBarButton
{
    DZYNavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"精华";
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    nav.tabBarItem.selectedImage = [UIImage imageWithOriginalImageName:@"tabBar_essence_click_icon"];
    
    DZYNavigationController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"新帖";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    nav1.tabBarItem.selectedImage = [UIImage imageWithOriginalImageName:@"tabBar_new_click_icon"];
    
    DZYNavigationController *nav2 = self.childViewControllers[2];
    nav2.tabBarItem.title = @"关注";
    nav2.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    nav2.tabBarItem.selectedImage = [UIImage imageWithOriginalImageName:@"tabBar_friendTrends_click_icon"];
    
    DZYNavigationController *nav3 = self.childViewControllers[3];
    nav3.tabBarItem.title = @"我";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    nav3.tabBarItem.selectedImage = [UIImage imageWithOriginalImageName:@"tabBar_me_click_icon"];
    
}

#pragma mark - 设置tabBar
- (void)setupTabBar
{
    DZYTabBar *tabBar = [[DZYTabBar alloc] initWithFrame:self.tabBar.frame];
    
    // readonly可以使用KVC,KVC首先去看有没有set方法,找成员属性
    [self setValue:tabBar forKey:@"tabBar"];
}


@end
