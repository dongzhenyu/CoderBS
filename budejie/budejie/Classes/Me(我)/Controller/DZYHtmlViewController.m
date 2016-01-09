//
//  DZYHtmlViewController.m
//  budejie
//
//  Created by dzy on 16/1/8.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYHtmlViewController.h"
#import <WebKit/WebKit.h>

@interface DZYHtmlViewController ()
@property (weak, nonatomic) IBOutlet UIView *ContentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardItem;
/** <#type#> */
@property (nonatomic, weak) WKWebView *webView;
/** <#type#> */
@property (nonatomic, weak) UIProgressView *progressView;

@end

@implementation DZYHtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加WKWebView
    WKWebView *webView = [[WKWebView alloc] init];
    [self.ContentView addSubview:webView];
    self.webView = webView;
    
    // 加载网页
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [webView loadRequest:request];
    
    // 添加进度条
    [self setupProgressView];
    
    // KVO监听属性
    // 监听canGoBack
    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    // 监听canGoForward
    [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    // 监听estimatedProgress
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    // 监听URL
    [webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
    // 监听title
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
}

// 监听对象属性改变就会调用,监听webView的canGoBack
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    self.backItem.enabled = self.webView.canGoBack;
    self.forwardItem.enabled = self.webView.canGoForward;
    self.progressView.progress = self.webView.estimatedProgress;
    self.progressView.hidden = !(self.progressView.progress < 1);
    self.title = self.webView.title;
}

// KVO一定要记得移除观察者
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"URL"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

- (void)setupProgressView
{
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, DZYNavY, DZYScreenW, 2)];
    progressView.progressTintColor = [UIColor blueColor];
    self.progressView = progressView;
    [self.view addSubview:progressView];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

#pragma mark - 点击事件
// 倒退
- (IBAction)back:(id)sender {
    [self.webView goBack];
}
// 前进
- (IBAction)forward:(id)sender {
    [self.webView goForward];
}
// 刷新
- (IBAction)refresh:(id)sender {
    [self.webView reload];
}



@end
