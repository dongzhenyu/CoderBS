//
//  DZYPublishViewController.m
//  budejie
//
//  Created by dzy on 16/1/1.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYPublishViewController.h"
#import <POP.h>
#import "DZYPublishButton.h"

@interface DZYPublishViewController ()

/** 标语 */
@property (nonatomic, weak) UIImageView *sloganView;

@end

@implementation DZYPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    // 设置标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    sloganView.y = DZYScreenH * 0.15;
    sloganView.centerX = DZYScreenW * 0.5;
    [self.view addSubview:sloganView];
    self.sloganView = sloganView;
    
    // 按钮
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    NSUInteger count = images.count;
    NSUInteger maxColsCount = 3;
    NSUInteger rowsCount = (count + maxColsCount - 1) / maxColsCount;
    
    // 按钮的尺寸
    CGFloat buttonW = DZYScreenW / maxColsCount;
    CGFloat buttonH = buttonW * 0.85;
    CGFloat buttonStartY = (DZYScreenH - rowsCount * buttonH) * 0.5;
    
    for (int i = 0; i < count; i++) {
        DZYPublishButton *pulishButton = [DZYPublishButton buttonWithType:UIButtonTypeCustom];
        [pulishButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:pulishButton];
        
        // frame
        CGFloat buttonX = (i % maxColsCount) * buttonW;
        CGFloat buttonY = buttonStartY + (i / maxColsCount) * buttonH;
        pulishButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 设置内容
        [pulishButton setTitle:titles[i] forState:UIControlStateNormal];
        [pulishButton setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
    }

}

- (void)buttonClick:(DZYPublishButton *)button
{
    
}

#pragma mark - 按钮点击
- (IBAction)cancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
