//
//  MPLocationConverter.h
//  MobileProject
//
//  Created by wujunyang on 2017/4/27.

//如何使用
//我是个经纬度
//CLLocationCoordinate2D location = (CLLocationCoordinate2D){
//    .latitude  = 0.0,
//    .longitude = 0.0
//};
//
////判断是否在中国
//if (![MPLocationConverter isLocationOutOfChina:location])
//{
//    //将WGS-84转为GCJ-02(火星坐标)
//    location = [MPLocationConverter transformFromWGSToGCJ:location];
//    
//    //将GCJ-02(火星坐标)转为百度坐标
//    location = [MPLocationConverter transformFromGCJToBaidu:location];
//    
//    //将百度坐标转为GCJ-02(火星坐标)
//    location = [MPLocationConverter transformFromBaiduToGCJ:location];
//    
//    //将GCJ-02(火星坐标)转为WGS-84
//    location = [MPLocationConverter transformFromGCJToWGS:location];
//}
//
//NSLog(@"%f,%f",location.latitude,location.longitude);

//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MPLocationConverter : NSObject

/**
 *  判断是否在中国
 */
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;

/**
 *  将WGS-84转为GCJ-02(火星坐标):
 */
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

/**
 *  将GCJ-02(火星坐标)转为百度坐标:
 */
+(CLLocationCoordinate2D)transformFromGCJToBaidu:(CLLocationCoordinate2D)p;

/**
 *  将百度坐标转为GCJ-02(火星坐标):
 */
+(CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)p;

/**
 *  将GCJ-02(火星坐标)转为WGS-84:
 */
+(CLLocationCoordinate2D)transformFromGCJToWGS:(CLLocationCoordinate2D)p;


@end
