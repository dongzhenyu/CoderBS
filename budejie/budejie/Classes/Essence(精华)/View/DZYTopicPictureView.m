//
//  DZYTopicPictureView.m
//  budejie
//
//  Created by dzy on 16/1/17.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYTopicPictureView.h"
#import "DZYTopicModel.h"
#import "DZYSeeBigPictureViewController.h"
#import <DALabeledCircularProgressView.h>
#import <UIImageView+WebCache.h>

@interface DZYTopicPictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;


@end

@implementation DZYTopicPictureView

#pragma mark - 监听点击
- (void)seeBigPicture
{
    DZYSeeBigPictureViewController *seeBigVc = [[DZYSeeBigPictureViewController alloc] init];
    seeBigVc.topicModel = self.topicModel;
    [self.window.rootViewController presentViewController:seeBigVc animated:YES completion:nil];
    
}
- (IBAction)seeBigP {
    DZYSeeBigPictureViewController *seeBigVc = [[DZYSeeBigPictureViewController alloc] init];
    seeBigVc.topicModel = self.topicModel;
    [self.window.rootViewController presentViewController:seeBigVc animated:YES completion:nil];
}

- (void)awakeFromNib
{
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
    self.progressView.roundedCorners = 5;
    self.progressView.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setTopicModel:(DZYTopicModel *)topicModel
{
    _topicModel = topicModel;
//    [self.imageView dzy_setOriginImage:topicModel.image1 smallImage:topicModel.image0 placeholder:nil];
    
    __weak typeof(self) weakSelf = self;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:topicModel.image1] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) { // 每下载一点图片数据就会调用
        // 每下载一点图片就会调用
        weakSelf.progressView.hidden = NO;
        weakSelf.progressView.progress = 1.0 * receivedSize / expectedSize;
        weakSelf.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", weakSelf.progressView.progress * 100];

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) { // 图片下载完成的时候调用
        weakSelf.progressView.hidden = YES;
    }];
    
    self.gifView.hidden = !topicModel.is_gif;
    
    // 点击查看大图按钮
    if (topicModel.isBigPicture) {
        self.imageView.contentMode = UIViewContentModeTop;
        self.clipsToBounds = YES; // 超出imageView边框的内容会被剪掉
        self.seeBigButton.hidden = NO;
    } else {
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.seeBigButton.hidden = YES;
        self.clipsToBounds = NO;
    }
    
}

@end
