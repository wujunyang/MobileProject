//
//  MPDatePickerViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/8/7.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPDatePickerViewController.h"
#import "NSDate+Utilities.h"
#import "MPDatePickerView.h"

@interface MPDatePickerViewController ()

@end

@implementation MPDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton *showButton=[UIButton new];
    showButton.titleLabel.font=SYSTEMFONT(15);
    [showButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [showButton setTitle:@"弹出日期控件" forState:UIControlStateNormal];
    [showButton addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showButton];
    [showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAction
{
    NSDate *minDate=[[NSDate date] dateByAddingDays:-3];
    NSDate *maxDate=[[[NSDate date] dateByAddingDays:15] dateByAddingHours:5];
    NSDate *selectedDate=[NSDate date];
    
    MPDatePickerView *datePickerView=[[MPDatePickerView alloc]initWithTitle:@"Select Start Time" selectedDate:selectedDate minimumDate:minDate maximumDate:maxDate doneBlock:^(NSDate *selectDate) {
        NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
        [dataFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLog(@"%@",[dataFormat stringFromDate:selectDate]);
    } cancelBlock:^{
    }];
    
    [self.view addSubview:datePickerView];
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
    return [self changeTitle:@"自定义日期选择控件"];
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

#pragma mark 自定义代码区

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}

@end
