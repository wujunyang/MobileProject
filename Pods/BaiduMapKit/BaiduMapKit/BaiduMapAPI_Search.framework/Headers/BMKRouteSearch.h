/*
 *  BMKRouteSearch.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */
#import "BMKRouteSearchOption.h"
#import "BMKSearchBase.h"

@protocol BMKRouteSearchDelegate;
///route搜索服务
@interface BMKRouteSearch : BMKSearchBase
/// 检索模块的Delegate，此处记得不用的时候需要置nil，否则影响内存的释放
@property (nonatomic, weak) id<BMKRouteSearchDelegate> delegate;

/**
 *公交路线检索
 *异步函数，返回结果在BMKRouteSearchDelegate的onGetTransitRouteResult通知
 *@param transitRoutePlanOption 公交换乘信息类
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)transitSearch:(BMKTransitRoutePlanOption*)transitRoutePlanOption;

/**
 *驾乘路线检索
 *异步函数，返回结果在BMKRouteSearchDelegate的onGetDrivingRouteResult通知
 *@param drivingRoutePlanOption 驾车检索信息类
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)drivingSearch:(BMKDrivingRoutePlanOption*)drivingRoutePlanOption;

/**
 *步行路线检索
 *异步函数，返回结果在BMKRouteSearchDelegate的onGetWalkingRouteResult通知
 *@param walkingRoutePlanOption 步行检索信息类
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)walkingSearch:(BMKWalkingRoutePlanOption*)walkingRoutePlanOption;

/**
 *骑行路线检索
 *异步函数，返回结果在BMKRouteSearchDelegate的onGetRidingRouteResult通知
 *@param ridingRoutePlanOption 骑行检索信息类
 *@return 成功返回YES，否则返回NO
 */
- (BOOL)ridingSearch:(BMKRidingRoutePlanOption*) ridingRoutePlanOption;

@end

///路线搜索delegate，用于获取路线搜索结果
@protocol BMKRouteSearchDelegate<NSObject>
@optional
/**
 *返回公交搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKTransitRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error;
/**
 *返回驾乘搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKDrivingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error;

/**
 *返回步行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKWalkingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error;

/**
 *返回骑行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKRidingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetRidingRouteResult:(BMKRouteSearch*)searcher result:(BMKRidingRouteResult*)result errorCode:(BMKSearchErrorCode)error;

@end
