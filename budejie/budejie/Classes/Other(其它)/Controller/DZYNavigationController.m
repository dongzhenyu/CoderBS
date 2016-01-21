//
//  DZYNavigationController.m
//  budejie
//
//  Created by dzy on 16/1/4.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYNavigationController.h"

@interface DZYNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation DZYNavigationController

+ (void)load
{
    // 获取当前导航控制器下的导航条
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    // 设置导航条标题 -> 由导航条决定
    // 设置导航条标题
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    bar.titleTextAttributes = attrs;
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    
    // UIControlStateDisabled
    NSMutableDictionary *disableAttrs = [NSMutableDictionary dictionary];
    disableAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:disableAttrs forState:UIControlStateDisabled];
    
    // 统一设置导航条背景图片
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    // ios8 ios9 适配
    // 1.请求 ios9必须要使用https
    // 2.UIBarMetricsDefault ios8之前,导航控制器栈顶控制器的view高度就会减少64,ios9没有这个效果.
    
}

- (void)viewDidLoad
{
    /*
      <UIScreenEdgePanGestureRecognizer: 0x7f894a617e20; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7f894a616370>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7f894a618140>)>>
     */
    [super viewDidLoad];
    // 直接清空代理 程序会出现假死状态 (不正确)<边缘手势实现>
//    self.interactivePopGestureRecognizer.delegate = self;
    
    // 默认一个滑动手势,都是全屏,但是导航控制器边缘手势->查看一下导航控制器的滑动手势
    // 全屏滑动:添加一个pan手势,全屏滑动返回
    // 想实现全屏滑动 需要获取target (内部私有属性)
    
    
    // 先创建一个类 再经过类名 创建一个对象 (自己创建 不能实现全屏滑动)
//    Class targetClass = NSClassFromString(@"_UINavigationInteractiveTransition");
//    id target = [[targetClass alloc] init];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
    
    // 禁止边缘滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 非根控制器才需要设置
    if (self.childViewControllers.count) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 只要把系统的返回按钮覆盖 就不会再有滑动返回功能
        // 没有消失,只是失效了.代理做了事情.
//        DZYLog(@"%@", self.interactivePopGestureRecognizer);
        // 设置返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) title:@"返回"];
    }
    
    // 这里才是真正的跳转
    [super pushViewController:viewController animated:animated];
}


- (void)back
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - 手势代理方法
// 是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 非根控制器才触发
    return self.childViewControllers.count > 1;
}
@end
