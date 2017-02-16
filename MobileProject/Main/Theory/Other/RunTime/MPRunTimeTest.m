//
//  MPRunTimeTest.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/9.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPRunTimeTest.h"

@interface MPRunTimeTest()
{
    int _UserAge;
}
@end


@implementation MPRunTimeTest


+(void)showAddressInfo
{
    NSLog(@"当前地址为:厦门市");
}

-(NSString *)showUserName:(NSString *)name
{
    return [NSString stringWithFormat:@"user name is %@",name];
}




//NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder

{
    unsigned int count = 0;
    
    Ivar *ivars = class_copyIvarList([MPRunTimeTest class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        
        const char *name = ivar_getName(ivar);
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [encoder encodeObject:value forKey:key];
        
    }
    
    free(ivars);
    
    
}

- (id)initWithCoder:(NSCoder *)decoder

{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([MPRunTimeTest class], &count);
        for (int i = 0; i<count; i++) {
            // 取出i位置对应的成员变量
            Ivar ivar = ivars[i];
            // 查看成员变量
            const char *name = ivar_getName(ivar);
            // 归档
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [decoder decodeObjectForKey:key];
            // 设置到成员变量身上
            [self setValue:value forKey:key];
            
        }
        free(ivars);
        
    }
    
    return self;
    
}

@end
