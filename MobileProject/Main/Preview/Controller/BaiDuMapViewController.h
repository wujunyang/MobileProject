//
//  BaiDuMapViewController.h
//  MobileProject 预演百度地图运用
//
//  Created by wujunyang on 16/1/28.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapKit/BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "BaiduRouteAnnotation.h"
#import "BaiduCoordinateModel.h"

@interface BaiDuMapViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate, BMKRouteSearchDelegate>

//坐标集合 BaiduCoordinateModel
@property(strong,nonatomic)NSMutableArray *coordinates;

@end
