//
//  MPAllModel.h
//  MobileProject
//
//  Created by wujunyang on 2017/2/7.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPAllModel : JSONModel

@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic)int age;
@property(nonatomic)float price;
@property(nonatomic,strong)NSNumber *isShow;
@property(nonatomic,assign)BOOL isError;
@property(nonatomic,strong)NSArray *itemArray;
@property(nonatomic,strong)NSArray<Optional> *dataArray;
@end
