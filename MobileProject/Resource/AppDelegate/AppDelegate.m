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







#pragma mark - APP运行中接收到通知(推送)处理

/**IOS7 APP已经接收到“远程”通知(推送) - (App运行在后台) 当不走个推时，从苹果进来执行，获得userInfo里面的属性*/
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

/**IOS7以后 APP已经接收到“远程”通知(推送) - 透传推送消息  当不走个推时，从苹果进来执行，获得userInfo里面的属性*/
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

// 处理推送消息
- (void)handlePushMessage:(NSDictionary *)dict notification:(UILocalNotification *)localNotification {
    NSLog(@"开始处理从通知栏点击进来的推送消息");
    
    if ([UIApplication sharedApplication].applicationIconBadgeNumber != 0) {
        if (localNotification) {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;
    }
    else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId andOffLine:(BOOL)offLine fromApplication:(NSString *)appId {
    
    [self handlePushMessage:nil notification:nil];
    // [4]: 收到个推消息
    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@" payloadId=%@,taskId=%@,messageId:%@,payloadMsg:%@%@", payloadId, taskId, aMsgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"您有一条新消息，走个推" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}






- (void)applicationDidBecomeActive:(UIApplication *)application
{

    //热更新JS文件下载 最好做一个时间限制 比如隔多久进行下载(间隔一小时)
    [JSPatchHelper loadJSPatch];
}





@end
