//
//  Helper.h
//  Blossom
//
//  Created by wujunyang on 15/9/1.
//  Copyright © 2015年 zhangchun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlocksKit+UIKit.h"

@interface Helper : NSObject

/**
 * 检查系统"照片"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkPhotoLibraryAuthorizationStatus;

/**
 * 检查系统"相机"授权状态, 如果权限被关闭, 提示用户去隐私设置中打开.
 */
+ (BOOL)checkCameraAuthorizationStatus;

//查找文字在数组的位置
+ (NSNumber *)indexOfFirst:(NSString *)firstLevelName firstLevelArray:(NSArray *)firstLevelArray;
@end
