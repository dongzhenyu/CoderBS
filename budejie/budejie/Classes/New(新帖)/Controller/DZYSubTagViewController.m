//
//  DZYSubTagViewController.m
//  budejie
//
//  Created by dzy on 16/1/5.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYSubTagViewController.h"
#import "HttpRequest.h"
#import "DZYTagModel.h"
#import <MJExtension.h>
#import "DZYTagCell.h"
#import <MBProgressHUD.h>
#import <SVProgressHUD.h>

@interface DZYSubTagViewController ()

/** 标签数组 */
@property (nonatomic, strong) NSArray *tags;

/** <#type#> */
@property (nonatomic, weak) AFHTTPSessionManager *manager;

@end

@implementation DZYSubTagViewController

static NSString * const ID = @"tag";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐标签";
    
    // 加载数据
    [self loadNewData];
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DZYTagCell class]) bundle:nil] forCellReuseIdentifier:ID];
    // 去掉系统自带的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = DZYColor(206, 206, 206);
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 隐藏指示器
    [MBProgressHUD hideHUD];
    // 取消所有请求数据
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

- (void)loadNewData
{
    [MBProgressHUD showMessage:@"正在加载数据...." toView:nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    
    [HttpRequest get:@"http://api.budejie.com/api/api_open.php" params:params sucess:^(id json) {
        
        
//        DZYWriteToPlist(json, @"topic");
        self.tags = [DZYTagModel mj_objectArrayWithKeyValuesArray:json];
        
        [self.tableView reloadData];
        
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    DZYTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.tagModel = self.tags[indexPath.row];

//    DZYLog(@"%p", cell);
    
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
