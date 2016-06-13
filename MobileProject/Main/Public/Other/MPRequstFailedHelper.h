//
//  MPRequstFailedHelper.h
//  MobileProject 统一处理网络请求失败时的内容
//
//  Created by wujunyang on 16/6/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKBaseRequest.h"

@interface MPRequstFailedHelper : NSObject

+(void)requstFailed:(YTKBaseRequest *)request;

@end
