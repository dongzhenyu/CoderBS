//
//  DZYEssenceViewController.m
//  budejie
//
//  Created by dzy on 16/1/1.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYEssenceViewController.h"
#import "DZYTitleButton.h"

#import "DZYAllViewController.h"
#import "DZYVideoViewController.h"
#import "DZYVoiceViewController.h"
#import "DZYPictureViewController.h"
#import "DZYWordViewController.h"

@interface DZYEssenceViewController () <UIScrollViewDelegate>

/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;

/** 记录按钮点击 */
@property (nonatomic, weak) DZYTitleButton *clickTitleButton;

/** 下划线 */
@property (nonatomic, weak) UIView *underLine;

/** 用来存放所有子控制器的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

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
    // 初始化子控制器
    [self setupAllChildVcs];
}

#pragma mark - 初始化
- (void)setupAllChildVcs
{
    [self addChildViewController:[[DZYAllViewController alloc] init]];
    [self addChildViewController:[[DZYVideoViewController alloc] init]];
    [self addChildViewController:[[DZYVoiceViewController alloc] init]];
    [self addChildViewController:[[DZYPictureViewController alloc] init]];
    [self addChildViewController:[[DZYWordViewController alloc] init]];
    
    // 内容大小
    self.scrollView.contentSize = CGSizeMake(self.childViewControllers.count * self.scrollView.width, 0);
    // 不要自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 默认添加第0个控制器的view到scrollView
    [self addChildVcViewInToScrollView:0];
    
}

- (void)addChildVcViewInToScrollView:(NSInteger)index
{
    // 添加对应的子控制器view到scrollView上
    UIViewController *childVc = self.childViewControllers[index];
    // 如果这个子控制器view已经显示在上面, 就直接返回
    if (childVc.view.superview) return;
    
    [self.scrollView addSubview:childVc.view];
    
    // 子控制器view的frame
    childVc.view.x = index * self.scrollView.width;
    childVc.view.y = 0;
    childVc.view.width = self.scrollView.width;
    childVc.view.height = self.scrollView.height;

}


- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.backgroundColor = DZYRandomColor;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
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
        titleButton.tag = i;
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
    underLine.width = firstTitleButton.titleLabel.width + DZYMargin;
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
    self.clickTitleButton.selected = NO;// UIControlStateNormal
    titleButton.selected = YES;// UIControlStateSelected
    self.clickTitleButton = titleButton;
    
    // 按钮索引
    NSInteger index = titleButton.tag;
    
    // 移动下划线
    [UIView animateWithDuration:0.25 animations:^{
        // ios7 开始才是这个方法 之前是UITextAttri
        //        self.underLine.width = [titleButton.currentTitle sizeWithAttributes:@{NSFontAttributeName:titleButton.titleLabel.font}].width;
        // 宽度 == 按钮内部文字的高度
        self.underLine.width = titleButton.titleLabel.width + DZYMargin;
        // 中心点x
        self.underLine.centerX = titleButton.centerX;
        // 滚动scrollView到最新的子控制器界面(这里只需要水平滚动, 只改contentOffset.x)
        CGPoint offset = self.scrollView.contentOffset;
        offset.x = index * self.scrollView.width;
        self.scrollView.contentOffset = offset;
        
    } completion:^(BOOL finished) {// 滚动动画完毕
        // 添加对应的子控制器view到scrollView
        [self addChildVcViewInToScrollView:index];
    }];
}

#pragma mark - scrollViewDelegate
/**
 * scrollView停止滚动的时候调用(结束减速,速度为0)
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    // 点击对应的按钮
    DZYTitleButton *titleButton = self.titlesView.subviews[index];
    
    [self titleClick:titleButton];
    
}

@end
