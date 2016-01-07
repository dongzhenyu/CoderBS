//
//  DZYFriendTrendsViewController.m
//  budejie
//
//  Created by dzy on 16/1/1.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYFriendTrendsViewController.h"
#import "DZYLoginRegisterViewController.h"

@interface DZYFriendTrendsViewController ()

@end

@implementation DZYFriendTrendsViewController

- (IBAction)loginBtnClick:(id)sender {
    
    DZYLoginRegisterViewController *loginVc = [[DZYLoginRegisterViewController alloc] init];
    [self presentViewController:loginVc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航条
    [self setupNavBar];
}

// 设置导航条
- (void)setupNavBar
{
    // UINavigationItem:决定导航条内容
    // UIBarButtonItem:决定导航条上按钮的内容
    
    // left
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(clickRecomment)];
    
    // title
    self.navigationItem.title = @"我的关注";
}

// 点击推荐就会调用
- (void)clickRecomment
{
    
}



@end
