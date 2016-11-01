//
//  MPChildrenViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/8/2.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPChildrenViewController.h"


@implementation MPChildrenViewController


#pragma mark viewController生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];

    
    [self layoutPageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    //如果要隐藏NavigationBar
    //[self changeNavigationBarTranslationY:-64];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    //如果隐藏NavigationBar,退出去时还得开放出来
    //[self changeNavigationBarTranslationY:0];
}


#pragma mark 重写BaseViewController设置内容

//设置导航栏背景色
-(UIColor*)set_colorBackground
{
    return [UIColor whiteColor];
}

//是否隐藏导航栏底部的黑线 默认也为NO
-(BOOL)hideNavigationBottomLine
{
    return NO;
}

////设置标题
-(NSMutableAttributedString*)setTitle
{
    return [self changeTitle:@"设置标题"];
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
    [self.navigationController popViewControllerAnimated:YES];
}

//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    UIButton *right_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [right_button setImage:[UIImage imageNamed:@"nav_complete"] forState:UIControlStateNormal];
    [right_button setImage:[UIImage imageNamed:@"nav_complete"] forState:UIControlStateHighlighted];
    [right_button setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 6)];
    return right_button;
}

//设置右边事件
-(void)right_button_event:(UIButton*)sender
{
    [MBProgressHUD showSuccess:@"您点击操作完成" ToView:self.view];
    
    //修改当前页面的标题
    [self set_Title:[self changeTitle:@"修改后的标题"]];
}


//点击标题事件，不要可以不重写
-(void)title_click_event:(UIView*)sender
{
    [MBProgressHUD showInfo:@"您点击标题视图" ToView:self.view];
}

#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}

-(void)layoutPageView
{
    UILabel *myLabel=[[UILabel alloc]init];
    myLabel.font=CHINESE_SYSTEM(15);
    myLabel.numberOfLines=0;
    [myLabel sizeToFit];
    myLabel.text=@"项目中可以让所有的页面都继承BaseViewController，可以重写它一些关于Nav的内容，不必要时可不重写，就不会有效果展现，以后也可以做统一处理";
    myLabel.textAlignment=NSTextAlignmentCenter;
    myLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:myLabel];
    [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    UIButton *leftButton=[[UIButton alloc]init];
    [leftButton setTitle:@"纯色导航" forState:UIControlStateNormal];
    leftButton.backgroundColor=[UIColor blueColor];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(Main_Screen_Width/2);
    }];
    
    UIButton *rightButton=[[UIButton alloc]init];
    [rightButton setTitle:@"隐藏导航" forState:UIControlStateNormal];
    rightButton.backgroundColor=[UIColor greenColor];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(Main_Screen_Width/2);
    }];
}


-(void)leftButtonAction
{
    MPSolidColorViewController *vc=[[MPSolidColorViewController alloc]init];
    //把动画关掉
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)rightButtonAction
{
    MPHideNavigationViewController *vc=[[MPHideNavigationViewController alloc]init];
    //把动画关掉
    [self.navigationController pushViewController:vc animated:YES];
}
@end
