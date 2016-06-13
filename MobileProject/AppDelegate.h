//
//  AppDelegate.h
//  MobileProject
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeTuiSdk.h"
#import <UMSocial.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialQQHandler.h>
#import <UMSocialSinaHandler.h>
#import <UMSocialSinaSSOHandler.h>
#import "MyFileLogger.h"
#import "MPLocationManager.h"
#import "MPUmengHelper.h"
#import "LogInViewController.h"
#import "HomeViewController.h"
#import "JSPatchHelper.h"
#if DEBUG
#import "FLEXManager.h"
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;

//跳转到首页
-(void)setupHomeViewController;
@end

