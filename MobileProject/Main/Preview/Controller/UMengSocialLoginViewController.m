//
//  UMengSocialLoginViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/1/27.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "UMengSocialLoginViewController.h"

@interface UMengSocialLoginViewController ()

@end

@implementation UMengSocialLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"友盟第三方登录";
    //测试第三方登录
    [self initPageLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 布局
-(void)initPageLoad
{
    UIButton *qqBtn=[UIButton new];
    [qqBtn setTitle:@"QQ登录" forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(qqBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqBtn];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(5);
        make.centerY.mas_equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    UIButton *wechatBtn=[UIButton new];
    [wechatBtn setTitle:@"微信登录" forState:UIControlStateNormal];
    [wechatBtn addTarget:self action:@selector(wechatBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatBtn];
    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(qqBtn.mas_right).with.offset(5);
        make.centerY.mas_equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    UIButton *weiboBtn=[UIButton new];
    [weiboBtn setTitle:@"新浪微博登录" forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(weiboBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboBtn];
    [weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wechatBtn.mas_right).with.offset(5);
        make.centerY.mas_equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    if ([WXApi isWXAppInstalled])
    {
        
    }
    else
    {
        //wechatBtn.hidden=YES;
        NSLog(@"微信客户端没有安装，要把页面的微信隐藏起来，否则会被拒绝上架");
    }
    
    if ([QQApiInterface isQQInstalled])
    {
    }
    else
    {
        //qqBtn.hidden=YES;
        NSLog(@"QQ客户端没有安装，要把页面的QQ隐藏起来，否则会被拒绝上架");
    }
    
    if ([WeiboSDK isCanShareInWeiboAPP])
    {
        
    }
    else
    {
        //weiboBtn.hidden=YES;
        NSLog(@"新浪客户端没有安装，要把页面的新浪隐藏起来，否则会被拒绝上架");
    }
}

#pragma mark 第三方登录

-(void)umShareToQQLogin
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            //获得一些信息，然后跟本服务器后端进行账号的绑定，并实现登录的功能
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
        }});
}

-(void)umShareToWechatLogin
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            //获得一些信息，然后跟本服务器后端进行账号的绑定，并实现登录的功能
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
        }
    });
}

-(void)umShareToSinaWeiboLogin
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        // 获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            //获得一些信息，然后跟本服务器后端进行账号的绑定，并实现登录的功能
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
        }});
}

-(void)qqBtnPressed
{
    [self umShareToQQLogin];
}

-(void)wechatBtnPressed
{
    [self umShareToWechatLogin];
}

-(void)weiboBtnPressed
{
    //目前不能进入WeiBo登录页面,AppRedirectURL 配置不一致··登录新浪开发者····在我的应用->应用信息->高级应用->授权设置->应用回调页中的 url 地址保持一致就可 以了,XCODE里的Bundle Identifier要一样,或者可以把本项目Bundle Identifier改为：com.Umeng.UMSocial 因为项目现在用的是友盟官方实例key
    [self umShareToSinaWeiboLogin];
}

@end
