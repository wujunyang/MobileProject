//
//  MPChildBlockViewController.h
//  MobileProject
//
//  Created by wujunyang on 2017/3/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MPChildBlockViewController : BaseViewController

@property(nonatomic,copy) void(^successBlock)();

@end
