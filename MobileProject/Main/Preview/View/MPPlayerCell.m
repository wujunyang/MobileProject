//
//  MPPlayerCell.m
//  MobileProject
//
//  Created by wujunyang on 2017/5/3.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPPlayerCell.h"
#import <AVFoundation/AVFoundation.h>

@implementation MPPlayerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        if (!_picView) {
            _picView=[[UIImageView alloc]init];
            _picView.userInteractionEnabled=YES;
            [self.contentView addSubview:_picView];
            
            [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
        }
        
        if (!_playBtn) {
            self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
            [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            [self.picView addSubview:self.playBtn];
            [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.picView);
                make.width.height.mas_equalTo(50);
            }];
        }
    }
    return self;
}


// 切圆角
- (void)cutRoundView:(UIImageView *)imageView {
    CGFloat corner = imageView.frame.size.width / 2;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)];
    shapeLayer.path = path.CGPath;
    imageView.layer.mask = shapeLayer;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(MPVideoModel *)model {
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.coverForFeed] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
}

- (void)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}

@end
