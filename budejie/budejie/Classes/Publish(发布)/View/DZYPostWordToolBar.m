//
//  DZYPostWordToolBar.m
//  budejie
//
//  Created by dzy on 16/1/19.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYPostWordToolBar.h"
#import "DZYAddTagViewController.h"
#import "DZYNavigationController.h"


#define DZYTagBgColor DZYColor(70, 142, 243);

@interface DZYPostWordToolBar ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

/** 所有标签的label */
@property (nonatomic, strong) NSMutableArray *tagLabels;
/** 加号按钮 */
@property (nonatomic, weak) UIButton *addButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@end

@implementation DZYPostWordToolBar

- (NSMutableArray *)tagLabels
{
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (void)awakeFromNib
{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:addButton];
    self.addButton = addButton;
    
    // 默认传递两个标签
    [self creatTagLabels:@[@"吐槽", @"糗事"]];
}

- (void)addClick
{
    __weak typeof(self) weakSelf = self;
    
    DZYAddTagViewController *addVc = [[DZYAddTagViewController alloc] init];
    addVc.getTagsBlock = ^(NSArray *tags) {
//        DZYLog(@"%@", tags);
        // 创建标签按钮
        [weakSelf creatTagLabels:tags];
    };
    addVc.tags = [self.tagLabels valueForKeyPath:@"text"];
    
    DZYNavigationController *nav = [[DZYNavigationController alloc] initWithRootViewController:addVc];
    // 拿到窗口根控制器曾经modal出来的发表文字所在的导航控制器
    UIViewController *vc = self.window.rootViewController.presentedViewController;
    [vc presentViewController:nav animated:YES completion:nil];

}

/**
 *  创建标签label
 */
- (void)creatTagLabels:(NSArray *)tags
{
    // 让self.tagLabels数组中的所有对象执行
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    
    for (int i = 0; i<tags.count; i++) {
        UILabel *newTagLabel = [[UILabel alloc] init];
        newTagLabel.text = tags[i];
        newTagLabel.font = DZYFont;
        newTagLabel.backgroundColor = DZYTagBgColor;
        newTagLabel.textColor = [UIColor whiteColor];
        newTagLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:newTagLabel];
        [self.tagLabels addObject:newTagLabel];
        
        // 尺寸
        [newTagLabel sizeToFit];
        newTagLabel.height = DZYTagH;
        newTagLabel.width += 2 * DZYSmallMargin;
        
        // 重新布局子控件
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 所有的标签label
    for (int i = 0; i<self.tagLabels.count; i++) {
        // 创建label
        UILabel *newTagLabel = self.tagLabels[i];
        
        // 位置
        if (i == 0) {
            newTagLabel.x = 0;
            newTagLabel.y = 0;
        } else {
            // 上一个标签
            UILabel *previousTagLabel = self.tagLabels[i - 1];
            CGFloat leftWidth = CGRectGetMaxX(previousTagLabel.frame) + DZYSmallMargin;
            CGFloat rightWidth = self.topView.width - leftWidth;
            if (rightWidth >= newTagLabel.width) {
                newTagLabel.x = leftWidth;
                newTagLabel.y = previousTagLabel.y;
            } else {
                newTagLabel.x = 0;
                newTagLabel.y = CGRectGetMaxY(previousTagLabel.frame) + DZYSmallMargin;
            }
        }
    }
    
    // 加号按钮
    UILabel *lastTagLabel = self.tagLabels.lastObject;
    if (lastTagLabel) {
        CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + DZYSmallMargin;
        CGFloat rightWidth = self.topView.width - leftWidth;
        if (rightWidth >= self.addButton.width) {
            self.addButton.x = leftWidth;
            self.addButton.y = lastTagLabel.y;
        } else {
            self.addButton.x = 0;
            self.addButton.y = CGRectGetMaxY(lastTagLabel.frame) + DZYSmallMargin;
        }
    } else {
        self.addButton.x = 0;
        self.addButton.y = 0;
    }
    
    // 计算工具条的高度
    self.topViewHeight.constant = CGRectGetMaxY(self.addButton.frame);
    CGFloat oldHeight = self.height;
    self.height = self.topViewHeight.constant + self.bottomView.height + DZYSmallMargin;
    self.y += oldHeight - self.height;
}

@end
