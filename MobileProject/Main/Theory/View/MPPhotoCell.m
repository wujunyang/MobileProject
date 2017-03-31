//
//  MPPhotoCell.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/31.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPPhotoCell.h"

@interface MPPhotoCell()

@property(nonatomic,strong,readwrite)UILabel *myNameLabel;

@end


@implementation MPPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self LayoutLayoutCell];
    }
    return self;
}

-(void)LayoutLayoutCell
{
    [self.contentView addSubview:self.myNameLabel];
    [self.myNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(AdaptedWidth(15));
        make.centerY.mas_equalTo(0);
    }];
}

-(UILabel *)myNameLabel
{
    if (!_myNameLabel) {
        _myNameLabel=[UILabel new];
        _myNameLabel.font=AdaptedFontSize(15);
        _myNameLabel.textColor=[UIColor redColor];
    }
    return _myNameLabel;
}

@end
