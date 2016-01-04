//
//  DZYEssenceViewController.m
//  budejie
//
//  Created by dzy on 16/1/1.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYEssenceViewController.h"

@interface DZYEssenceViewController ()

@end

@implementation DZYEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DZYColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    // 设置导航条
    [self setupNavBar];
}

// 设置导航条
- (void)setupNavBar
{
    // UINavigationItem:决定导航条内容
    // UIBarButtonItem:决定导航条上按钮的内容
    
    // left
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];
    
    // right
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:nil action:nil];
    
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}



- (void)game
{
    DZYLogFunc;
}


@end
