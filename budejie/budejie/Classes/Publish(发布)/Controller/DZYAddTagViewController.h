//
//  DZYAddTagViewController.h
//  budejie
//
//  Created by dzy on 16/1/20.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZYAddTagViewController : UIViewController

/** 传递tag数据的block block的参数是一个字符串数组 */
@property (nonatomic, copy) void (^getTagsBlock)(NSArray *);

/** 从上一个界面传递过来的标签数据 */
@property (nonatomic, strong) NSArray *tags;

@end
