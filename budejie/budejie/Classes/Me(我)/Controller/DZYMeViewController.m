//
//  DZYMeViewController.m
//  budejie
//
//  Created by dzy on 16/1/1.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYMeViewController.h"
#import "DZYSettingViewController.h"

@interface DZYMeViewController ()

@end

@implementation DZYMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupNavBar];
}

// 设置导航条
- (void)setupNavBar
{
    // UINavigationItem:决定导航条内容
    // UIBarButtonItem:决定导航条上按钮的内容
    
    // 设置
    UIBarButtonItem *settintItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(clickSetting)];
    
    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(clickNight:)];
    
    // right
    self.navigationItem.rightBarButtonItems = @[settintItem,nightItem];
 
    // title
    self.navigationItem.title = @"我的";
    

}

// 点击设置就会调用
- (void)clickSetting
{
    DZYSettingViewController *settingVc = [[DZYSettingViewController alloc] init];
    // 一定要在显示之前设置 隐藏底部条
    settingVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVc animated:YES];
}

// 进入夜间模式
- (void)clickNight:(UIButton *)btn
{
    btn.selected = !btn.selected;
}
@end
