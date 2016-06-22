//
//  AppDelegate.m
//  MobileProject
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    
    //启动友盟统计
    [MPUmengHelper UMAnalyticStart];
    
    //地图定位初始化
    [MPLocationManager installMapSDK];
    
    //热更新加载
    [JSPatchHelper HSDevaluateScript];
    
    //百度地图定位
    [[MPLocationManager shareInstance] startBMKLocationWithReg:^(BMKUserLocation *loction, NSError *error) {
        if (error) {
            DDLogError(@"定位失败,失败原因：%@",error);
        }
        else
        {
            DDLogError(@"定位信息：%f,%f",loction.location.coordinate.latitude,loction.location.coordinate.longitude);
        }
    }];
    
    //百度定位并获取相关城市信息
    //    [[MPLocationManager shareInstance] startBMKLocationWithReg:^(BMKUserLocation *loction, NSError *error) {
    //        if (!error) {
    //            CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    //            [geocoder reverseGeocodeLocation:loction.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
    //                if (placemarks.count>0) {
    //                    CLPlacemark *placemark=[placemarks objectAtIndex:0];
    //                    //获取城市
    //                    NSString *city = placemark.locality;
    //                    if (!city) {
    //                        //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
    //                        city = placemark.administrativeArea;
    //                    }
    //
    //                    NSLog(@"百度当前城市：[%@]",city);
    //                }
    //            }];
    //        }
    //    }];
    
    //系统自带定位
    //[[MPLocationManager shareInstance]  startSystemLocationWithRes:^(CLLocation *loction, NSError *error) {
    //    DDLogError(@"系统自带定位信息：%f,%f",loction.coordinate.latitude,loction.coordinate.longitude);
    //}];
    

    
    //友盟分享及第三方登录初始化
    [self initLoadUMSocial];
    
    //加载页面
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupLoginViewController];
    
    
    //启动广告（记得放最后，才可以盖在页面上面）
    [self setupAdveriseView];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark 启动广告
-(void)setupAdveriseView
{
    // TODO 请求广告接口 获取广告图片
    
    //现在了一些固定的图片url代替
    NSArray *imageArray = @[@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg", @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png", @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg", @"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg"];
    
    [AdvertiseHelper showAdvertiserView:imageArray];
}


#pragma mark 自定义跳转不同的页面
//登录页面
-(void)setupLoginViewController
{
    LogInViewController *logInVc = [[LogInViewController alloc]init];
    UINavigationController *navcLogin = [[UINavigationController alloc]initWithRootViewController:logInVc];
    [navcLogin setNavigationBarHidden:YES];
    self.window.rootViewController = navcLogin;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

//首页
-(void)setupHomeViewController
{
    HomeViewController *logInVc = [[HomeViewController alloc]init];
    UINavigationController *navcLogin = [[UINavigationController alloc]initWithRootViewController:logInVc];
    [navcLogin setNavigationBarHidden:YES];
    self.window.rootViewController = navcLogin;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}





#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用

/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [GeTuiSdk registerDeviceToken:myToken];
    
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", myToken);
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    [GeTuiSdk registerDeviceToken:@""];
    
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台) 当不走个推时，从苹果进来执行，获得userInfo里面的属性*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //处理applicationIconBadgeNumber-1
    //[self handlePushMessage:userInfo notification:nil];
    
    //除了个推还要处理走苹果的信息放在body里面
    if (userInfo) {
        NSString *payloadMsg = [userInfo objectForKey:@"payload"];
        NSString *message=[[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]objectForKey:@"body"];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"您有一条新消息" message:[NSString stringWithFormat:@"%@,%@",payloadMsg,message] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"%@",userInfo);
    }
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  当不走个推时，从苹果进来执行，获得userInfo里面的属性*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    //处理applicationIconBadgeNumber-1
    //[self handlePushMessage:userInfo notification:nil];
    
    //除了个推还要处理走苹果的信息放在body里面
    if (userInfo) {
        NSString *payloadMsg = [userInfo objectForKey:@"payload"];
        NSString *message=[[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]objectForKey:@"body"];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"您有一条新消息" message:[NSString stringWithFormat:@"%@,%@",payloadMsg,message] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"%@",userInfo);
    }
    // 处理APN
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}




#pragma mark 初始化友盟分享
-(void)initLoadUMSocial
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:kUmengKey];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    //[UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:kSocial_WX_ID appSecret:kSocial_WX_Secret url:kSocial_WX_Url];
    
    // 打开新浪微博的SSO开关
    // 将在新浪微博注册的应用appkey、redirectURL替换下面参数，并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3921700954"，详情请参考官方文档。
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSocial_Sina_Account
                                         RedirectURL:kSocial_Sina_RedirectURL];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:kSocial_QQ_ID appKey:kSocial_QQ_Secret url:kSocial_QQ_Url];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    //分享设置类型（QQ,微信好友，微信朋友圈）
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage; //设置QQ分享纯图片，默认分享图文消息
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;  //设置微信好友分享纯图片
    [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeImage;  //设置微信朋友圈分享纯图片
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
    
    //热更新JS文件下载 最好做一个时间限制 比如隔多久进行下载(间隔一小时)
    [JSPatchHelper loadJSPatch];
}

@end
