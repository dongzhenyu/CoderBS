//
//  DZYTitleButton.m
//  budejie
//
//  Created by dzy on 16/1/8.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYTitleButton.h"

@implementation DZYTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 固定设置
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

@end
