//
//  MPLocationConverter.m
//  MobileProject
//
//  Created by wujunyang on 2017/4/27.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPLocationConverter.h"
#import <math.h>
#import <UIKit/UIGeometry.h>

static const double a = 6378245.0;
static const double ee = 0.00669342162296594323;
static const double pi = 3.14159265358979324;
static const double xPi = M_PI  * 3000.0 / 180.0;

@implementation MPLocationConverter

+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc
{
    CLLocationCoordinate2D adjustLoc;
    double adjustLat = [self transformLatWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
    double adjustLon = [self transformLonWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
    long double radLat = wgsLoc.latitude / 180.0 * pi;
    long double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    long double sqrtMagic = sqrt(magic);
    adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    adjustLoc.latitude = wgsLoc.latitude + adjustLat;
    adjustLoc.longitude = wgsLoc.longitude + adjustLon;
    
    return adjustLoc;
}

+ (double)transformLatWithX:(double)x withY:(double)y
{
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    
    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
}

+ (double)transformLonWithX:(double)x withY:(double)y
{
    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lon;
}

+(CLLocationCoordinate2D)transformFromGCJToBaidu:(CLLocationCoordinate2D)p
{
    long double z = sqrt(p.longitude * p.longitude + p.latitude * p.latitude) + 0.00002 * sin(p.latitude * xPi);
    long double theta = atan2(p.latitude, p.longitude) + 0.000003 * cos(p.longitude * xPi);
    CLLocationCoordinate2D geoPoint;
    geoPoint.latitude = (z * sin(theta) + 0.006);
    geoPoint.longitude = (z * cos(theta) + 0.0065);
    return geoPoint;
}

+(CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)p
{
    double x = p.longitude - 0.0065, y = p.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * xPi);
    double theta = atan2(y, x) - 0.000003 * cos(x * xPi);
    CLLocationCoordinate2D geoPoint;
    geoPoint.latitude  = z * sin(theta);
    geoPoint.longitude = z * cos(theta);
    return geoPoint;
}

+(CLLocationCoordinate2D)transformFromGCJToWGS:(CLLocationCoordinate2D)p
{
    double threshold = 0.00001;
    
    // The boundary
    double minLat = p.latitude - 0.5;
    double maxLat = p.latitude + 0.5;
    double minLng = p.longitude - 0.5;
    double maxLng = p.longitude + 0.5;
    
    double delta = 1;
    int maxIteration = 30;
    // Binary search
    while(true)
    {
        CLLocationCoordinate2D leftBottom  = [[self class] transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = minLat,.longitude = minLng}];
        CLLocationCoordinate2D rightBottom = [[self class] transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = minLat,.longitude = maxLng}];
        CLLocationCoordinate2D leftUp      = [[self class] transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = maxLat,.longitude = minLng}];
        CLLocationCoordinate2D midPoint    = [[self class] transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = ((minLat + maxLat) / 2),.longitude = ((minLng + maxLng) / 2)}];
        delta = fabs(midPoint.latitude - p.latitude) + fabs(midPoint.longitude - p.longitude);
        
        if(maxIteration-- <= 0 || delta <= threshold)
        {
            return (CLLocationCoordinate2D){.latitude = ((minLat + maxLat) / 2),.longitude = ((minLng + maxLng) / 2)};
        }
        
        if(isContains(p, leftBottom, midPoint))
        {
            maxLat = (minLat + maxLat) / 2;
            maxLng = (minLng + maxLng) / 2;
        }
        else if(isContains(p, rightBottom, midPoint))
        {
            maxLat = (minLat + maxLat) / 2;
            minLng = (minLng + maxLng) / 2;
        }
        else if(isContains(p, leftUp, midPoint))
        {
            minLat = (minLat + maxLat) / 2;
            maxLng = (minLng + maxLng) / 2;
        }
        else
        {
            minLat = (minLat + maxLat) / 2;
            minLng = (minLng + maxLng) / 2;
        }
    }
    
}

static bool isContains(CLLocationCoordinate2D point, CLLocationCoordinate2D p1, CLLocationCoordinate2D p2)
{
    return (point.latitude >= MIN(p1.latitude, p2.latitude) && point.latitude <= MAX(p1.latitude, p2.latitude)) && (point.longitude >= MIN(p1.longitude,p2.longitude) && point.longitude <= MAX(p1.longitude, p2.longitude));
}


/**
 *  判断是不是在中国
 *  用引射线法判断 点是否在多边形内部
 *  算法参考：http://www.cnblogs.com/luxiaoxun/p/3722358.html
 */
