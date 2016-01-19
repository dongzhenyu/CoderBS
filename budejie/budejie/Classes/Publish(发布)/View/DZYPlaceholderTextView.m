//
//  DZYPlaceholderTextView.m
//  budejie
//
//  Created by dzy on 16/1/19.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYPlaceholderTextView.h"

@interface DZYPlaceholderTextView ()

/** 占位文字 */
@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation DZYPlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
        
        self.font = [UIFont systemFontOfSize:15];
        self.placeholderColor = [UIColor grayColor];
        
        // 使用通知监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)textDidChange:(NSNotification *)note
{
    self.placeholderLabel.hidden = self.hasText;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placeholderLabel.x = 5;
    self.placeholderLabel.y = 8;
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    [self.placeholderLabel sizeToFit];
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self.placeholderLabel sizeToFit];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    self.placeholderLabel.hidden = self.hasText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    self.placeholderLabel.hidden = self.hasText;
}

@end
