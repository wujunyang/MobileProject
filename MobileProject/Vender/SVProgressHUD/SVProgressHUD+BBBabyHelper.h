//
//  SVProgressHUD+BBBabyHelper.h
//  BabyDiary
//
//  Created by zhangchun on 15/6/18.
//  Copyright (c) 2015年 zhangchun. All rights reserved.
//

#import "SVProgressHUD.h"

@interface SVProgressHUD (BBBabyHelper)
+(void)showLoadingView:(NSString*)tipString;
+(void)hideLoadingView;
+(void)showSuccessView:(NSString*)tipString;
+(void)showErrorView:(NSString*)tipString;
+(void)BBShowTipView:(NSString*)tipString;
@end
