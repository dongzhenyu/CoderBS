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

@interface DZYTopicPictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;

@end

@implementation DZYTopicPictureView

#pragma mark - 监听点击
- (void)seeBigPicture
{
    DZYSeeBigPictureViewController *seeBigVc = [[DZYSeeBigPictureViewController alloc] init];
    seeBigVc.topicModel = self.topicModel;
    [self.window.rootViewController presentViewController:seeBigVc animated:YES completion:nil];
    
}

- (void)awakeFromNib
{
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
    
}

- (void)setTopicModel:(DZYTopicModel *)topicModel
{
    _topicModel = topicModel;
    [self.imageView dzy_setOriginImage:topicModel.image1 smallImage:topicModel.image0 placeholder:nil];
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
