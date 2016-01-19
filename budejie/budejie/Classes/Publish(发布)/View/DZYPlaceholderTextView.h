//
//  DZYPlaceholderTextView.h
//  budejie
//
//  Created by dzy on 16/1/19.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZYPlaceholderTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;

/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
