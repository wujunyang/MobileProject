/*
 *  BMKPoiSearchOption.h
 *  BMapKit
 *
 *  Copyright 2013 Baidu Inc. All rights reserved.
 *
 */

#import <BaiduMapAPI_Base/BMKTypes.h>
#import "BMKRouteSearchType.h"
/// 路线查询基础信息类
@interface BMKBaseRoutePlanOption : NSObject
{
    BMKPlanNode        *_from;
    BMKPlanNode        *_to;
}
///检索的起点，可通过关键字、坐标两种方式指定
@property (nonatomic, strong) BMKPlanNode *from;
///检索的终点，可通过关键字、坐标两种方式指定
@property (nonatomic, strong) BMKPlanNode *to;
@end
/// 步行查询基础信息类
@interface BMKWalkingRoutePlanOption : BMKBaseRoutePlanOption
{

}
@end
/// 驾车查询基础信息类
@interface BMKDrivingRoutePlanOption : BMKBaseRoutePlanOption
{
    NSArray*   _wayPointsArray;
    BMKDrivingPolicy _drivingPolicy;
}
@property (nonatomic, strong) NSArray  *wayPointsArray;
///驾车检索策略，默认使用BMK_DRIVING_TIME_FIRST
@property (nonatomic) BMKDrivingPolicy drivingPolicy;

///驾车检索获取路线每一个step的路况，默认使用BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE
@property (nonatomic) BMKDrivingRequestTrafficType drivingRequestTrafficType;


@end
/// 公交查询基础信息类
@interface BMKTransitRoutePlanOption : BMKBaseRoutePlanOption
{
    NSString*               _city;
    BMKTransitPolicy        _transitPolicy;
}
///城市名，用于在哪个城市内进行检索
@property (nonatomic, strong) NSString *city;
///公交检索策略，默认使用BMK_TRANSIT_TIME_FIRST
@property (nonatomic) BMKTransitPolicy transitPolicy;

@end



