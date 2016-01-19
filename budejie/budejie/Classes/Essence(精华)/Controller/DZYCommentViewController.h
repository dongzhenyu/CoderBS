//
//  DZYCommentViewController.h
//  budejie
//
//  Created by dzy on 16/1/19.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DZYTopicModel;
@interface DZYCommentViewController : UITableViewController

/** 帖子模型 */
@property (nonatomic, strong) DZYTopicModel *topicModel;
@end
