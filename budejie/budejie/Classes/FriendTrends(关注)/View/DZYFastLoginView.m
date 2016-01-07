//
//  DZYFastLoginView.m
//  budejie
//
//  Created by dzy on 16/1/7.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYFastLoginView.h"

@implementation DZYFastLoginView

+ (instancetype)fastViewForXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}


@end
