//
//  DZYTopicModel.m
//  budejie
//
//  Created by dzy on 16/1/9.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYTopicModel.h"

@implementation DZYTopicModel

- (CGFloat)cellHeight
{
    if (_cellHeight) return _cellHeight;
    
    // 根据模型数据计算出cell的高度
    // 头像
    _cellHeight += 55;
    
    // 文字
    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * DZYMargin;
    _cellHeight += [self.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + DZYMargin;
    
    // 中间(图片\声音\视频)
    if (self.type != DZYTopicTypeWord) {
        // width:480.000000, height:272.000000
        // 显示宽度:355, 显示高度:x
        
        /*
         480   272
         --- = ---      x = 355*272/480
         355    x
         */
        
        // textMaxW 文字的最大宽度
        CGFloat centerW = textMaxW;
        CGFloat centerH = centerW * self.height / self.width;
        CGFloat centerY = _cellHeight;
        CGFloat centerX = DZYMargin;
        
        if (centerH >= DZYScreenH) { // 中间内容超过一个屏幕
            centerH = 200;
            self.bigPicture = YES;
        }
        self.centerF = CGRectMake(centerX, centerY, centerW, centerH);
        _cellHeight += centerH + DZYMargin;
    }
    
    // 最热评论
    if (self.top_cmt.count) {
        // 标题
        _cellHeight += 20;
        
        // 内容
        NSDictionary *dict = self.top_cmt.firstObject;
        NSString *username = dict[@"user"][@"username"];
        NSString *content = dict[@"content"];
        NSString *cmt = [NSString stringWithFormat:@"%@ : %@", username, content];
        _cellHeight += [cmt boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height + DZYMargin;
    }
    
    // 工具条
    _cellHeight += 35 + DZYMargin;
    return _cellHeight;
}

@end
