//
//  MPCodeStarndardCoping.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPCodeStarndardCoping.h"

@interface MPCodeStarndardCoping()

@property(nonatomic,copy,readwrite)NSString *userName;
@property(nonatomic,copy,readwrite)NSString *address;
@property(nonatomic,strong,readwrite)NSMutableArray *carMutableList;

@end

@implementation MPCodeStarndardCoping

-(NSArray *)carList
{
    return [_carMutableList copy];
}

-(instancetype)initWithUserName:(NSString *)userName withAddress:(NSString *)address
{
    if (self=[super init]) {
        _userName=[userName copy];
        _address=[address copy];
        _carMutableList=[NSMutableArray new];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    MPCodeStarndardCoping *copy=[[[self class]allocWithZone:zone] initWithUserName:_userName withAddress:_address];
    _carMutableList=[[NSMutableArray alloc] initWithArray:_carMutableList copyItems:YES];
    return copy;
}

@end
