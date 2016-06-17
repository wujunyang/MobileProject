//
//  LogInViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "LogInViewController.h"
#import "MPQRCodeViewController.h"


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
//    UMengSocialViewController *um=[[UMengSocialViewController alloc]init];
//    [self.navigationController pushViewController:um animated:YES];
    
    //日志列表查看
//    LoggerViewController *lv=[[LoggerViewController alloc]init];
//    [self.navigationController pushViewController:lv animated:YES];
    
    //百度地图
//    NSMutableArray *coordinates=[[NSMutableArray alloc]init];
//    
//    BaiDuCoordinateModel *first=[[BaiDuCoordinateModel alloc]init];
//    first.coordinate_comments=@"我是第一个坐标";
//    first.coordinate_title=@"第一站";
//    first.coordinate_objID=1;
//    first.coordinate_latitude=24.496589;
//    first.coordinate_longitude=118.188555;
//    [coordinates addObject:first];
//    
//    BaiDuCoordinateModel *second=[[BaiDuCoordinateModel alloc]init];
//    second.coordinate_comments=@"我是第二个坐标";
//    second.coordinate_title=@"第二站";
//    second.coordinate_objID=1;
//    second.coordinate_latitude=24.49672;
//    second.coordinate_longitude=118.182051;
//    [coordinates addObject:second];
//    
//    BaiDuMapViewController *vc=[[BaiDuMapViewController alloc]init];
//    vc.coordinates=coordinates;
//    [self.navigationController pushViewController:vc animated:YES];
    
    //热更新
//    JSPatchViewController *vc=[[JSPatchViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    //二维码
    MPQRCodeViewController *vc = [[MPQRCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

