//
//  DZYPostWordToolBar.m
//  budejie
//
//  Created by dzy on 16/1/19.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYPostWordToolBar.h"
#import "DZYAddTagViewController.h"
#import "DZYNavigationController.h"

@interface DZYPostWordToolBar ()
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation DZYPostWordToolBar

- (void)awakeFromNib
{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:addButton];
}

- (void)addClick
{
    DZYAddTagViewController *addVc = [[DZYAddTagViewController alloc] init];
    DZYNavigationController *nav = [[DZYNavigationController alloc] initWithRootViewController:addVc];
    // 拿到窗口根控制器曾经modal出来的发表文字所在的导航控制器
    UIViewController *vc = self.window.rootViewController.presentedViewController;
    [vc presentViewController:nav animated:YES completion:nil];

}

@end
