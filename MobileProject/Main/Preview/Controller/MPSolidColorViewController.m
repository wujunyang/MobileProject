//
//  MPSolidColorViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/8/3.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPSolidColorViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@implementation MPSolidColorViewController


#pragma mark viewController生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    
    UIView *headerView=[[UIView alloc]init];
    headerView.backgroundColor=[UIColor redColor];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(120);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //进来就把全屏返回关掉
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled=NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //进来就把全屏返回打开
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark 重写BaseViewController设置内容

//设置导航栏背景色
-(UIColor*)set_colorBackground
{
    return [UIColor redColor];
}

//是否隐藏导航栏底部的黑线 默认也为NO
-(BOOL)hideNavigationBottomLine
{
    return YES;
}

////设置标题
-(NSMutableAttributedString*)setTitle
{
    return [self changeTitle:@"纯色导航栏"];
}

//设置左边按键
-(UIButton*)set_leftButton
{
    UIButton *left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [left_button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
    return left_button;
}

//设置左边事件
-(void)left_button_event:(UIButton*)sender
{
    //把动画关掉
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}

@end
