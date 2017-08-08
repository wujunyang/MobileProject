//
//  MPDatePickerView.h
//  MobileProject
//
//  Created by wujunyang on 2017/8/7.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectDateBlock)(NSDate *selectDate);

typedef void(^cancelBlock)();

@interface MPDatePickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

-(instancetype)initWithTitle:(NSString *)title selectedDate:(NSDate *)selectedDate minimumDate:(NSDate *)minimumDate maximumDate:(NSDate *)maximumDate doneBlock:(selectDateBlock)doneBlock cancelBlock:(cancelBlock)cancelBlock;

@end
