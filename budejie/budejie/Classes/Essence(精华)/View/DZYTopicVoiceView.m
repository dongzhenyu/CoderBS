//
//  DZYTopicVoiceView.m
//  budejie
//
//  Created by dzy on 16/1/17.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYTopicVoiceView.h"
#import "DZYTopicModel.h"
#import "DZYSeeBigPictureViewController.h"

@interface DZYTopicVoiceView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLabel;

@end

@implementation DZYTopicVoiceView

#pragma mark - 监听点击
- (void)seeBigPicture
{
    //    [UIApplication sharedApplication].keyWindow;
    
    DZYSeeBigPictureViewController *vc = [[DZYSeeBigPictureViewController alloc] init];
    vc.topicModel = self.topicModel;
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 初始化
- (void)awakeFromNib
{
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}

- (void)setTopicModel:(DZYTopicModel *)topicModel
{
    _topicModel = topicModel;
    
    // 图片
    [self.imageView dzy_setOriginImage:topicModel.image1 smallImage:topicModel.image0 placeholder:nil];
    
    // 播放数量
    if (topicModel.playcount >= 10000) {
        self.playCountLabel.text = [NSString stringWithFormat:@"%.1f万播放", topicModel.playcount / 10000.0];
    } else {
        self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放", topicModel.playcount];
    }
    
    // 时长
    NSInteger minute = topicModel.voicetime / 60;
    NSInteger second = topicModel.voicetime % 60;
    
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute, second];
    
}

@end
