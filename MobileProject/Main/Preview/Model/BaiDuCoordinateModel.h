//
//  BaiDuCoordinateModel.h
//  MobileProject 传递坐标参数，用于跟业务交互
//
//  Created by wujunyang on 16/1/28.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaiDuCoordinateModel : NSObject

//纬度
@property(assign,nonatomic)float coordinate_latitude;
//经度
@property(assign,nonatomic)float coordinate_longitude;
//业务标题
@property(strong,nonatomic)NSString *coordinate_title;
//业务注解
@property(strong,nonatomic)NSString *coordinate_comments;
//业务ID
@property(assign,nonatomic)long coordinate_objID;
@end
