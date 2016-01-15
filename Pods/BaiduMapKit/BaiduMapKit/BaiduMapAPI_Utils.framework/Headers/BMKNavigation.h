/*
 *  BMKNavigation.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKTypes.h>
//定义调起导航的两种类型
//注：自2.8.0开始废弃，只支持调起客户端导航，在调起客户端导航时，才会调起web导航
typedef enum
{
    BMK_NAVI_TYPE_NATIVE = 0,//客户端导航
    BMK_NAVI_TYPE_WEB,//web导航
} BMK_NAVI_TYPE;

///此类管理调起导航时传入的参数
@interface BMKNaviPara : NSObject
{
	BMKPlanNode* _startPoint;
	BMKPlanNode* _endPoint;
	BMK_NAVI_TYPE _naviType;
    NSString* _appScheme;
    NSString* _appName;
}
///起点
@property (nonatomic, strong) BMKPlanNode* startPoint;
///终点
@property (nonatomic, strong) BMKPlanNode* endPoint;
///导航类型 注：自2.8.0开始废弃，只支持调起客户端导航，在调起客户端导航时，才会调起web导航
@property (nonatomic, assign) BMK_NAVI_TYPE naviType;
///应用返回scheme
@property (nonatomic, strong) NSString* appScheme;
///应用名称
@property (nonatomic, strong) NSString* appName;
///调起百度地图客户端失败后，是否支持调起web地图，默认：YES
@property (nonatomic, assign) BOOL isSupportWeb;

@end

///主引擎类
@interface BMKNavigation : NSObject

/**
*启动导航
*@param para 调起导航时传入得参数
*/
+ (BMKOpenErrorCode)openBaiduMapNavigation:(BMKNaviPara*)para;


@end


