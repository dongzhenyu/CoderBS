//
//  DZYMeViewController.m
//  budejie
//
//  Created by dzy on 16/1/1.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYMeViewController.h"
#import "DZYSettingViewController.h"
#import "DZYSquareCell.h"
#import "HttpRequest.h"
#import <MJExtension/MJExtension.h>
#import "DZYSquareModel.h"
#import "DZYHtmlViewController.h"

@interface DZYMeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

/** <#type#> */
@property (nonatomic, weak) UICollectionView *collectionView;

/** 方块模型数组 */
@property (nonatomic, strong) NSMutableArray *squareList;

@end

@implementation DZYMeViewController

#define itemWH  ((DZYScreenW - (cols - 1) * margin) / cols)
static CGFloat const margin = 1;
static NSInteger const cols = 4;
static NSString * const DZYSquareCellId = @"squareCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    // 设置footView
    [self setupFootView];
    // 请求数据
    [self loadData];
    
    self.tableView.sectionFooterHeight = DZYMargin;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(DZYMargin - 35, 0, 0, 0);
    // 注意:tableView额外滚动区域,在之前的基础上相加.
}

- (void)loadData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    
    [HttpRequest get:BaseRequestURL params:parameters sucess:^(id json) {
        
//        DZYLog(@"%@", json);
//        DZYWriteToPlist(json, @"square");
        self.squareList = [DZYSquareModel mj_objectArrayWithKeyValuesArray:json[@"square_list"]];
        
        // 处理数据
        [self resolveData];
        
        [self.collectionView reloadData];
        
        NSInteger count = self.squareList.count;
        // 计算collectionView的高度 行数 = (总数 - 1) / cols + 1
        NSInteger rows = (count - 1) / cols + 1;
        CGFloat collectionViewH = rows * itemWH;
        self.collectionView.height = collectionViewH;
        
        // 设置tableView滚动范围 (会有bug )
        //        self.tableView.contentSize = CGSizeMake(0, CGRectGetMaxY(_collectionView.frame));
        // tableView的滚动范围自己管理,只需要给他指定内容,会自动计算自己的滚动范围.
        // 设置tableView底部视图
        self.tableView.tableFooterView = _collectionView;
        // 如果出现下面有间距可以再刷新一次tabView
//        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)resolveData
{
    // 判断下还差几个
    NSInteger count = self.squareList.count;
    NSInteger exter = count % cols;
    
    if (exter) {
        exter = cols - exter;
        for (int i = 0; i < exter; i++) {
            DZYSquareModel *squareModel = [[DZYSquareModel alloc] init];
            [self.squareList addObject:squareModel];
        }
    }
    
}

- (void)setupFootView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置item的尺寸
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    // 设置cell间距
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DZYScreenW, 300) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = self.tableView.backgroundColor;
    self.collectionView = collectionView;
    
    self.tableView.tableFooterView = collectionView;

    // 注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DZYSquareCell class]) bundle:nil] forCellWithReuseIdentifier:DZYSquareCellId];
    // 不允许滚动
    collectionView.scrollEnabled = NO;
}

// 设置导航条
- (void)setupNavBar
{
    // UINavigationItem:决定导航条内容
    // UIBarButtonItem:决定导航条上按钮的内容
    
    // 设置
    UIBarButtonItem *settintItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(clickSetting)];
    
    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(clickNight:)];
    
    // right
    self.navigationItem.rightBarButtonItems = @[settintItem,nightItem];
 
    // title
    self.navigationItem.title = @"我的";
    

}

// 点击设置就会调用
- (void)clickSetting
{
    DZYSettingViewController *settingVc = [[DZYSettingViewController alloc] init];
    // 一定要在显示之前设置 隐藏底部条
    settingVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVc animated:YES];
}

// 进入夜间模式
- (void)clickNight:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

#pragma mark - UICollectionViewDataSoures
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.squareList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DZYSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DZYSquareCellId forIndexPath:indexPath];
    
    cell.squareModel = self.squareList[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取模型
    DZYSquareModel *squareModel = self.squareList[indexPath.item];
    if ([squareModel.url hasPrefix:@"http"]) {
        // 自定义展示网页控制器
        DZYHtmlViewController *htmlVc = [[DZYHtmlViewController alloc] init];
        htmlVc.url = [NSURL URLWithString:squareModel.url];
        // 跳转到网页
        [self.navigationController pushViewController:htmlVc animated:YES];
    }
    
}
@end
