//
//  MPEmployee.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/23.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPEmployee.h"

#import "MPEmployeeFinance.h"
#import "MPEmployeeDesigner.h"
#import "MPEmployeeDeveloper.h"

@implementation MPEmployee

+(MPEmployee *)employeeWithType:(MPEmployeeType)type
{
    switch (type) {
        case MPEmployeeTypeDeveloper:
            return [MPEmployeeDeveloper new];
            break;
        case MPEmployeeTypeDesigner:
            return [MPEmployeeDesigner new];
            break;
        case MPEmployeeTypeFinance:
            return [MPEmployeeFinance new];
            break;
    }
}

//子类去实现内容
-(void)doADaysWork
{
    
}

@end
