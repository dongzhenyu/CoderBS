//
//  DZYSettingViewController.m
//  budejie
//
//  Created by dzy on 16/1/4.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYSettingViewController.h"
#import "DZYFileCacheManager.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define DZYCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

@interface DZYSettingViewController ()

/** 缓存大小 */
@property (nonatomic, assign) NSInteger total;

@end

@implementation DZYSettingViewController

static NSString * const ID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"jump" style:0 target:self action:@selector(jumpClick)];
    
    // 注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    // 展示指示器
    [SVProgressHUD showWithStatus:@"正在计算缓存文件"];
    
    // 计算缓存
    [DZYFileCacheManager getDirectoryCacheSize:DZYCachePath completeBlock:^(NSInteger total) {
        
        [SVProgressHUD dismiss];
        self.total = total;
        [self.tableView reloadData];

    }];
}

- (void)jumpClick
{
    UIViewController *viewVc = [[UIViewController alloc] init];
    viewVc.view.backgroundColor = [UIColor greenColor];
    [self.navigationController pushViewController:viewVc animated:YES];
}

#pragma mark - tabViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];

    //    // 2.设置缓存字符换
    cell.textLabel.text = [self getCacheStr:_total];
    
    return cell;
}

#pragma mark - tabViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    // 清空缓存
    [DZYFileCacheManager deleteFilePath:DZYCachePath];
    // 重新获取缓存尺寸()
    [DZYFileCacheManager getDirectoryCacheSize:DZYCachePath completeBlock:^(NSInteger total) {
        self.total = total;
        [self.tableView reloadData];
    }];
    
    [self.tableView reloadData];
   
}

- (NSString *)getCacheStr:(NSInteger)cacheSize
{
//    DZYLog(@"%ld", cacheSize);

    NSString *cacheStr = [NSString stringWithFormat:@"%ldB",cacheSize];
    
    if (cacheSize > 1000 * 1000) { // 1.2MB
        CGFloat cacheSizeMB = cacheSize / (1000 * 1000);
        cacheStr = [NSString stringWithFormat:@"%.1fMB",cacheSizeMB];
    } else if (cacheSize > 1000) { // KB
        CGFloat cacheSizeKB = cacheSize / 1000;
        cacheStr = [NSString stringWithFormat:@"%.1fKB",cacheSizeKB];
    }
    return  cacheSize > 0 ? [NSString stringWithFormat:@"清除缓存(%@)",cacheStr] : @"清除缓存";
}

@end
