//
//  MAUtils.m
//  MobileProject
//
//  Created by 韩学鹏 on 16/6/17.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MAUtils.h"
#import "MBProgressHUD.h"

@implementation MAUtils

+ (void)callWithPhoneNumber:(NSString *)phone
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phone]];
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)showMessage:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.labelText = [NSString stringWithFormat:@"\r\n%@", msg];
    });
}

+ (void)hideMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
    });
}

+ (void)showToast:(NSString *)msg delay:(NSUInteger)delay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.labelText = msg;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:delay];
    });
}

@end
