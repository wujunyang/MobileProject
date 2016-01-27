//
//  LogInViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
  
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
    UMengSocialViewController *um=[[UMengSocialViewController alloc]init];
    [self.navigationController pushViewController:um animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
