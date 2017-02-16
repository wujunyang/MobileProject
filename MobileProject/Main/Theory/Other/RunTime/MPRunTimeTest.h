//
//  MPRunTimeTest.h
//  MobileProject
//
//  Created by wujunyang on 2017/2/9.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MPRunTimeTest : NSObject<NSCopying>
{
    NSString *_schoolName;
}

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *address;


+(void)showAddressInfo;

-(NSString *)showUserName:(NSString *)name;

@end
