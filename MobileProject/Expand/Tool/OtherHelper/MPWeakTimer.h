//
//  MPWeakTimer.h   破坏nstimer内存泄露的问题
//  MobileProject
//
//使用说明：就可以在dealloc里面进行invalidate
//#import "HWWeakTimer.h"
//
//@interface DetailViewController ()
//@property (nonatomic, weak) NSTimer *timer;
//
//@end
//
//@implementation DetailViewController
//
//- (IBAction)fireButtonPressed:(id)sender {
//    _timer = [HWWeakTimer scheduledTimerWithTimeInterval:3.0f block:^(id userInfo) {
//        NSLog(@"%@", userInfo);
//    } userInfo:@"Fire" repeats:YES];
//    [_timer fire];
//}
//
//- (IBAction)invalidateButtonPressed:(id)sender {
//    [_timer invalidate];
//}
//
//-(void)dealloc {
//    [_timer invalidate];
//    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
//}
//
//@end
//
//  Created by wujunyang on 2017/5/12.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MPTimerHandler)(id userInfo);

@interface MPWeakTimer : NSObject

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(MPTimerHandler)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;

@end
