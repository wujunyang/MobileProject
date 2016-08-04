//
//  MPAddressPickViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/8/3.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPAddressPickViewController.h"

@interface MPAddressPickViewController()
@property(nonatomic,strong)AddressPickerView *myAddressPickerView;
@end


@implementation MPAddressPickViewController

#pragma mark viewController生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    [self layoutPageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark 重写BaseViewController设置内容

//设置导航栏背景色
-(UIColor*)set_colorBackground
{
    return [UIColor whiteColor];
}

////设置标题
-(NSMutableAttributedString*)setTitle
{
    return [self changeTitle:@"省市区三级联动"];
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
    UIButton *leftButton=[[UIButton alloc]init];
    [leftButton setTitle:@"显示地区选择" forState:UIControlStateNormal];
    leftButton.backgroundColor=[UIColor blueColor];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(Main_Screen_Width);
    }];
}

-(void)leftButtonAction:(id)sender
{
    _myAddressPickerView = [AddressPickerView shareInstance];
    //可以设置其默认值
    //[_myAddressPickerView configDataProvince:@"福建省" City:@"厦门市" Town:@"思明区"];
    //可以判断弹出窗当前的状态
    //_myAddressPickerView.currentPickState
    
    [_myAddressPickerView showAddressPickView];
    [self.view addSubview:_myAddressPickerView];
    
    __weak UIButton *temp = (UIButton *)sender;
    _myAddressPickerView.block = ^(NSString *province,NSString *city,NSString *district)
    {
        [temp setTitle:[NSString stringWithFormat:@"%@ %@ %@",province,city,district] forState:UIControlStateNormal];
    };
}

@end
