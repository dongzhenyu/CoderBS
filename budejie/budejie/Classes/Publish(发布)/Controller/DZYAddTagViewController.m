//
//  DZYAddTagViewController.m
//  budejie
//
//  Created by dzy on 16/1/20.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYAddTagViewController.h"
#import "DZYTagButton.h"

@interface DZYAddTagViewController () <UITextFieldDelegate>

/** 存放所有的按钮和文本框 */
@property (nonatomic, weak) UIView *contentView;
/** 文本框 */
@property (nonatomic, weak) UITextField *textField;
/** 存放所有标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;
/** 提醒按钮 */
@property (nonatomic, weak) UIButton *tigButton;

@end

@implementation DZYAddTagViewController

#pragma mark - lazy
- (NSMutableArray *)tagButtons
{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (UIButton *)tigButton
{
    if (!_tigButton) {
        // 创建一个提醒按钮
        UIButton *tigButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tigButton addTarget:self action:@selector(tigClick) forControlEvents:UIControlEventTouchUpInside];
        tigButton.width = self.contentView.width;
        tigButton.height = DZYTagH;
        tigButton.x = 0;
        tigButton.backgroundColor = DZYColor(215, 215, 215);
        tigButton.titleLabel.font = DZYFont;
        // 文字靠左显示
        tigButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 让文字左边有个间距
        tigButton.contentEdgeInsets = UIEdgeInsetsMake(0, DZYSmallMargin, 0, 0);
        [self.contentView addSubview:tigButton];
        _tigButton = tigButton;
    }
    return _tigButton;
}
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    
    [self setupContentView];
    
    [self setupTextField];
}

- (void)setupNav
{
    self.title = @"推荐标签";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

- (void)setupContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.x = DZYSmallMargin;
    contentView.y = DZYNavY + DZYSmallMargin;
    contentView.width = DZYScreenW - 2 * contentView.x;
    contentView.height = self.view.height;
//    contentView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)setupTextField
{
    UITextField *textField = [[UITextField alloc] init];
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    textField.width = self.contentView.width;
    textField.height = DZYTagH;
//    textField.backgroundColor = [UIColor yellowColor];
    
    textField.placeholder = @"多个标签用逗号或者换行隔开";
    textField.placeholderColor = [UIColor grayColor];
    textField.tintColor = [UIColor blackColor];
    textField.delegate = self;
    [self.contentView addSubview:textField];
    
    [textField becomeFirstResponder];
    self.textField = textField;
    
}

#pragma mark - 监听
- (void)textDidChange
{
    // 提醒按钮
    if (self.textField.hasText) {
        self.tigButton.hidden = NO;
        self.tigButton.y = CGRectGetMaxY(self.textField.frame) + DZYSmallMargin;
        [self.tigButton setTitle:[NSString stringWithFormat:@"添加标签:%@", self.textField.text] forState:UIControlStateNormal];
    } else {
        self.tigButton.hidden = YES;
    }
}

- (void)tigClick
{
    DZYTagButton *newTagButton = [DZYTagButton buttonWithType:UIButtonTypeCustom];
    [newTagButton setTitle:self.textField.text forState:UIControlStateNormal];
    [self.contentView addSubview:newTagButton];
    
    // 设置位置
    // 最后一个标签按钮
    UIButton *lastTagButton = self.tagButtons.lastObject;
    if (lastTagButton) { // 不是第一个标签
        // 左边的宽度
        CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + DZYSmallMargin;
        // 右边剩下的宽度
        CGFloat rightWidth = self.contentView.width - leftWidth;
        if (rightWidth >= newTagButton.width) { // 跟最后一个按钮在同一行
            newTagButton.x = leftWidth;
            newTagButton.y = lastTagButton.y;
        } else { // 不在同一行
            newTagButton.x = 0;
            newTagButton.y = CGRectGetMaxY(lastTagButton.frame) + DZYSmallMargin;
        }
    } else { // 第一个标签
        newTagButton.x = 0;
        newTagButton.y = 0;
    }
    
    // 添加到数组中
    [self.tagButtons addObject:newTagButton];
    
    // 排布文本框
    self.textField.x = CGRectGetMaxX(newTagButton.frame) + DZYSmallMargin;
    self.textField.y = newTagButton.y;
    self.textField.text = nil;
    
    // 隐藏提醒按钮
    self.tigButton.hidden = YES;

}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done
{
    DZYLogFunc
}

@end
