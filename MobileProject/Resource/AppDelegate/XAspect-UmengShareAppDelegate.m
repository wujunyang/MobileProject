//
//  XAspect-UmengShareAppDelegate.m
//  MobileProject 抽离原本应在AppDelegate的内容(友盟分享)
//
//  Created by wujunyang on 16/6/22.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "AppDelegate.h"
#import "XAspect.h"

#define AtAspect UmengShareAppDelegate

#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)

@synthesizeNucleusPatch(Default,-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions);
@synthesizeNucleusPatch(Default,-, BOOL, application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation);
@synthesizeNucleusPatch(Default,-, void, applicationDidBecomeActive:(UIApplication *)application);


AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions)
{
    //友盟分享及第三方登录初始化
    [self initLoadUMSocial];
    
    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
AspectPatch(-, BOOL, application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation)
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
AspectPatch(-, void, applicationDidBecomeActive:(UIApplication *)application)
{
    [UMSocialSnsService  applicationDidBecomeActive];
    return XAMessageForward(applicationDidBecomeActive:application);
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */


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

@end
#undef AtAspectOfClass
#undef AtAspect
