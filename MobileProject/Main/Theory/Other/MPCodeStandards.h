//
//  MPCodeStandards.h
//  MobileProject  代码规划写法
//
//MPCodeStandards *codeStandards=[[MPCodeStandards alloc]initWithUserName:@"wujunyang" andAge:2];
//[codeStandards addWork:@"编程"];
//[codeStandards addWork:@"洗碗"];
//NSLog(@"当前名字：%@",codeStandards.userName);
//NSLog(@"当前信息：%@",codeStandards);
//[codeStandards removeWork:@"洗碗"];
//
//NSError *error=nil;
//MPCodeStandards *twoCodeStandards=[[MPCodeStandards alloc] initWithUserName:@"" withError:&error];
//if (error) {
//    NSLog(@"twoCodeStandards出现ERROR");
//    NSLog(@"%@,%ld,%@",error.domain,error.code,error.userInfo);
//}
//NSLog(@"当前信息：%@",twoCodeStandards);
//
//
//  Created by wujunyang on 2017/2/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//



#import <Foundation/Foundation.h>

//定义一个错误的内部 外面可以调用的MPErrorDomain
extern NSString *const MPErrorDomain;
//定义一个枚举
typedef NS_ENUM(NSUInteger,MPError){
    MPErrorUnknown=-1,
    MPErrorGeneralFault=100,
    MPErrorBadInput=101,
};

@interface MPCodeStandards : NSObject

//只读属性
@property(nonatomic,copy,readonly)NSString *userName;
@property(nonatomic,assign,readonly)NSInteger age;
//不可变 防止不同地方写入读取不同步
@property(nonatomic,strong,readonly)NSArray *workList;

//初始化方法
-(instancetype)initWithUserName:(NSString *)userName;
-(instancetype)initWithUserName:(NSString *)userName withError:(NSError **)error;
-(instancetype)initWithUserName:(NSString *)userName andAge:(NSInteger)age;

-(void)addWork:(NSString *)workName;
-(void)removeWork:(NSString *)workName;

@end
