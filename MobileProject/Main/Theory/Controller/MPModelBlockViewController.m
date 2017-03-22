//
//  MPModelBlockViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPModelBlockViewController.h"
#import "GCD.h"

@interface MPModelBlockViewController ()

@end

@implementation MPModelBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"模态弹出窗";
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    //3秒后自动跳回
    [[GCDQueue mainQueue]execute:^{
        if (self.successBlock) {
            self.successBlock();
        }
    } afterDelay:3*NSEC_PER_SEC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
