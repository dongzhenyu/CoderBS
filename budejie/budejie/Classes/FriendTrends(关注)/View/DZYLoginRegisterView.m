//
//  DZYLoginRegisterView.m
//  budejie
//
//  Created by dzy on 16/1/7.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYLoginRegisterView.h"

@interface DZYLoginRegisterView ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation DZYLoginRegisterView

- (void)awakeFromNib
{
    UIImage *image = _loginButton.currentBackgroundImage;
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    [_loginButton setBackgroundImage:image forState:UIControlStateNormal];
    
    // 拉伸高亮
    UIImage *highImage = _loginButton.currentBackgroundImage;
    highImage = [highImage stretchableImageWithLeftCapWidth:highImage.size.width * 0.5 topCapHeight:highImage.size.height * 0.5];
    [_loginButton setBackgroundImage:highImage forState:UIControlStateHighlighted];
}

+ (instancetype)loginViewForXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}

+ (instancetype)registerViewForXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][1];
}

@end
