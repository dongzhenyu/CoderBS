//
//  DZYPostWordViewController.m
//  budejie
//
//  Created by dzy on 16/1/19.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYPostWordViewController.h"
#import "DZYPlaceholderTextView.h"
#import "DZYPostWordToolBar.h"

@interface DZYPostWordViewController () <UITextViewDelegate>

/** 底部工具条 */
@property (nonatomic, weak) DZYPostWordToolBar *toolBar;

@property (nonatomic, weak) DZYPlaceholderTextView *textView;

@end

@implementation DZYPostWordViewController

// 处理键盘
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    
    self.title = self.wordBtn.titleLabel.text;
    
    [self setupNav];
    
    [self setupTextView];
    
    [self setupToolBar];
}

- (void)setupNav
{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // 如果textview中没有文字 发表按钮不能点击 直接拿不到按钮 只能通过父控件来强制刷新
    [self.navigationController.navigationBar layoutIfNeeded];
}

- (void)setupTextView
{
    DZYPlaceholderTextView *textView = [[DZYPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理";
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)setupToolBar
{
    DZYPostWordToolBar *toolBar = [DZYPostWordToolBar viewFromXib];
    toolBar.x = 0;
    toolBar.y = self.view.height - toolBar.height;
    toolBar.width = self.view.width;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  监听
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        // 工具条平移的距离 = 键盘最终的Y值 -  屏幕的高度
        CGFloat ty = [note.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y - DZYScreenH;
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
}
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post
{
    DZYLogFunc
}

#pragma mark - 代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}
@end
