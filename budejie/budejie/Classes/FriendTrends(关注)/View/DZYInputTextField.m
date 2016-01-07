//
//  DZYInputTextField.m
//  budejie
//
//  Created by dzy on 16/1/7.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYInputTextField.h"

/*
 解决:
 1.修改光标
 2.修改占位文字颜色
 
 在哪个方法做事情 -init awakeFromNib
 */
@implementation DZYInputTextField

// 当对象从xib加载完成就会调用
- (void)awakeFromNib
{
    // 1.设置光标
    self.tintColor = [UIColor whiteColor];
    
    // 初始化占位文字
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attr];
    self.attributedPlaceholder = attrS;
    
    // 监听文本框:1.代理(🙅) 2.addtarget 3.通知
    // 封装自己类,做好不要自己成为自己的代理,导致别人使用不好使.
    // 监听开始编辑
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    
    // 监听结束编辑
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
}

// 文本框开始编辑:监听文本框什么时候开始编辑
- (void)textBegin
{
    // 2.设置占位文字颜色
    // 创建描述文本的字典
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attr];
    self.attributedPlaceholder = attrS;
}

- (void)textEnd
{
    // 创建描述文本的字典
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attr];
    self.attributedPlaceholder = attrS;
}
@end
