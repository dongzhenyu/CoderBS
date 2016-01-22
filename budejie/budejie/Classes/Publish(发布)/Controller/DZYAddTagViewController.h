//
//  DZYAddTagViewController.h
//  budejie
//
//  Created by dzy on 16/1/20.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DZYAddTagViewController;
@protocol DZYAddTagViewControllerDelegate <NSObject>

@optional

- (void)addTagViewController:(DZYAddTagViewController *)addVc didReceiveTags:(NSArray *)tags;

@end
@interface DZYAddTagViewController : UIViewController

// 定义一个代理属性 传递tag数据
@property (nonatomic, weak) id<DZYAddTagViewControllerDelegate> delegate;

/** 从上一个界面传递过来的标签数据 */
@property (nonatomic, strong) NSArray *tags;

@end
