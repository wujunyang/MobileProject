//
//  MPRunTimeTest.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/9.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPRunTimeTest.h"

@interface MPRunTimeTest()
{
    int _UserAge;
}
@end


@implementation MPRunTimeTest


+(void)showAddressInfo
{
    NSLog(@"当前地址为:厦门市");
}

-(NSString *)showUserName:(NSString *)name
{
    return [NSString stringWithFormat:@"user name is %@",name];
}

@end
