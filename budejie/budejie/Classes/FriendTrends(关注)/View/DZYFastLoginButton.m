//
//  DZYFastLoginButton.m
//  budejie
//
//  Created by dzy on 16/1/7.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYFastLoginButton.h"

@implementation DZYFastLoginButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.x = (self.width - self.imageView.width) * 0.5;
    self.imageView.y = 0;
    
    // 调整文字
    // 计算文字尺寸,设置文字宽度
    [self.titleLabel sizeToFit];
    self.titleLabel.x = (self.width - self.titleLabel.width) * 0.5;
    self.titleLabel.y = self.height - self.titleLabel.height;
}

@end
