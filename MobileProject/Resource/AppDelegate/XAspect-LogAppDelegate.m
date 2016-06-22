//
//  XAspect-LogAppDelegate.m
//  MobileProject 抽离原本应在AppDelegate的内容(日志预加载)
//
//  Created by wujunyang on 16/6/22.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "AppDelegate.h"
#import "MyFileLogger.h"
#if DEBUG
#import "FLEXManager.h"
#endif
#import "XAspect.h"

#define AtAspect LogAppDelegate

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)
AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions)
{
    //如果是测试本地版本开启调试工具FLEX
#if DEBUG&LOCAL
    [[FLEXManager sharedManager] showExplorer];
#endif
    
    //日志初始化
    [MyFileLogger sharedManager];
    
    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}

@end
#undef AtAspectOfClass
#undef AtAspect
