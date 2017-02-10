//
//  UIAlertView+MPBlock.h
//  MobileProject 针对block进行关联 增加其操作封装
//
//  Created by wujunyang on 2017/2/10.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^successBlock)(NSInteger buttonIndex);

@interface UIAlertView (MPBlock)

- (void)showWithBlock:(successBlock)block;

@end
