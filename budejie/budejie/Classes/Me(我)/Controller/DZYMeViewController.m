//
//  DZYMeViewController.m
//  budejie
//
//  Created by dzy on 16/1/1.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYMeViewController.h"

@interface DZYMeViewController ()

@end

@implementation DZYMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DZYColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
