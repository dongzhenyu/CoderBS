//
//  DZYSettingViewController.m
//  budejie
//
//  Created by dzy on 16/1/4.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYSettingViewController.h"

@interface DZYSettingViewController ()

@end

@implementation DZYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(backBtnClick) title:@"返回"];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
