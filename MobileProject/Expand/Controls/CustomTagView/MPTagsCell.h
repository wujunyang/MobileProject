//
//  MPTagsCell.h
//  MobileProject
//  使用实例：https://github.com/huangxuan518/HXTagsView
//  Created by wujunyang on 2017/6/2.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPTagCollectionViewFlowLayout.h"

@class MPTagAttribute;

@interface MPTagsCell : UITableViewCell

@property (nonatomic,strong) NSArray *tags;//传入的标签数组 字符串数组
@property (nonatomic,strong) NSMutableArray *selectedTags; //选择的标签数组
@property (nonatomic,strong) MPTagCollectionViewFlowLayout *layout;//布局layout
@property (nonatomic,strong) MPTagAttribute *tagAttribute;//按钮样式对象
@property (nonatomic,assign) BOOL isMultiSelect;//是否可以多选 默认:NO 单选
@property (nonatomic,copy) NSString *key;//搜索关键词

@property (nonatomic,copy) void (^completion)(NSArray *selectTags,NSInteger currentIndex);//选中的标签数组,当前点击的index

//刷新界面
- (void)reloadData;

/**
 *  计算Cell的高度
 *
 *  @param tags         标签数组
 *  @param layout       布局样式 默认则传nil
 *  @param tagAttribute 标签样式 默认传nil 涉及到计算的主要是titleSize
 *  @param width        计算的最大范围
 */
+ (CGFloat)getCellHeightWithTags:(NSArray *)tags layout:(MPTagCollectionViewFlowLayout *)layout tagAttribute:(MPTagAttribute *)tagAttribute width:(CGFloat)width;


@end
