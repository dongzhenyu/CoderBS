

//
//  DZYTextField.m
//  budejie
//
//  Created by dzy on 16/1/21.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYTextField.h"

@implementation DZYTextField

/**
 *  监听键盘内部的删除键点击
 */
- (void)deleteBackward
{
    !self.deleteBackwardOperation ? : self.deleteBackwardOperation();
    [super deleteBackward];
}

@end
