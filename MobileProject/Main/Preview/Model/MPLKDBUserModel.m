//
//  MPLKDBUserModel.m
//  MobileProject
//
//  Created by wujunyang on 16/7/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPLKDBUserModel.h"

@implementation MPLKDBUserModel

+(void)initialize
{
    [self removePropertyWithColumnName:@"error"];
}

/**
 *  @author wjy, 15-01-27 18:01:53
 *
 *  @brief  是否将父实体类的属性也映射到sqlite库表
 *  @return BOOL
 */
+(BOOL) isContainParent{
    return YES;
}
/**
 *  @author wjy, 15-01-26 14:01:01
 *
 *  @brief  设定表名
 *  @return 返回表名
 */
+(NSString *)getTableName
{
    return @"userBean";
}
/**
 *  @author wjy, 15-01-26 14:01:22
 *
 *  @brief  设定表的单个主键
 *  @return 返回主键表
 */
+(NSString *)getPrimaryKey
{
    return @"ID";
}

@end
