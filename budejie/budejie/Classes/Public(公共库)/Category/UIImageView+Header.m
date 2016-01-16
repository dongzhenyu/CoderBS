//
//  UIImageView+Header.m
//  budejie
//
//  Created by dzy on 16/1/12.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "UIImageView+Header.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (Header)

- (void)dzy_setHeader:(NSString *)url
{
    UIImage *placeholder = [UIImage dzy_circleImageNamed:@"defaultUserIcon"];
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        if (image == nil) return;
        self.image = [image dzy_circleImage];
    }];
}

@end
