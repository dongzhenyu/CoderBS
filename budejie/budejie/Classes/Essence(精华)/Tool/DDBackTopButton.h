//
//  DDBackTopButton.h
//  HouseApp
//
//  Created by dzy on 16/1/11.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#define _backTopShowWithOffsetY [UIScreen mainScreen].bounds.size.height * 2
#define _backTopViewSize CGSizeMake(35,35);
#define _backTopViewCenter CGPointMake([UIScreen mainScreen].bounds.size.width - 35, [UIScreen mainScreen].bounds.size.height - 64 - 35)
#define _backTopViewNormalImageName @"fx_top_normal"
#define _backTopViewHighlightedImageName @"fx_top_pressed"
@interface DDBackTopButton : UIButton
@property (nonatomic, weak) UIScrollView *scrollView;
@end
