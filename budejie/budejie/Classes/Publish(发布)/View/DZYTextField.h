//
//  DZYTextField.h
//  budejie
//
//  Created by dzy on 16/1/21.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZYTextField : UITextField

/** 点击删除时需要执行的操作 */
@property (nonatomic, copy) void (^deleteBackwardOperation)();

@end
