//
//  DZYLoginRegisterViewController.m
//  budejie
//
//  Created by dzy on 16/1/5.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYLoginRegisterViewController.h"
#import "DZYLoginRegisterView.h"
#import "DZYFastLoginView.h"


@interface DZYLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midViewL;

@end

@implementation DZYLoginRegisterViewController

// 点击关闭就会调用
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 点击注册就会调用
- (IBAction)clickRegister:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    // 移动中间view
    _midViewL.constant = _midViewL.constant ? 0 : - DZYScreenW;
    
    [UIView animateWithDuration:0.25 animations:^{
       // 让父控件重新布局
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 创建子控件
    // 添加登录输入框,默认一个view从xib加载,view的尺寸根xib一样
    DZYLoginRegisterView *loginView = [DZYLoginRegisterView loginViewForXib];
    [self.midView addSubview:loginView];
    
    // 添加注册输入框
    DZYLoginRegisterView *registerView = [DZYLoginRegisterView registerViewForXib];
    [self.midView addSubview:registerView];
    
    // 快速登陆
    DZYFastLoginView *fastView = [DZYFastLoginView fastViewForXib];
    [self.bottomView addSubview:fastView];
    
}

// 给控制器的子控件位置赋值
- (void)viewDidLayoutSubviews
{
    // 这里真正执行xib描述约束
    [super viewDidLayoutSubviews];
    
    // 登陆
    UIView *loginV = self.midView.subviews[0];
    // 使用Xib,xib中关心好子控件约束,自己控件尺寸有外界决定.
    // 必须要设置frame
    loginV.frame = CGRectMake(0, 0, self.midView.width * 0.5, self.midView.height);
    
    // 注册
    UIView *registerV = self.midView.subviews[1];
    registerV.frame = CGRectMake(self.midView.width * 0.5, 0, self.midView.width * 0.5, self.midView.height);
    
    // 快速登陆
    UIView *fastV = self.bottomView.subviews[0];
    fastV.frame = CGRectMake(0, 0, self.bottomView.width, self.bottomView.height);
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
