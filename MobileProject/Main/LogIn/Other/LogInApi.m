//
//  LogInApi.m
//  MobileProject
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "LogInApi.h"


@interface LogInApi()
{
    NSString *_username;
    NSString *_password;
}
@end

@implementation LogInApi

- (id)initWithUsername:(NSString *)username password:(NSString *)password {
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"user/login";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

-(SERVERCENTER_TYPE)centerType
{
    return ACCOUNT_SERVERCENTER;
}

- (id)requestArgument {
    return @{
             @"user_name": _username,
             @"user_password": _password
             };
}

@end