+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location {
    CGPoint point = CGPointMake(location.latitude, location.longitude);
    BOOL oddFlag = NO;
    NSInteger j = [self polygonOfChina].count - 1;
    for (NSInteger i = 0; i < [self polygonOfChina].count; i++) {
        CGPoint polygonPointi = [[self polygonOfChina][i] CGPointValue];
        CGPoint polygonPointj = [[self polygonOfChina][j] CGPointValue];
        if (((polygonPointi.y < point.y && polygonPointj.y >= point.y) ||
             (polygonPointj.y < point.y && polygonPointi.y >= point.y)) &&
            (polygonPointi.x <= point.x || polygonPointj.x <= point.x)) {
            oddFlag ^= (polygonPointi.x +
                        (point.y - polygonPointi.y) /
                        (polygonPointj.y - polygonPointi.y) *
                        (polygonPointj.x - polygonPointi.x) <
                        point.x);
        }
        j = i;
    }
    return !oddFlag;
}

//  中国大陆多边形，用于判断坐标是否在中国
//  因为港澳台地区使用WGS坐标，所以多边形不包含港澳台地区
+ (NSMutableArray *)polygonOfChina {
    static NSMutableArray *polygonOfChina = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        polygonOfChina = [[NSMutableArray alloc] init];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(49.1506690000,
                                                         87.4150810000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(48.3664501790,
                                                         85.7527085300)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(47.0253058185,
                                                         85.3847443554)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(45.2406550000,
                                                         82.5214000000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(44.8957121295,
                                                         79.9392351487)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(43.1166843846,
                                                         80.6751253982)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(41.8701690000,
                                                         79.6882160000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(39.2896190000,
                                                         73.6171080000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(34.2303430000,
                                                         78.9155300000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(31.0238860000,
                                                         79.0627080000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(27.9989800000,
                                                         88.7028920000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(27.1793590000,
                                                         88.9972480000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(28.0969170000,
                                                         89.7331400000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(26.9157800000,
                                                         92.1615830000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(28.1947640000,
                                                         96.0986050000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(27.4094760000,
                                                         98.6742270000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(23.9085500000,
                                                         97.5703890000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(24.0775830000,
                                                         98.7846100000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(22.1375640000,
                                                         99.1893510000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(21.1398950000,
                                                         101.7649720000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(22.2746220000,
                                                         101.7281780000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(23.2641940000,
                                                         105.3708430000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(22.7191200000,
                                                         106.6954480000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(21.9945711661,
                                                         106.7256731791)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(21.4847050000,
                                                         108.0200530000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(20.4478440000,
                                                         109.3814530000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(18.6689850000,
                                                         108.2408210000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(17.4017340000,
                                                         109.9333720000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(19.5085670000,
                                                         111.4051560000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(21.2716775175,
                                                         111.2514995205)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(21.9936323233,
                                                         113.4625292629)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(22.1818312942,
                                                         113.4258358111)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(22.2249729295,
                                                         113.5913115000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(22.4501912753,
                                                         113.8946844490)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(22.5959159322,
                                                         114.3623797842)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(22.4334610000,
                                                         114.5194740000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(22.9680954377,
                                                         116.8326939975)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(25.3788220000,
                                                         119.9667980000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(28.3261276204,
                                                         121.7724402562)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(31.9883610000,
                                                         123.8808230000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(39.8759700000,
                                                         124.4695370000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(41.7350890000,
                                                         126.9531720000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(41.5142160000,
                                                         128.3145720000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(42.9842081790,
                                                         131.0676468344)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(45.2690810000,
                                                         131.8468530000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(45.0608370000,
                                                         133.0610740000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(48.4480260000,
                                                         135.0111880000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(48.0054800000,
                                                         131.6628800000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(50.2270740000,
                                                         127.6890640000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(53.3516070000,
                                                         125.3710040000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(53.4176040000,
                                                         119.9254040000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(47.5590810000,
                                                         115.1421070000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(47.1339370000,
                                                         119.1159230000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(44.8256460000,
                                                         111.2786750000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(42.5293560000,
                                                         109.2549720000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(43.2598160000,
                                                         97.2967290000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(45.4247620000,
                                                         90.9680590000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(47.8075570000,
                                                         90.6737020000)]];
        [polygonOfChina
         addObject:[NSValue valueWithCGPoint:CGPointMake(49.1506690000,
                                                         87.4150810000)]];
    });
    return polygonOfChina;
}


@end
