//
//  DZYTagButton.m
//  budejie
//
//  Created by dzy on 16/1/20.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYTagButton.h"

#define DZYTagBgColor DZYColor(70, 142, 243);

@implementation DZYTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DZYTagBgColor;
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.titleLabel.font = DZYFont;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    // 自动计算
    [self sizeToFit];
    
    self.width += 3 * DZYSmallMargin;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.x = DZYSmallMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + DZYSmallMargin;
}

@end
