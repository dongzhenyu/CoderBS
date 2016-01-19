//
//  DZYTopicViewController.m
//  budejie
//
//  Created by dzy on 16/1/18.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYTopicViewController.h"
#import "HttpRequest.h"
#import <MJExtension.h>
#import "DZYTopicModel.h"
#import "DZYTopicCell.h"
#import "MBProgressHUD+MJ.h"
#import <UIImageView+WebCache.h>
#import "UIScrollView+DDBackTop.h"
#import "DDBackTopButton.h"
#import <MJRefresh.h>
#import "DZYHeader.h"
#import "DZYFooter.h"

#import "DZYCommentViewController.h"

//#import "DZYAllViewController.h"
//#import "DZYVideoViewController.h"
//#import "DZYVoiceViewController.h"
//#import "DZYPictureViewController.h"
//#import "DZYWordViewController.h"
#import "DZYNewViewController.h"

@interface DZYTopicViewController ()
/** 发送请求的管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
/** 所有帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;

@end

@implementation DZYTopicViewController

static NSString * const DZYTopicCellID = @"topic";

- (DZYTopicType)type
{
    return 0;
}

/**
 *  mgr懒加载方法
 */
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTable];
    
    // 添加刷新控件
    [self setupRefresh];
    
}

// 处理表格
- (void)setupTable
{
    self.tableView.backgroundColor = DZYColor(200, 200, 200);
    self.tableView.contentInset = UIEdgeInsetsMake(DZYNavY + DZYTitleH, 0, DZYTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 添加返回按钮
    [self.tableView addBackTop];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DZYTopicCell class]) bundle:nil] forCellReuseIdentifier:DZYTopicCellID];
}

- (void)setupRefresh
{
    self.tableView.mj_header = [DZYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [DZYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

#pragma  mark - 数据处理
/**
 * a 参数
 */
- (NSString *)a
{
    if ([self.parentViewController isKindOfClass:[DZYNewViewController class]]) {
        return @"newlist";
    }
    return @"list";
}

#pragma mark - 数据处理
- (void)loadNewTopics
{
    // 取消任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = self.a;
    parameters[@"type"] = @(self.type);
    parameters[@"c"] = @"data";
    
    [HttpRequest get:BaseRequestURL params:parameters sucess:^(id json) {
        
        // 存储maxtime, 用来加载下一页数据
        self.maxtime = json[@"info"][@"maxtime"];
        
        // 字典数组 -> XMGTopic模型数组
        self.topics = [DZYTopicModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];

        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {[MBProgressHUD showError:@"请检查网络连接"];

        [self.tableView.mj_header endRefreshing];

    }];
}

- (void)loadMoreTopics
{
    // 取消任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = self.a;
    parameters[@"type"] = @(self.type);
    parameters[@"c"] = @"data";
    parameters[@"maxtime"] = self.maxtime;
    
    [HttpRequest get:BaseRequestURL params:parameters sucess:^(id json) {
        
        //        DZYWriteToPlist(json, @"topic");
        
        // 存储maxtime, 用来加载下一页数据
        self.maxtime = json[@"info"][@"maxtime"];
        
        // 字典数组 -> XMGTopic模型数组
        NSArray *moreTopics = [DZYTopicModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
        [self.topics addObjectsFromArray:moreTopics];
        
        // 刷新表格
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 根据数据的数量 来决定显示和隐藏刷新控件
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZYTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:DZYTopicCellID];
    
    cell.topicModel = self.topics[indexPath.row];
    
    return cell;
}
#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZYCommentViewController *commentVc = [[DZYCommentViewController alloc] init];
    commentVc.topicModel = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZYTopicModel *topicModel = self.topics[indexPath.row];
    
    return topicModel.cellHeight;
}
#pragma mark - 代理方法
/**
 * 只要scrollView在滚动,就会调用这个方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 每当scrollView滚动,就会清除内存缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
}
@end
