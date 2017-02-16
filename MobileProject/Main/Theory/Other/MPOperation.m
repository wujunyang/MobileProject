//
//  MPOperation.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/16.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPOperation.h"

@implementation MPOperation

/**
 * 需要执行的任务
 */

- (void)main
{
    for (int i = 0; i < 2; ++i) {
        NSLog(@"MPOperation当前的线程-----%@",[NSThread currentThread]);
    }
}

@end
