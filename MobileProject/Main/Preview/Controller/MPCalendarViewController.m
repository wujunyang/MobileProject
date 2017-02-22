//
//  MPCalendarViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/20.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPCalendarViewController.h"

@interface MPCalendarViewController ()
@property(strong,nonatomic)UIButton *addButton,*deleteButton;
@end

@implementation MPCalendarViewController


//Event Kit框架使你能访问用户的Calendar(日历)和Reminder(提醒事项)信息。虽然二者在手机上是两个独立的app，但他们使用相同的库（EKEventStore）处理数据，该库管理所有event数据。该框架除了允许检索用户已经存在的calendar和reminder数据外，还允许创建新的事件和提醒。


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //增加UI
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.deleteButton];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addButton.bottom).offset(20);
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
    }];
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
    return [self changeTitle:@"日历增加事件通知"];
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

-(UIButton *)addButton
{
    if (!_addButton) {
        _addButton=[[UIButton alloc]init];
        [_addButton setTitle:@"增加日历事件" forState:UIControlStateNormal];
        _addButton.backgroundColor=[UIColor blueColor];
        [_addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}


-(UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton=[[UIButton alloc]init];
        [_deleteButton setTitle:@"删除日历事件" forState:UIControlStateNormal];
        _deleteButton.backgroundColor=[UIColor redColor];
        [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

-(void)addAction
{
    NSLog(@"增加日历事件");
    
    NSArray *alarmArray = @[@"-86400",@"-43200",@"-21600"];
    
    [[MPEventCalendar sharedEventCalendar] createEventCalendarTitle:@"122我在测试" location:@"本地" startDate:[NSDate date] endDate:[NSDate date] allDay:YES alarmArray:alarmArray];

}

-(void)deleteAction
{
    NSLog(@"删除日历事件");
}
@end
