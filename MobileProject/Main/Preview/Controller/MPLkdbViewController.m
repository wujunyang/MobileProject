//
//  MPLkdbViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/7/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPLkdbViewController.h"
#import "MPLKDBHelper.h"
#import "MPLKDBUserModel.h"
#import "NSObject+PrintSQL.h"


@interface MPLkdbViewController()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *myTextField;
@end

@implementation MPLkdbViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"LKDB数据库操作";

    [self startLKDB];
    
    [self startLayout];
}

-(void)startLKDB
{
    
    //这个是全局可以在程序定义一次 让其它都可以用
    LKDBHelper* globalHelper = [MPLKDBHelper getUsingLKDBHelper];
    
    //删除所有的表
    [globalHelper dropAllTable];
    
    //清理所有数据
    [LKDBHelper clearTableData:[MPLKDBUserModel class]];
    
    MPLKDBUserModel *model=[[MPLKDBUserModel alloc]init];
    model.userName=@"wujunyang";
    model.ID=11;
    model.password=@"123456";
    
    //增加删除修改这些都可以放在model类去写
    [model saveToDB];
    [globalHelper insertToDB:model];
}

//测试输入框 电话号码、身份证、银行卡分隔
-(void)startLayout
{
    if (!self.myTextField) {
        self.myTextField=[[UITextField alloc]initWithFrame:CGRectMake(100, 150, 200, 40)];
        self.myTextField.backgroundColor=[UIColor grayColor];
        self.myTextField.delegate=self;
        [self.view addSubview:self.myTextField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSArray *insertPosition = @[@(3), @(7)];
    [textField insertWhitSpaceInsertPosition:insertPosition replacementString:string textlength:20];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    NSLog(@"当前值%@",textField.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
