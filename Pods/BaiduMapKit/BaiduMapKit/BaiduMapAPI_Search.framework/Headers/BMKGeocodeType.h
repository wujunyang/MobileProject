/*
 *  BMKGeocodeType.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>


///此类表示地址结果的层次化信息
@interface BMKAddressComponent : NSObject
{
	NSString* _streetNumber;
	NSString* _streetName;
	NSString* _district;
	NSString* _city;
	NSString* _province;
}

/// 街道号码
@property (nonatomic, strong) NSString* streetNumber;
/// 街道名称
@property (nonatomic, strong) NSString* streetName;
/// 区县名称
@property (nonatomic, strong) NSString* district;
/// 城市名称
@property (nonatomic, strong) NSString* city;
/// 省份名称
@property (nonatomic, strong) NSString* province;

@end



///反地址编码结果
@interface BMKReverseGeoCodeResult : NSObject
{
	BMKAddressComponent* _addressDetail;
	NSString* _address;
	CLLocationCoordinate2D _location;
	NSArray* _poiList;
}
///层次化地址信息
@property (nonatomic, strong) BMKAddressComponent* addressDetail;
///地址名称
@property (nonatomic, strong) NSString* address;
///商圈名称
@property (nonatomic, strong) NSString* businessCircle;
///地址坐标
@property (nonatomic) CLLocationCoordinate2D location;
///地址周边POI信息，成员类型为BMKPoiInfo
@property (nonatomic, strong) NSArray* poiList;

@end

///地址编码结果
@interface BMKGeoCodeResult : NSObject
{
    CLLocationCoordinate2D _location;
    NSString* _address;
}
///地理编码位置
@property (nonatomic) CLLocationCoordinate2D location;
///地理编码地址
@property (nonatomic,strong) NSString* address;

@end



