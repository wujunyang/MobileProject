//
//  UMengSocialViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/1/27.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "UMengSocialViewController.h"


@interface UMengSocialViewController ()

@end

@implementation UMengSocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blueColor]];
    [self initPageLoad];
    
    self.navigationItem.title=@"友盟分享跳转";
    [self.navigationController.tabBarItem setBadgeValue:@"2"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 页面布局

-(void)initPageLoad
{
    UIButton *qqBtn=[UIButton new];
    qqBtn.tag=1001;
    [qqBtn setTitle:@"QQ空间分享" forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqBtn];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(5);
        make.centerY.mas_equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    UIButton *wechatBtn=[UIButton new];
    wechatBtn.tag=1002;
    [wechatBtn setTitle:@"微信朋友圈" forState:UIControlStateNormal];
    [wechatBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatBtn];
    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(qqBtn.mas_right).with.offset(5);
        make.centerY.mas_equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    UIButton *weiboBtn=[UIButton new];
    weiboBtn.tag=1003;
    [weiboBtn setTitle:@"新浪微博分享" forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboBtn];
    [weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wechatBtn.mas_right).with.offset(5);
        make.centerY.mas_equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    UIButton *qqWebBtn=[UIButton new];
    qqWebBtn.tag=1004;
    [qqWebBtn setTitle:@"QQ微博分享" forState:UIControlStateNormal];
    [qqWebBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqWebBtn];
    [qqWebBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(5);
        make.centerY.mas_equalTo(qqBtn.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    UIButton *wechatfriendBtn=[UIButton new];
    wechatfriendBtn.tag=1005;
    [wechatfriendBtn setTitle:@"微信好友" forState:UIControlStateNormal];
    [wechatfriendBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatfriendBtn];
    [wechatfriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(qqWebBtn.mas_right).with.offset(5);
        make.centerY.mas_equalTo(wechatBtn.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
}


-(void)btnPressed:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    switch (btn.tag) {
        case 1001:
        {
            NSLog(@"QQ空间分享");
            
            //设置分享内容，和回调对象
            NSString *shareText = @"MobileProject分享";
            UIImage *shareImage = [UIImage imageNamed:@"test_UmengSocial_Image"];
            
            [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone];
            snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
            break;
        case 1002:
        {
            NSLog(@"微信分享");
            
            //设置分享内容，和回调对象
            NSString *shareText = @"MobileProject分享";
            UIImage *shareImage = [UIImage imageNamed:@"test_UmengSocial_Image"];
            
            [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline];
            snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
            break;
        case 1003:
        {
            NSLog(@"新浪分享");
            
            //设置分享内容，和回调对象
            NSString *shareText = @"MobileProject分享";
            UIImage *shareImage = [UIImage imageNamed:@"test_UmengSocial_Image"];
            
            [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
            break;
        case 1004:
        {
            NSLog(@"QQ微博分享");
            
            //设置分享内容，和回调对象
            NSString *shareText = @"MobileProject分享";
            UIImage *shareImage = [UIImage imageNamed:@"test_UmengSocial_Image"];
            
            [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent];
            snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
        case 1005:
        {
            NSLog(@"微信好友分享");
            
            //设置分享内容，和回调对象
            NSString *shareText = @"MobileProject分享";
            UIImage *shareImage = [UIImage imageNamed:@"test_UmengSocial_Image"];
            
            [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
            snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
            break;
        default:
            break;
    }
}


-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"didClose is %d",fromViewControllerType);
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if (response.responseCode == UMSResponseCodeSuccess) {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
    } else if(response.responseCode != UMSResponseCodeCancel) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
    }
}
@end
