//
//  MPClearCacheTool.m
//  MobileProject
//
//  Created by wujunyang on 2017/5/10.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPClearCacheTool.h"

#define fileManager [NSFileManager defaultManager]

@implementation MPClearCacheTool

//获取path路径下文件夹大小
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path
{
    
    //调试
#ifdef DEBUG
    //如果文件夹不存在或者不是一个文件夹那么就抛出一个异常
    //抛出异常会导致程序闪退，所以只在调试阶段抛出，发布阶段不要再抛了,不然极度影响用户体验
    BOOL isDirectory = NO;
    BOOL isExist = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
    if (!isExist || !isDirectory)
    {
        NSException *exception = [NSException exceptionWithName:@"fileError" reason:@"please check your filePath!" userInfo:nil];
        [exception raise];
        
    }
    NSLog(@"debug");
    //发布
#else
    NSLog(@"post");
#endif
    
    //获取“path”文件夹下面的所有文件
    NSArray *subpathArray= [fileManager subpathsAtPath:path];
    
    NSString *filePath = nil;
    NSInteger totleSize=0;
    
    for (NSString *subpath in subpathArray)
    {
        //拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subpath];
        
        //isDirectory，是否是文件夹，默认不是
        BOOL isDirectory = NO;
        
        //isExist，判断文件是否存在
        BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        //判断文件是否存在，不存在的话过滤
        //如果存在的话，那么是否是文件夹，是的话也过滤
        //如果文件既存在又不是文件夹，那么判断它是不是隐藏文件，是的话也过滤
        //过滤以上三个情况后，就是一个文件夹里面真实的文件的总大小
        //以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]) continue;
        //NSLog(@"%@",filePath);
        //指定路径，获取这个路径的属性
        //attributesOfItemAtPath:需要传文件夹路径
        //但是attributesOfItemAtPath 只可以获得文件属性，不可以获得文件夹属性，这个也就是需要for-in遍历文件夹里面每一个文件的原因
        NSDictionary *dict=   [fileManager attributesOfItemAtPath:filePath error:nil];
        
        NSInteger size=[dict[@"NSFileSize"] integerValue];
        totleSize+=size;
    }
    
    //将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    
    if (totleSize > 1000 * 1000)
    {
        totleStr = [NSString stringWithFormat:@"%.1fM",totleSize / 1000.0f /1000.0f];
    }else if (totleSize > 1000)
    {
        totleStr = [NSString stringWithFormat:@"%.1fKB",totleSize / 1000.0f ];
        
    }else
    {
        totleStr = [NSString stringWithFormat:@"%.1fB",totleSize / 1.0f];
    }
    
    return totleStr;
    
    
}


//清除path文件夹下缓存大小
+ (BOOL)clearCacheWithFilePath:(NSString *)path
{
    
    //拿到path路径的下一级目录的子文件夹
    NSArray *subpathArray = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    NSString *message = nil;
    NSError *error = nil;
    NSString *filePath = nil;
    
    for (NSString *subpath in subpathArray)
    {
        filePath =[path stringByAppendingPathComponent:subpath];
        //删除子文件夹
        [fileManager removeItemAtPath:filePath error:&error];
        if (error) {
            message = [NSString stringWithFormat:@"%@这个路径的文件夹删除失败了，请检查后重新再试",filePath];
            return NO;
            
        }else {
            message = @"成功了";
        }
        
    }
    NSLog(@"%@",message);
    
    return YES;
    
}


@end
