//
//  DZYNewViewController.m
//  budejie
//
//  Created by dzy on 16/1/1.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYNewViewController.h"

@interface DZYNewViewController ()

@end

@implementation DZYNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DZYColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    [self setupNavBar];
}

// 设置导航条
- (void)setupNavBar
{
    // UINavigationItem:决定导航条内容
    // UIBarButtonItem:决定导航条上按钮的内容
    
    // left
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(clickSubTag)];
    
    
    
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}

// 点击标签按钮
- (void)clickSubTag
{
    
}

@end
