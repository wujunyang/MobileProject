/*
 *  BMKMapManager.h
 *  BMapKit
 *
 *  Copyright 2011 Baidu Inc. All rights reserved.
 *
 */

#import "BMKGeneralDelegate.h"
#import <UIKit/UIKit.h>

enum EN_PERMISSION_STATUS
{
	E_PERMISSION_OK = 0,	// 授权验证通过
	E_PERMISSION_SERVER_ERROR = -200, //服务端数据错误，无法解析服务端返回数据
	E_PERMISSION_NETWORK_ERROR = -300, //无法建立与服务端的连接
    
};

///主引擎类
@interface BMKMapManager : NSObject

/**
*启动引擎
*@param key 申请的有效key
*@param delegate 
*/
-(BOOL)start:(NSString*)key generalDelegate:(id<BMKGeneralDelegate>)delegate;

/**
 *获取所有在线服务消耗的发送流量,单位：字节
 */
-(int)getTotalSendFlaxLength;

/**
 *获取所有在线服务消耗的接收流量,单位：字节
 */
-(int)getTotalRecvFlaxLength;

/**
*停止引擎
*/
-(BOOL)stop;



@end


