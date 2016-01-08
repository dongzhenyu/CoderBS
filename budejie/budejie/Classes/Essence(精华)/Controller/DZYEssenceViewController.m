//
//  DZYEssenceViewController.m
//  budejie
//
//  Created by dzy on 16/1/1.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYEssenceViewController.h"
#import "DZYTitleButton.h"



@interface DZYEssenceViewController ()

/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;

/** 记录按钮点击 */
@property (nonatomic, weak) DZYTitleButton *clickTitleButton;

/** 下划线 */
@property (nonatomic, weak) UIView *underLine;

@end

@implementation DZYEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航条
    [self setupNavBar];
    // 设置scrollView
    [self setupScrollView];
    // 设置标题栏
    [self setupTitlesView];
}

#pragma mark - 初始化
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.backgroundColor = DZYRandomColor;
    [self.view addSubview:scrollView];
}

- (void)setupTitlesView
{
    UIView *titlesView = [[UIView alloc] init];
    titlesView.frame = CGRectMake(0, DZYNavY, self.view.width, 35);
    titlesView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 设置按钮
    [self setupTitleButtons];
    // 设置下划线
    [self setupUnderLine];
}

- (void)setupTitleButtons
{
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    
    // 标题的宽高
    CGFloat titleButtonW = self.titlesView.width / 5;
    CGFloat titleButtonH = self.titlesView.height;
    
    for (NSUInteger i = 0; i < 5; i++) {
        // 创建添加
        DZYTitleButton *titleButton = [DZYTitleButton buttonWithType:UIButtonTypeCustom];
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:titleButton];
        
        // frame
        CGFloat titleButtonX = titleButtonW * i;
        titleButton.frame = CGRectMake(titleButtonX, 0, titleButtonW, titleButtonH);
        
        // 数据
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        
    }
}

- (void)setupUnderLine
{
    // 第一个按钮
    DZYTitleButton *firstTitleButton = self.titlesView.subviews.firstObject;
    
    UIView *underLine = [[UIView alloc] init];;
    underLine.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    underLine.height = 2;
    underLine.y = self.titlesView.height - underLine.height;
    
    [self.titlesView addSubview:underLine];
    self.underLine = underLine;
    
    // 默认选中第一个按钮
    firstTitleButton.selected = YES;// UIControlStateSelected
    self.clickTitleButton = firstTitleButton;
    
    [firstTitleButton.titleLabel sizeToFit];// 主动根据文字内容计算按钮内部label的大小
    // 下划线宽度 == 按钮内部文字的宽度
    underLine.width = firstTitleButton.titleLabel.width + 10;
    underLine.centerX = firstTitleButton.centerX;
    
}

// 设置导航条
- (void)setupNavBar
{
    // UINavigationItem:决定导航条内容
    // UIBarButtonItem:决定导航条上按钮的内容
    
    // left
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];
    
    // right
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:nil action:nil];
    
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}

#pragma mark - 监听
- (void)game
{
    DZYLogFunc;
}

- (void)titleClick:(DZYTitleButton *)titleButton
{
    // 改变按钮状态
    self.clickTitleButton.selected = NO;
    titleButton.selected = YES;
    self.clickTitleButton = titleButton;
    
    // 移动下划线
    [UIView animateWithDuration:0.25 animations:^{
        
        // ios7 开始才是这个方法 之前是UITextAttri
//        self.underLine.width = [titleButton.currentTitle sizeWithAttributes:@{NSFontAttributeName:titleButton.titleLabel.font}].width;
        self.underLine.width = titleButton.titleLabel.width + 10;
        
        self.underLine.centerX = titleButton.centerX;
    }];
}

@end
