//
//  JSPatchHelper.h
//  MobileProject 热更新帮助类
//
//  Created by wujunyang on 16/6/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JPEngine.h>




@interface JSPatchHelper : NSObject


+ (instancetype)sharedInstance;

/**
 *  @author wujunyang, 16-06-13 14:06:13
 *
 *  @brief  加载JSPatch
 */
+(void)HSDevaluateScript;

/**
 *  @author wujunyang, 16-06-13 14:06:21
 *
 *  @brief  下载JS文件
 */
+(void)loadJSPatch;

@end
