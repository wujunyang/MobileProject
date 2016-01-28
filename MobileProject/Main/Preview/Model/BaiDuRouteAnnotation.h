//
//  BaiDuRouteAnnotation.h
//  MobileProject
//
//  Created by wujunyang on 16/1/28.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface BaiDuRouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点 100:自定义视图点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end
