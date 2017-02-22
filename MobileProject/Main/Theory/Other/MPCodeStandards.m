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

@implementation MPCodeStandards

-(NSArray *)workList
{
    return [self.myMutableWorkList copy];
}

-(instancetype)initWithUserName:(NSString *)userName
{
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
