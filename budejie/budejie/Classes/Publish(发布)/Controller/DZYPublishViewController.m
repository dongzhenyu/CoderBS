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
#import "DZYPostWordViewController.h"
#import "DZYNavigationController.h"

@interface DZYPublishViewController ()

/** 标语 */
@property (nonatomic, weak) UIImageView *sloganView;

/** 按钮 */
@property (nonatomic, strong) NSMutableArray *buttons;

/** 动画时间 */
@property (nonatomic, strong) NSArray *times;

/** <#type#> */
@property (nonatomic, weak) DZYPublishButton *publishBtn;

@end

@implementation DZYPublishViewController

static CGFloat const DZYSpringFactor = 10;

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

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

    // 禁止交互
    self.view.userInteractionEnabled = NO;
    
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
    __weak typeof(self) weakSelf = self;
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.toValue = @(sloganY);
    anim.springSpeed = DZYSpringFactor;
    anim.springBounciness = DZYSpringFactor;
    anim.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        // 开始交互
        weakSelf.view.userInteractionEnabled = YES;
    }];
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
//        pulishButton.width = -1;
        [pulishButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:pulishButton];
        [self.view addSubview:pulishButton];
        
        // 设置内容
        [pulishButton setTitle:titles[i] forState:UIControlStateNormal];
        [pulishButton setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        self.publishBtn = pulishButton;
        
        // frame
        CGFloat buttonX = (i % maxColsCount) * buttonW;
        CGFloat buttonY = buttonStartY + (i / maxColsCount) * buttonH;
//        pulishButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY - DZYScreenH, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        anim.springSpeed = DZYSpringFactor;
        anim.springBounciness = DZYSpringFactor;
        // CACurrentMediaTime() 获得的是当前的时间
        anim.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
        [pulishButton pop_addAnimation:anim forKey:nil];
    }

}

#pragma mark - 按钮点击
- (void)buttonClick:(DZYPublishButton *)button
{
    // 按钮索引
    NSInteger index = [self.buttons indexOfObject:button];
    
    switch (index) {
        case 0:
            break;
        case 1:
            break;
        case 2: {// 发段子
            DZYPostWordViewController *postWordVc = [[DZYPostWordViewController alloc] init];
            postWordVc.wordBtn = button;
            [self presentViewController:[[DZYNavigationController alloc] initWithRootViewController:postWordVc] animated:YES completion:nil];
            break;
        }
        case 3:
            break;
        case 4:
            break;
        default:
            break;
    }
}

/**
 *  退出动画
 */
- (void)exit:(void(^)())task
{
    // 禁止交互
    self.view.userInteractionEnabled = NO;
    
    // 让按钮执行动画
    for (int i = 0; i < self.buttons.count; i++) {
        DZYPublishButton *publishButton = self.buttons[i];
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        anim.toValue = @(publishButton.layer.position.y + DZYScreenH);
        anim.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
        [publishButton.layer pop_addAnimation:anim forKey:nil];
    }
    
    __weak typeof(self) weakSelf = self;
    // 让标题执行动画
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.toValue = @(self.sloganView.layer.position.x + DZYScreenH);
    anim.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
        
        // 可能会做其他事情
//        if (task) task();
        !task ? :task();
        
    }];
    [self.sloganView.layer pop_addAnimation:anim forKey:nil];
    
}

#pragma mark - 点击
- (IBAction)cancelClick {
    [self exit:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self exit:nil];
}


@end
