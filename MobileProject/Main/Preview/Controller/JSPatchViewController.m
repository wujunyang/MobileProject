//
//  JSPatchViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/6/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "JSPatchViewController.h"

@interface JSPatchViewController ()
@property(nonatomic,strong)UILabel *myLabel;
@end

@implementation JSPatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"热更新";
    
    if (!self.myLabel) {
        self.myLabel=[[UILabel alloc]init];
        self.myLabel.textAlignment=NSTextAlignmentCenter;
        self.myLabel.text=[self getMessage];
        self.myLabel.font=CHINESE_SYSTEM(20);
        self.myLabel.textColor=[UIColor redColor];
        [self.view addSubview:self.myLabel];
        [self.myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.right.and.left.mas_equalTo(0);
            make.height.mas_equalTo(25);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getMessage
{
    return @"我是原来的内容";
}

@end
