//
//  MPCodeStandards.h
//  MobileProject  代码规划写法
//
//  Created by wujunyang on 2017/2/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPCodeStandards : NSObject

//只读属性
@property(nonatomic,copy,readonly)NSString *userName;
@property(nonatomic,assign,readonly)NSInteger age;
//不可变 防止不同地方写入读取不同步
@property(nonatomic,strong,readonly)NSArray *workList;


-(instancetype)initWithUserName:(NSString *)userName;
-(instancetype)initWithUserName:(NSString *)userName andAge:(NSInteger)age;

-(void)addWork:(NSString *)workName;
-(void)removeWork:(NSString *)workName;

@end
