//
//  DZYTopicVideoView.m
//  budejie
//
//  Created by dzy on 16/1/17.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYTopicVideoView.h"
#import "DZYTopicModel.h"
#import "DZYSeeBigPictureViewController.h"

@interface DZYTopicVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;

@end

@implementation DZYTopicVideoView

#pragma mark - 监听点击
- (void)seeBigPicture
{
    DZYSeeBigPictureViewController *seeBigVc = [[DZYSeeBigPictureViewController alloc] init];
    seeBigVc.topicModel = self.topicModel;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:seeBigVc animated:YES completion:nil];
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
    
    [self.imageView dzy_setOriginImage:topicModel.image1 smallImage:topicModel.image0 placeholder:nil];
    if (topicModel.playcount >= 10000) {
        self.playCountLabel.text = [NSString stringWithFormat:@"%.1f万播放", topicModel.playcount / 10000.0];
    } else {
        self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放", topicModel.playcount];
    }
    
    NSInteger minute = topicModel.videotime / 60;
    NSInteger second = topicModel.videotime % 60;
    // %04zd : 这个整数占据4位, 多余的位用0填补
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}

@end
