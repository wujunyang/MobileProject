//
//  MPQRCodeViewController.m
//  MobileProject
//
//  Created by 韩学鹏 on 16/6/17.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPQRCodeViewController.h"
#import "UIImage+QR.h"

@interface MPQRCodeViewController ()

@end

@implementation MPQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *qrImage = [UIImage qrCodeImageWithString:@"http://www.baidu.com" withSize:100.0f withRed:255 andGreen:0 andBlue:255];
    UIImageView *qrImageView = [[UIImageView alloc] initWithImage:qrImage];
    [qrImageView sizeToFit];
    CGRect frame = qrImageView.frame;
    frame.origin = CGPointMake(100.0f, 150.0f);
    qrImageView.frame = frame;
    [self.view addSubview:qrImageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
