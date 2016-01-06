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
    
    LogInApi *reg = [[LogInApi alloc] initWithUsername:@"username" password:@"password"];
    [reg startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSLog(@"状态码%ld",request.responseStatusCode);
        LoginModel *model=[[LoginModel alloc]initWithString:request.responseString error:nil];
        NSLog(@"响应内容:%@",model.access_token);
        
    } failure:^(YTKBaseRequest *request) {
        NSLog(@"Error");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
