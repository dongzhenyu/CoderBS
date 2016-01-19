//
//  DZYHeader.m
//  budejie
//
//  Created by dzy on 16/1/18.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYHeader.h"

@interface DZYHeader ()

/**  */
@property (nonatomic, weak) UIImageView *logoView;

@end

@implementation DZYHeader

/**
 *  初始化
 */
- (void)prepare
{
    [super prepare];
    
    // 自动改变透明度
    self.automaticallyChangeAlpha = YES;
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    // 修改文字状态颜色
    self.stateLabel.textColor = [UIColor redColor];
    // 设置不同状态下文字
    [self setTitle:@"下拉吧,亲" forState:MJRefreshStateIdle];
    [self setTitle:@"松开🐴上刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"正在拼命加载数据..." forState:MJRefreshStateRefreshing];
    
    // 添加logo
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    [self addSubview:logoView];
    self.logoView = logoView;
}

/**
 * 布局子控件
 */
- (void)placeSubviews
{
    [super placeSubviews];
    self.logoView.centerX = self.width * 0.5;
    self.logoView.y = -self.logoView.height;
}

@end
