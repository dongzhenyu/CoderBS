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

/** 动画时间 */
@property (nonatomic, strong) NSArray *times;

@end

@implementation DZYPublishViewController

- (NSArray *)times
{
    if (!_times) {
        CGFloat interval = 0.1; // 时间间隔
        _times = @[@(5 * interval),
                   @(4 * interval),
                   @(3 * interval),
                   @(2 * interval),
                   @(0 * interval),
                   @(1 * interval),
                   @(6 * interval)
                   ];
    }
    return _times;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    // 设置标语
    [self setupSloganView];

    // 按钮
    [self setupButtons];
}

- (void)setupSloganView
{

    CGFloat sloganY = DZYScreenH * 0.2;
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    sloganView.y = sloganY - DZYScreenH;
    sloganView.centerX = DZYScreenW * 0.5;
    [self.view addSubview:sloganView];
    self.sloganView = sloganView;

    // 动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.toValue = @(sloganY);
    anim.springSpeed = 10;
    anim.springBounciness = 10;
    anim.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    [sloganView.layer pop_addAnimation:anim forKey:nil];
    
}

- (void)setupButtons
{
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
        
        // 设置内容
        [pulishButton setTitle:titles[i] forState:UIControlStateNormal];
        [pulishButton setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        // frame
        CGFloat buttonX = (i % maxColsCount) * buttonW;
        CGFloat buttonY = buttonStartY + (i / maxColsCount) * buttonH;
//        pulishButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY - DZYScreenH, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        anim.springSpeed = 10;
        anim.springBounciness = 10;
        // CACurrentMediaTime() 获得的是当前的时间
        anim.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
        [pulishButton pop_addAnimation:anim forKey:nil];
    }

}


#pragma mark - 按钮点击
- (void)buttonClick:(DZYPublishButton *)button
{
    
}
- (IBAction)cancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
