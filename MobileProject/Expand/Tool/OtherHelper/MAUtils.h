//
//  MAUtils.h
//  MobileProject
//
//  Created by 韩学鹏 on 16/6/17.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAUtils : NSObject

/**
 *  拨打电话
 *
 *  @param phone 电话号码
 */
+ (void)callWithPhoneNumber:(NSString *)phone;


/**
 *  屏幕上显示一个消息，需要调用hideMessage隐藏
 *
 *  @param msg 提示信息
 */
+ (void)showMessage:(NSString *)msg;

/**
 *  隐藏屏幕上的消息
 */
+ (void)hideMessage;

/**
 *  显示一个信息在指定时间后删除
 *
 *  @param msg   提示信息
 *  @param delay 消失时间
 */
+ (void)showToast:(NSString *)msg delay:(NSUInteger)delay;

@end
