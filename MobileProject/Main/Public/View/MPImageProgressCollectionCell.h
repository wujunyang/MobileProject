//
//  MPImageProgressCollectionCell.h
//  MobileProject 带进度效果
//
//  Created by wujunyang on 16/7/22.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13ProgressViewPie.h"
#import "MPImageItemModel.h"
#import "MPUploadImageItemService.h"

@interface MPImageProgressCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView          *imgView;
@property (strong, nonatomic) UIButton             *deleteBtn;
@property (strong, nonatomic) MPImageItemModel     *curImageItem;
@property (copy, nonatomic) void (^deleteImageBlock) (MPImageItemModel *toDelete);

//单元格大小
+(CGSize)ccellSize;

@end
