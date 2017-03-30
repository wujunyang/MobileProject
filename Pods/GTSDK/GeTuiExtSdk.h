//
//  GeTuiExtSdk.h
//  GtExtensionSdk
//
//  Created by gexin on 16/9/14.
//  Copyright © 2016年 getui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface GeTuiExtSdk : NSObject

/**
 *  统计APNs到达情况
 */
+ (void)handelNotificationServiceRequest:(UNNotificationRequest *)request withComplete:(void (^)(void))completeBlock;
/**
 *  统计APNs到达情况和多媒体推送支持
 */
+ (void)handelNotificationServiceRequest:(UNNotificationRequest *)request withAttachmentsComplete:(void (^)(NSArray *attachments, NSArray *errors))completeBlock;

@end
