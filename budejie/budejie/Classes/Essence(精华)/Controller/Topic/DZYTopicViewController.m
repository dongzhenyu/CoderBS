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

/**** header - begin ****/
/** header */
@property (nonatomic, weak) UIView *header;
/** 文字 */
@property (nonatomic, weak) UILabel *headerLabel;
/** 是否正在刷新 */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
/**** header - end ****/

/**** footer - begin ****/
/** footer */
@property (nonatomic, weak) UIView *footer;
/** 文字 */
@property (nonatomic, weak) UILabel *footerLabel;
/** 是否正在刷新 */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;
/**** footer - end ****/

@end

@implementation DZYTopicViewController

static CGFloat const DZYHeaderH = 50;
static CGFloat const DZYFooterH = 35;

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
    
    // 加载最新帖子
//        [self loadNewTopics];
    
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
    // 下拉-加载最新
    UIView *header = [[UIView alloc] init];
    //    header.backgroundColor = [UIColor redColor];
    header.height = DZYHeaderH;
    header.width = self.tableView.width;
    header.x = 0;
    header.y = - header.height;
    [self.tableView addSubview:header];
    self.header = header;
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = header.bounds;
    headerLabel.text = @"下拉可以刷新";
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:headerLabel];
    self.headerLabel = headerLabel;
    
    //    self.tableView.tableHeaderView = [[UISwitch alloc] init];
    
    // 上拉 - 加载更多
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor orangeColor];
    footer.height = DZYFooterH;
    footer.width = self.tableView.width;
    self.tableView.tableFooterView = footer;
    self.footer = footer;
    
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.frame = footer.bounds;
    footerLabel.text = @"上拉可以加载更多";
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:footerLabel];
    self.footerLabel = footerLabel;
    
}

#pragma  mark - 数据处理
//- (DZYTopicType)type
//{
//    if (self.class == [DZYAllViewController class]) return DZYTopicTypeAll;
//    if (self.class == [DZYVideoViewController class]) return DZYTopicTypeVideo;
//    if (self.class == [DZYVoiceViewController class]) return DZYTopicTypeVoice;
//    if (self.class == [DZYPictureViewController class]) return DZYTopicTypePicture;
//    if (self.class == [DZYWordViewController class]) return DZYTopicTypeWord;
//    return 0;
//}

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
        
        // 结束刷新
        self.headerRefreshing = NO;
        // 恢复内边距
        [UIView animateWithDuration:0.25 animations:^{
            UIEdgeInsets inset = self.tableView.contentInset;
            inset.top -= DZYHeaderH;
            self.tableView.contentInset = inset;
        }];
        
    } failure:^(NSError *error) {[MBProgressHUD showError:@"请检查网络连接"];
        // 一个任务被取消了, 也会来自failure这个block, 并且error.code是NSURLErrorCancelled
        
        // 结束刷新
        self.headerRefreshing = NO;
        // 恢复内边距
        [UIView animateWithDuration:0.25 animations:^{
            UIEdgeInsets inset = self.tableView.contentInset;
            inset.top -= DZYHeaderH;
            self.tableView.contentInset = inset;
        }];
        
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
        
        // 结束刷新
        self.footerLabel.text = @"上拉可以加载更多";
        self.footerRefreshing = NO;
        
    } failure:^(NSError *error) {
        // 结束刷新
        self.footerLabel.text = @"上拉可以加载更多";
        self.footerRefreshing = NO;
        
    }];
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 根据数据的数量 来决定显示和隐藏刷新控件
    self.footer.hidden = (self.topics.count == 0);
    
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
    DZYLogFunc;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZYTopicModel *topicModel = self.topics[indexPath.row];
    
    // 根据模型计算cell的高度
    //    CGFloat cellHeight = 0;
    //
    //    // 头像
    //    cellHeight += 55;
    //
    //    // 文字
    //    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * DZYMargin;
    //    cellHeight += [topicModel.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height + DZYMargin;
    //    // 最热评论
    //    if (topicModel.top_cmt.count) {
    //        // 标题
    //        cellHeight += 18;
    //
    //        // 内容
    //        NSDictionary *dict = topicModel.top_cmt.firstObject;
    //        NSString *username = dict[@"user"][@"username"];
    //        NSString *content = dict[@"content"];
    //        NSString *cmt = [NSString stringWithFormat:@"%@:%@", username, content];
    //
    //        cellHeight += [cmt boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height + DZYMargin;
    //    }
    //
    //    // 工具条
    //    cellHeight += 35 + DZYMargin;
    
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
    
    // 处理下拉 - header
    [self dealHeader];
    
    // 处理上拉 - footer
    [self dealFooter];
    
}

/**
 * 停止拖拽(手松开)的时候调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    if (self.isFooterRefreshing) return;
    
    // 如果偏移量的y值 <= offsetY, 那么header就已经完全出现
    CGFloat offsetY =  - (self.tableView.contentInset.top + DZYHeaderH);
    if (self.tableView.contentOffset.y <= offsetY) { // 进入刷新状态
        self.headerLabel.text = @"正在刷新...";
        self.headerLabel.backgroundColor = [UIColor darkGrayColor];
        self.headerRefreshing = YES;
        
        // 增加内边距
        [UIView animateWithDuration:0.25 animations:^{
            UIEdgeInsets inset = self.tableView.contentInset;
            inset.top += DZYHeaderH;
            self.tableView.contentInset = inset;
        }];
        
        // 加载最新的帖子数据
        [self loadNewTopics];
    }
}

#pragma mark - 处理刷新控件
- (void)dealHeader
{
    // 如果正在刷新, 就直接返回
    if (self.isHeaderRefreshing) return;
    
    // 如果偏移量的y值 <= offsetY, 那么header就已经完全出现
    CGFloat offsetY =  - (self.tableView.contentInset.top + DZYHeaderH);
    if (self.tableView.contentOffset.y <= offsetY) {
        self.headerLabel.text = @"松开立即刷新";
        self.headerLabel.backgroundColor = [UIColor blueColor];
    } else {
        self.headerLabel.text = @"下拉可以刷新";
        self.headerLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)dealFooter
{
    // 如果还没有数据, 就直接返回
    if (self.topics.count == 0) return;
    // 如果正在刷新, 就直接返回
    if (self.isFooterRefreshing) return;
    //    if (self.isFooterRefreshing || self.isHeaderRefreshing) return;
    
    // 当scrollView的偏移量y值 >= offsetY时, footer就已经完全出现
    CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.height;
    if (self.tableView.contentOffset.y >= offsetY) {
        // 进入刷新状态
        self.footerRefreshing = YES;
        
        // 修改刷新控件的显示文字
        self.footerLabel.text = @"正在加载更多数据...";
        
        // 发送请求给服务器, 加载下一页数据
        [self loadMoreTopics];
    }
    
}
@end
