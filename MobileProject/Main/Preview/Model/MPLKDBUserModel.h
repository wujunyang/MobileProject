//
//  MPLKDBUserModel.h
//  MobileProject
//
//  Created by wujunyang on 16/7/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LKDBHelper/LKDBHelper.h>

@interface MPLKDBUserModel : NSObject

@property(assign,nonatomic)int ID;
@property(strong,nonatomic)NSString *userName;
@property(strong,nonatomic)NSString *password;

@end
