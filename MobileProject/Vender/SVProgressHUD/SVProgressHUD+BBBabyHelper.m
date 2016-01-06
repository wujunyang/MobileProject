//
//  SVProgressHUD+BBBabyHelper.m
//  BabyDiary
//
//  Created by zhangchun on 15/6/18.
//  Copyright (c) 2015年 zhangchun. All rights reserved.
//

#import "SVProgressHUD+BBBabyHelper.h"

@implementation SVProgressHUD (BBBabyHelper)

#pragma mark - ProgressHUD

+(void)showLoadingView:(NSString*)tipString
{
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setFont:BOLDSYSTEMFONT(18)];
    [SVProgressHUD setBackgroundColor:RGB(96, 92, 93)];
    [SVProgressHUD showWithStatus:tipString maskType:SVProgressHUDMaskTypeClear];
}

+(void)hideLoadingView
{
    [SVProgressHUD dismiss];
}

+(void)showSuccessView:(NSString*)tipString
{
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"progressHUD_success"]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setFont:BOLDSYSTEMFONT(18)];
    [SVProgressHUD setBackgroundColor:RGB(96, 92, 93)];
    [SVProgressHUD showSuccessWithStatus:tipString maskType:SVProgressHUDMaskTypeNone];
}

+(void)showErrorView:(NSString*)tipString
{
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"progressHUD_error"]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setFont:BOLDSYSTEMFONT(18)];
    [SVProgressHUD setBackgroundColor:RGB(96, 92, 93)];
    [SVProgressHUD showErrorWithStatus:tipString maskType:SVProgressHUDMaskTypeNone];
}

+(void)BBShowTipView:(NSString*)tipString
{
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setFont:BOLDSYSTEMFONT(18)];
    [SVProgressHUD setBackgroundColor:RGB(96, 92, 93)];
    [SVProgressHUD showInfoWithStatus:tipString];
}
@end
