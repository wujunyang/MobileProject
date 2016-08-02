//
//  MPImageUploadProgressCell.h
//  MobileProject 带进度效果
//
//  Created by wujunyang on 16/7/22.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPImageProgressCollectionCell.h"
#import "MPImageItemModel.h"
#import "MPUploadImageHelper.h"
#import "UIView+Extension.h"
#import "UIView+ViewController.h"


@interface MPImageUploadProgressCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate,MWPhotoBrowserDelegate>
@property (strong, nonatomic) MPUploadImageHelper *curUploadImageHelper;

@property (copy, nonatomic) void(^addPicturesBlock)();
@property (copy, nonatomic) void (^deleteImageBlock)(MPImageItemModel *toDelete);

//获得最后的行高
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
