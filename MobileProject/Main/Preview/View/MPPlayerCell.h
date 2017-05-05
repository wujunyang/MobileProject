//
//  MPPlayerCell.h
//  MobileProject
//
//  Created by wujunyang on 2017/5/3.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayer.h"
#import "MPVideoModel.h"

@interface MPPlayerCell : UITableViewCell

@property (strong, nonatomic  )UIImageView          *avatarImageView;
@property (strong, nonatomic  )UIImageView          *picView;
@property (nonatomic, strong) UIButton              *playBtn;
/** model */
@property (nonatomic, strong) MPVideoModel          *model;
/** 播放按钮block */
@property (nonatomic, copy) void(^playBlock)(UIButton *);

@end
