//
//  DZYAdViewController.m
//  budejie
//
//  Created by dzy on 16/1/4.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYAdViewController.h"
#import "HttpRequest.h"
#import <AFNetworking.h>
#import "DZYAdModal.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "DZYTabBarViewController.h"

static NSString * const  code2 = @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam";

@interface DZYAdViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *lauchView;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;

/** <#type#> */
@property (nonatomic, strong) DZYAdModal *adModal;

@end

@implementation DZYAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置启动图片
    [self setupLauchImage];
    // 加载广告数据
    [self loadAdData];
    // 添加定时器
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
}

- (void)loadAdData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"code2"] = code2;
    
    [HttpRequest get:DZYAdRequestURL params:params
        sucess:^(id json) {

            // 解析返回数据
            NSDictionary *dict = [json[@"ad"] firstObject];
            // 字典转模型
            self.adModal = [DZYAdModal mj_objectWithKeyValues:dict];
            // 计算图片显示高度
            CGFloat imageH = DZYScreenW / self.adModal.w * self.adModal.h;
            // 显示广告界面
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DZYScreenW, imageH)];
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.adModal.w_picurl]];
            [self.adView addSubview:imageView];
            
            // 添加点按手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
            [imageView addGestureRecognizer:tap];
            
       } failure:^(NSError *error) {
           DZYLog(@"%@", error);
       }];
}

// 点击广告界面调用
- (void)tap
{
    NSURL *url = [NSURL URLWithString:self.adModal.ori_curl];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        // 跳转到对应界面 展示网址
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - 定时器
- (void)timeChange
{
    // 定义广告时间
    static int time = 3;
    
    // 时间到了就跳转
    if (time == 0) {
        [self jumpMain:nil];
    }
    
    // 时间减少
    time--;
    
    // 设置跳转按钮
    [self.jumpButton setTitle:[NSString stringWithFormat:@" 跳转(%d) ",time] forState:UIControlStateNormal];
    
}

#pragma mark - 点击事件处理
// 点击跳过,进入主框架界面,modal,更换窗口的根控制器
- (IBAction)jumpMain:(id)sender {
    // 创建主框架
    DZYTabBarViewController *tabBarVc = [[DZYTabBarViewController alloc] init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
    
}

- (void)setupLauchImage
{
    // 判断下屏幕尺寸
    // 480:LaunchImage-700 568:LaunchImage-700-568
    // 667:LaunchImage-800-667h 736:LaunchImage-800-Portrait-736h
    if (iPhone4) { // iPhone4
//        DZYLog(@"iPhone4");
        _lauchView.image = [UIImage imageNamed:@"LaunchImage-700"];
    } else if (iPhone5) {
        _lauchView.image = [UIImage imageNamed:@"LaunchImage-700-568h"];
    } else if (iPhone6) {
        _lauchView.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    } else if (iPhone6p) {
        _lauchView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h"];
    }
    
}


@end
