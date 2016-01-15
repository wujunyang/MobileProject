/*
 *  BMKLocationViewDisplayParam.h
 *  BMapKit
 *
 *  Copyright 2013 Baidu Inc. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


///此类表示定位图层自定义样式参数
@interface BMKLocationViewDisplayParam : NSObject
{
	float    _locationViewOffsetX; // 定位图标偏移量(经度)
    float    _locationViewOffsetY; // 定位图标偏移量（纬度）
    bool     _isAccuracyCircleShow;// 精度圈是否显示
    bool     _isRotateAngleValid;  // 跟随态旋转角度是否生效
    NSString* _locationViewImgName;// 定位图标名称

}
///定位图标偏移量X
@property (nonatomic, assign) float locationViewOffsetX;
///定位图标偏移量Y
@property (nonatomic, assign) float locationViewOffsetY;
///精度圈是否显示
@property (nonatomic, assign) bool isAccuracyCircleShow;
///跟随态旋转角度是否生效
@property (nonatomic, assign) bool isRotateAngleValid;
///定位图标
@property (nonatomic, strong) NSString* locationViewImgName;

@end



