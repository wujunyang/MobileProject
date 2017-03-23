//
//  MPFDWithNoBarViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/23.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPFDWithNoBarViewController.h"

@interface MPFDWithNoBarViewController ()
@property(nonatomic,strong)UIButton *myButton;
@end

@implementation MPFDWithNoBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor redColor];
    
    //隐藏导航栏
    self.fd_prefersNavigationBarHidden=YES;
    
    
    //增加控件
    [self.view addSubview:self.myButton];
    [self.myButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(20);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIButton *)myButton
{
    if (!_myButton) {
        _myButton=[UIButton new];
        _myButton.backgroundColor=[UIColor redColor];
        [_myButton setTitle:@"跳转子页,并又出现导航栏" forState:UIControlStateNormal];
        [_myButton addTarget:self action:@selector(myButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myButton;
}

-(void)myButtonAction
{
    MPFDWithBarChildViewController *vc=[[MPFDWithBarChildViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
