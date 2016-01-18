//
//  DZYTopicCell.m
//  budejie
//
//  Created by dzy on 16/1/12.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYTopicCell.h"
#import "DZYTopicModel.h"
#import "DZYTopicPictureView.h"
#import "DZYTopicVoiceView.h"
#import "DZYTopicVideoView.h"

@interface DZYTopicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 最热评论整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
/** 最热评论内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;

// 中间控件
/** 图片控件 */
@property (nonatomic, weak) DZYTopicPictureView *pictureView;
/** 声音控件 */
@property (nonatomic, weak) DZYTopicVoiceView *voiceView;
/** 视频控件 */
@property (nonatomic, weak) DZYTopicVideoView *videoView;

@end

@implementation DZYTopicCell

#pragma mark - lazy
- (DZYTopicPictureView *)pictureView
{
    if (!_pictureView) {
        DZYTopicPictureView *pictureView = [DZYTopicPictureView viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}
- (DZYTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        DZYTopicVoiceView *voiceView = [DZYTopicVoiceView viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}
- (DZYTopicVideoView *)videoView
{
    if (!_videoView) {
        DZYTopicVideoView *videoView = [DZYTopicVideoView viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}


#pragma mark - 初始化
- (void)awakeFromNib
{
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.topicModel.type == DZYTopicTypePicture) {
        self.pictureView.frame = self.topicModel.centerF;
    } else if (self.topicModel.type == DZYTopicTypeVoice) {
        self.voiceView.frame = self.topicModel.centerF;
    } else if (self.topicModel.type == DZYTopicTypeVideo) {
        self.videoView.frame = self.topicModel.centerF;
    }
}

- (void)setTopicModel:(DZYTopicModel *)topicModel
{
    _topicModel = topicModel;
    
    [self.profileImageView dzy_setHeader:topicModel.profile_image];
    
    self.nameLabel.text = topicModel.name;
    self.text_label.text = topicModel.text;
    
    // 日期处理
    [self setupCreatedAt];
    
    // 工具条按钮文字
    [self setupButtonTitle:self.dingButton number:topicModel.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton number:topicModel.cai placeholder:@"踩"];
    [self setupButtonTitle:self.repostButton number:topicModel.repost placeholder:@"分享"];
    [self setupButtonTitle:self.dingButton number:topicModel.comment placeholder:@"评论"];

    // 最热评论
    if (topicModel.top_cmt.count) { // 有
        self.topCmtView.hidden = NO;
        NSDictionary *dict = topicModel.top_cmt.firstObject;
        NSString *username = dict[@"user"][@"username"];
        NSString *content = dict[@"content"];
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@", username, content];
    } else { // 没有
        self.topCmtView.hidden = YES;
    }
    
    // 根据模型类型设置中间内容
    if (topicModel.type == DZYTopicTypePicture) {
        self.pictureView.hidden = NO;
        self.pictureView.topicModel = topicModel;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    } else if (topicModel.type == DZYTopicTypeVoice) {
        self.voiceView.hidden = NO;
        self.voiceView.topicModel = topicModel;
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
    } else if (topicModel.type == DZYTopicTypeVideo) {
        self.videoView.hidden = NO;
        self.videoView.topicModel = topicModel;
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
    } else if (topicModel.type == DZYTopicTypeWord) {
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
}

/**
 *  日期处理
 */
- (void)setupCreatedAt
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createdAtDate = [fmt dateFromString:self.topicModel.created_at];
    if (createdAtDate.dzy_isInThisYear) { // 今年
        if (createdAtDate.dzy_isInYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            self.createdAtLabel.text = [fmt stringFromDate:createdAtDate];
        } else if (createdAtDate.dzy_isInToday) { // 今天
            NSDateComponents *cmps = [[NSCalendar dzy_calendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:createdAtDate toDate:[NSDate date] options:0];
            if (cmps.hour >= 1) { // 时间间隔 >= 1小时
                self.createdAtLabel.text = [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间间隔 >= 1分钟
                self.createdAtLabel.text = [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间间隔
                self.createdAtLabel.text = @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            self.createdAtLabel.text = [fmt stringFromDate:createdAtDate];
        }
    } else { // 非今年
        self.createdAtLabel.text = self.topicModel.created_at;
    }
}

- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder
{
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= DZYMargin;
    
    [super setFrame:frame];
}

@end
