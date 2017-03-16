//
//  MPUseProtocolOptional.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/10.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPUseProtocolOptional.h"


@implementation MPUseProtocolOptional

-(void)connetcomWithConnetionProtocol:(id<MPDataBaseConnectionProtocol>) service withIndentifier:(NSString *)indentifier
{
    NSLog(@"开始执行MPUseProtocolOptional");
    [service connect];
    NSLog(@"结束执行MPUseProtocolOptional");
}

@end
