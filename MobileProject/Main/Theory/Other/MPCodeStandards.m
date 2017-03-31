//
//  MPCodeStandards.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPCodeStandards.h"

@interface MPCodeStandards()
@property(nonatomic,copy,readwrite)NSString *userName;
@property(nonatomic,assign,readwrite)NSInteger age;
@property(nonatomic,strong,readwrite)NSMutableArray *myMutableWorkList;
@end

//内部进行赋值
NSString *const MPErrorDomain=@"MPErrorDomain";

@implementation MPCodeStandards

-(NSArray *)workList
{
    return [self.myMutableWorkList copy];
}

-(instancetype)init
{
    return [self initWithUserName:@""];
}

-(instancetype)initWithUserName:(NSString *)userName
{
    return [self initWithUserName:userName andAge:0];
}

-(instancetype)initWithUserName:(NSString *)userName withError:(NSError **)error
{
    *error=nil;
    if (userName.length==0) {
        *error=[NSError errorWithDomain:MPErrorDomain code:MPErrorBadInput userInfo:@{@"errorInfo":@"当前没有输入用户名"}];
    }
    return [self initWithUserName:userName andAge:0];
}

//最底层的初始化 其它初始化都调用这个
-(instancetype)initWithUserName:(NSString *)userName andAge:(NSInteger)age
{
    if (self=[super init]) {
        _userName=[userName copy];
        _age=age;
        _myMutableWorkList=[NSMutableArray new];
    }
    return self;
}

-(void)addWork:(NSString *)workName
{
    [_myMutableWorkList addObject:workName];
}

-(void)removeWork:(NSString *)workName
{
    [_myMutableWorkList removeObject:workName];
}


//私有方法的定义 可以在名字上有所区别开 比如以p_开头
-(void)p_changeUserName
{
    if (_userName.length>0) {
        _userName=[NSString stringWithFormat:@"MP-%@",_userName];
    }
}

// 重写打印内容 代码打印NSLog(@"当前信息：%@",codeStandards); 只会 打印codeStandards.description
- (NSString *)description
{
    return [NSString stringWithFormat:@"当前用户：%@ 年龄：%ld 工作：%@",_userName,_age,_myMutableWorkList];
}

//可以在lldb调试时 po codeStandards 会打印codeStandards.debugDescription
- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@-%p>当前用户：%@ 年龄：%ld 工作：%@",[self class],self,_userName,_age,_myMutableWorkList];
}

@end
