//
//  DZYPostWordViewController.m
//  budejie
//
//  Created by dzy on 16/1/19.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYPostWordViewController.h"
#import "DZYPlaceholderTextView.h"

@interface DZYPostWordViewController () <UITextViewDelegate>

@end

@implementation DZYPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    
    self.title = self.wordBtn.titleLabel.text;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    [self setupTextView];
}

- (void)setupTextView
{
    DZYPlaceholderTextView *textView = [[DZYPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理";
    [self.view addSubview:textView];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
@end
