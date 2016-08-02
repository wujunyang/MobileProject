//
//  LoggerDetailViewController.h
//  MobileProject  日志详细内容查看
//
//  Created by wujunyang on 16/1/27.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface LoggerDetailViewController : UIViewController

- (id)initWithLog:(NSString *)logText forDateString:(NSString *)logDate;

@end
