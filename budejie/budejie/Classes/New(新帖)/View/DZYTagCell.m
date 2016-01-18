//
//  DZYTagCell.m
//  budejie
//
//  Created by dzy on 16/1/5.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYTagCell.h"
#import "DZYTagModel.h"
#import <UIImageView+WebCache.h>

@interface DZYTagCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iocnImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@end

@implementation DZYTagCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    [super setFrame:frame];
}

- (void)setTagModel:(DZYTagModel *)tagModel
{
    _tagModel = tagModel;
    
    self.nameLabel.text = tagModel.theme_name;
//    [self.iocnImageView sd_setImageWithURL:[NSURL URLWithString:tagModel.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    [self.iocnImageView dzy_setHeader:tagModel.image_list];
    
    NSString *str = [NSString stringWithFormat:@"%ld人订阅", tagModel.sub_number];
    if (tagModel.sub_number > 10000) {
        CGFloat num = tagModel.sub_number / 10000.0;
        str = [NSString stringWithFormat:@"%.1f万人订阅", num];
    }
    
    self.numLabel.text = str;
}

@end
