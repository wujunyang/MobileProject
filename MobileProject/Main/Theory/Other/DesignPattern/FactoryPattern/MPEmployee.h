//
//  MPEmployee.h  工厂模式 根据不同的类型去实例化不同的实现方式
//  MobileProject
//
//运用
//MPEmployee *employee=[MPEmployee employeeWithType:MPEmployeeTypeDesigner];
//[employee doADaysWork];
//我是一员设计师
//
//  Created by wujunyang on 2017/2/23.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,MPEmployeeType) {
    MPEmployeeTypeDeveloper,
    MPEmployeeTypeDesigner,
    MPEmployeeTypeFinance
};


@interface MPEmployee : NSObject

@property(copy) NSString *name;
@property NSUInteger salary;

+(MPEmployee *)employeeWithType:(MPEmployeeType)type;

//子类去实现内容
-(void)doADaysWork;

@end
