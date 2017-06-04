//
//  MPTagAttribute.h
//  MobileProject
//
//  Created by wujunyang on 2017/6/2.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MPTagAttribute : NSObject

@property (nonatomic,assign) CGFloat borderWidth;//标签边框宽度
@property (nonatomic,strong) UIColor *borderColor;//标签边框颜色
@property (nonatomic,assign) CGFloat cornerRadius;//标签圆角大小
@property (nonatomic,strong) UIColor *normalBackgroundColor;//标签默认背景颜色
@property (nonatomic,strong) UIColor *selectedBackgroundColor;//标签选中背景颜色
@property (nonatomic,assign) CGFloat titleSize;//标签字体大小
@property (nonatomic,strong) UIColor *textColor;//标签字体颜色
@property (nonatomic,strong) UIColor *keyColor;//搜索关键词颜色
@property (nonatomic,assign) CGFloat tagSpace;//标签内部左右间距(标题距离边框2边的距离和)

@end
