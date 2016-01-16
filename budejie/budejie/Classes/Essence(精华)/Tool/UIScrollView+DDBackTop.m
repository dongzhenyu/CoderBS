//
//  UIScrollView+DDBackTop.m
//  HouseApp
//
//  Created by dzy on 16/1/11.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "UIScrollView+DDBackTop.h"
#import <objc/runtime.h>
#import "DDBackTopButton.h"

@implementation UIScrollView (DDBackTop)

- (void)addBackTop
{
    
    DDBackTopButton *button = [[DDBackTopButton alloc] init];
    
    [self addSubview:button];
    
}


@end
