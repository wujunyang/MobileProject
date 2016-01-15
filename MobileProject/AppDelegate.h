//
//  AppDelegate.h
//  MobileProject
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileLogger.h"
#import "MPLocationManager.h"
#import "MPUmengHelper.h"
#import "LogInViewController.h"
#import "HomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//跳转到首页
-(void)setupHomeViewController;
@end

