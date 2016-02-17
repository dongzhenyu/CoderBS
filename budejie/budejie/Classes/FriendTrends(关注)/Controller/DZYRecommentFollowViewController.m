//
//  DZYRecommentFollowViewController.m
//  budejie
//
//  Created by dzy on 16/1/26.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYRecommentFollowViewController.h"
#import "DZYCategroyCell.h"
#import "DZYUserCell.h"

@interface DZYRecommentFollowViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@end

@implementation DZYRecommentFollowViewController

static NSString * const DZYCategroyCellId = @"category";
static NSString * const DZYUserCellId = @"user";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTable];
}

- (void)setupTable
{
    self.title = @"推荐关注";
    self.view.backgroundColor = DZYColor(200, 200, 200);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIEdgeInsets inset = UIEdgeInsetsMake(DZYNavY, 0, 0, 0);
    self.leftTableView.contentInset = inset;
    self.leftTableView.scrollIndicatorInsets = inset;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DZYCategroyCell class]) bundle:nil] forCellReuseIdentifier:DZYCategroyCellId];
    
    self.rightTableView.rowHeight = 70;
    self.rightTableView.contentInset = inset;
    self.rightTableView.scrollIndicatorInsets = inset;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DZYUserCell class]) bundle:nil] forCellReuseIdentifier:DZYUserCellId];
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return 20;
    } else {
        return 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        DZYCategroyCell *cell = [tableView dequeueReusableCellWithIdentifier:DZYCategroyCellId];
        return cell;
    } else {
        DZYUserCell *cell = [tableView dequeueReusableCellWithIdentifier:DZYUserCellId];
        return cell;
    }
}
@end
