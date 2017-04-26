//
//  MPMemoryHelper.h
//  MobileProject
//
//  Created by wujunyang on 2017/4/26.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPMemoryHelper : NSObject

// 获取当前设备可用内存(单位：MB）
- (double)availableMemory;

// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory;

@end
