//
//  LogInViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "LogInViewController.h"
#import "AppDelegate.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
  
    
    //测试日志
    DDLogError(@"测试 Error 信息");
    DDLogWarn(@"测试 Warn 信息");
    DDLogDebug(@"测试 Debug 信息");
    DDLogInfo(@"测试 Info 信息");
    DDLogVerbose(@"测试 Verbose 信息");
    
    
    //登录成功后跳转到首页
    [((AppDelegate*) AppDelegateInstance) setupHomeViewController];
    
//    测试登录及网络请求
//    LogInApi *reg = [[LogInApi alloc] initWithUsername:@"username" password:@"password"];
//    [reg startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//        NSLog(@"状态码%ld",request.responseStatusCode);
//        LoginModel *model=[[LoginModel alloc]initWithString:request.responseString error:nil];
//        NSLog(@"响应内容:%@",model.access_token);
//        //成功登录 跳转到首页
//        [((AppDelegate*)AppDelegateInstance) setupHomeViewController];
//        
//    } failure:^(YTKBaseRequest *request) {
//        NSLog(@"Error");
//    }];
    
    
    //友盟第三方登录
//    UMengSocialLoginViewController *umLogin=[[UMengSocialLoginViewController alloc]init];
//    [self.navigationController pushViewController:umLogin animated:YES];
    
    //友盟分享跳转
//    UMengSocialViewController *um=[[UMengSocialViewController alloc]init];
//    [self.navigationController pushViewController:um animated:YES];
    
    //日志列表查看
//    LoggerViewController *lv=[[LoggerViewController alloc]init];
//    [self.navigationController pushViewController:lv animated:YES];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

