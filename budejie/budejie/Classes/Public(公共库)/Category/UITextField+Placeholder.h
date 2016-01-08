//
//  UITextField+Placeholder.h
//  budejie
//
//  Created by dzy on 16/1/7.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Placeholder)

@property UIColor *placeholderColor;

- (void)dzy_setPlaceholder:(NSString *)placeholder;
@end
