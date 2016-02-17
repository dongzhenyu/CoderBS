//
//  DZYCommentViewController.m
//  budejie
//
//  Created by dzy on 16/2/8.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYCommentViewController.h"
#import "DZYTopicModel.h"
#import "DZYTopicCell.h"
#import "DZYCommentCell.h"


@interface DZYCommentViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@end

@implementation DZYCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"comment_nav_item_share_icon"] highImage:[UIImage imageNamed:@"comment_nav_item_share_icon_click"] target:nil action:nil];
    // 监听键盘的弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self setupTable];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTable
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DZYTopicCell class]) bundle:nil] forCellReuseIdentifier:@"topic"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DZYCommentCell class]) bundle:nil] forCellReuseIdentifier:@"comment"];
    
}
#pragma mark - 监听键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 工具条平移的距离 = 屏幕高度 - 键盘最终的Y值
    self.bottomSpace.constant = DZYScreenH - [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        // 约束做动画 只需要更新一下就可以
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 1;
    if (section == 1) return 10;
    return 25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // 帖子
        return [tableView dequeueReusableCellWithIdentifier:@"topic"];
    } else { // 评论
        return [tableView dequeueReusableCellWithIdentifier:@"comment"];
    }
}

#pragma mark - 代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 200;
    } else {
        return 50;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    if (section == 1) {
        return @"最热评论";
    }
    return @"最新评论";
}
@end
