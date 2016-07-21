//
//  MPImageCollectionCell.h
//  MobileProject 图片单元格
//
//  Created by wujunyang on 16/7/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPImageItemModel.h"

@interface MPImageCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView          *imgView;
@property (strong, nonatomic) UIButton             *deleteBtn;
@property (strong, nonatomic) MPImageItemModel     *curImageItem;
@property (copy, nonatomic) void (^deleteImageBlock) (MPImageItemModel *toDelete);

//单元格大小
+(CGSize)ccellSize;

@end
