//
//  DZYTopicModel.h
//  budejie
//
//  Created by dzy on 16/1/9.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DZYTopicType) {
    /** 全部 */
    DZYTopicTypeAll = 1,
    /** 图片 */
    DZYTopicTypePicture = 10,
    /** 段子 */
    DZYTopicTypeWord = 29,
    /** 声音 */
    DZYTopicTypeVoice = 31,
    /** 视频 */
    DZYTopicTypeVideo = 41,
    
};


@interface DZYTopicModel : NSObject
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *created_at;
/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;
/** 帖子类型 */
@property (nonatomic, assign) NSInteger type;
/** 最热评论 */
@property (nonatomic, strong) NSArray *top_cmt;

/** 图片的高度 */
@property (nonatomic, assign) CGFloat height;
/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;

/***** 额外增加的属性(方便开发) *****/
/** cell的高度 */
//@property (nonatomic, assign) CGFloat cellHeight;
@end
