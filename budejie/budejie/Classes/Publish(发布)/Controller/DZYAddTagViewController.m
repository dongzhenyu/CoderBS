//
//  DZYAddTagViewController.m
//  budejie
//
//  Created by dzy on 16/1/20.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYAddTagViewController.h"
#import "DZYTagButton.h"
#import "DZYTextField.h"
#import "MBProgressHUD+MJ.h"

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
    
    [self setupTags];
}

- (void)setupTags
{
    self.textField.text = @"哈哈";
    [self tigClick];
    
    self.textField.text = @"嘿嘿";
    [self tigClick];
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
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)setupTextField
{
    DZYTextField *textField = [[DZYTextField alloc] init];
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
    // 强制更新
    [textField layoutIfNeeded];
    self.textField = textField;
    
    __weak typeof(self) weakSelf = self;
    // 设置点击删除键需要执行的操作
    textField.deleteBackwardOperation = ^{
        // 判断文本框是否有文字
        if (weakSelf.textField.hasText) return ;
        // 点击了最后一个按钮（删掉最后一个标签按钮）
        [weakSelf tagClick:weakSelf.tagButtons.lastObject];
    };
    
}

#pragma mark - 监听
- (void)textDidChange
{
    // 提醒按钮
    if (self.textField.hasText) {
        NSString *text = self.textField.text;
        NSString *lastChar = [text substringFromIndex:text.length - 1];
        if ([lastChar isEqualToString:@","] || [lastChar isEqualToString:@"，"]) { // 最后输入的是一个逗号
            // 去掉文本框最后一个逗号
//            self.textField.text = [text substringToIndex:text.length - 1];
            [self.textField deleteBackward];
            [self tigClick];
        } else { // 最后输入的字符不是逗号
            // 排布文本框
            [self setupTextFieldFrame];

            self.tigButton.hidden = NO;
            self.tigButton.y = CGRectGetMaxY(self.textField.frame) + DZYSmallMargin;
            [self.tigButton setTitle:[NSString stringWithFormat:@"添加标签:%@", self.textField.text] forState:UIControlStateNormal];
        }
    } else {
        self.tigButton.hidden = YES;
    }
}

- (void)tigClick
{
    if (self.textField.hasText == NO) return;
    
    if (self.tagButtons.count == 5) {
        [MBProgressHUD showError:@"最多只能添加5个按钮,亲"];
        return;
    }
    
    DZYTagButton *newTagButton = [DZYTagButton buttonWithType:UIButtonTypeCustom];
    [newTagButton addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    [newTagButton setTitle:self.textField.text forState:UIControlStateNormal];
    [self.contentView addSubview:newTagButton];

    // 设置位置 参照最后一个标签按钮
    [self setupTagButtonFrame:newTagButton referenceTagButton:self.tagButtons.lastObject];
    // 添加到数组中
    [self.tagButtons addObject:newTagButton];
    
    // 排布文本框
    self.textField.text = nil;
    [self setupTextFieldFrame];
    
    // 隐藏提醒按钮
    self.tigButton.hidden = YES;

}

/**
 *  点击了标签按钮
 */
- (void)tagClick:(DZYTagButton *)clickTagButton
{
    // 即将被删除的按钮的索引
    NSInteger index = [self.tagButtons indexOfObject:clickTagButton];
    
    // 删除按钮
    [clickTagButton removeFromSuperview];
    [self.tagButtons removeObject:clickTagButton];
    
    // 处理后面的按钮
    for (NSInteger i = index; i<self.tagButtons.count; i++) {
        DZYTagButton *tagButton = self.tagButtons[i];
        // 如果i不为0,就参照上一个按钮
        DZYTagButton *previousButton = (i == 0) ? nil : self.tagButtons[i - 1];
        [self setupTagButtonFrame:tagButton referenceTagButton:previousButton];
    }
    
    // 排布文本框
    [self setupTextFieldFrame];
}

#pragma mark - 设置控件的frame
/**
 *  设置标签按钮的frame
 *
 *  @param tagButton          需要设置frame的标签按钮
 *  @param referenceTagButton 计算tagButton的frame时参照的标签按钮
 */
- (void)setupTagButtonFrame:(DZYTagButton *)tagButton referenceTagButton:(DZYTagButton *)referenceTagButton
{
    // 没有参照按钮
    if (referenceTagButton == nil) {
        tagButton.x = 0;
        tagButton.y = 0;
        return;
    }
    // tagButton不是第一个标签按钮
    // 左边的宽度
    CGFloat leftWidth = CGRectGetMaxX(referenceTagButton.frame) + DZYSmallMargin;
    // 右边剩下的宽度
    CGFloat rightWidth = self.contentView.width - leftWidth;
    if (rightWidth >= tagButton.width) { // 跟最后一个按钮在同一行
        tagButton.x = leftWidth;
        tagButton.y = referenceTagButton.y;
    } else { // 不在同一行
        tagButton.x = 0;
        tagButton.y = CGRectGetMaxY(referenceTagButton.frame) + DZYSmallMargin;
    }
}

- (void)setupTextFieldFrame
{
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName: self.textField.font}].width;
    textW = MAX(100, textW);
    
    DZYTagButton *lastTagButton = self.tagButtons.lastObject;
    CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + DZYSmallMargin;
    CGFloat rightWidth = self.contentView.width - leftWidth;
    if (rightWidth >= textW) { // 跟新添加的标签按钮在同一行
        self.textField.x = leftWidth;
        self.textField.y = lastTagButton.y;
    } else { // 换行
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastTagButton.frame) + DZYSmallMargin;
    }
    // 排布提醒按钮
    self.tigButton.y = CGRectGetMaxY(self.textField.frame) + DZYSmallMargin;

}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done
{
    DZYLogFunc
}

#pragma mark - 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self tigClick];
    return YES;
}

@end
