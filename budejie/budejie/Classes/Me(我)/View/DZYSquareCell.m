//
//  DZYSquareCell.m
//  budejie
//
//  Created by dzy on 16/1/7.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYSquareCell.h"
#import <UIImageView+WebCache.h>
#import "DZYSquareModel.h"

@interface DZYSquareCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation DZYSquareCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSquareModel:(DZYSquareModel *)squareModel
{
    _squareModel = squareModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:squareModel.icon]];
    self.nameLabel.text = squareModel.name;
    
}

@end
