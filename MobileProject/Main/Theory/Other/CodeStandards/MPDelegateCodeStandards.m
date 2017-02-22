//
//  MPDelegateCodeStandards.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPDelegateCodeStandards.h"

@interface MPDelegateCodeStandards()
@property(nonatomic,copy,readwrite)NSString *userName;
@end

@implementation MPDelegateCodeStandards

-(instancetype)init
{
    return [self initWithUserName:@""];
}

-(instancetype)initWithUserName:(NSString *)userName
{
    if (self=[super init]) {
        _userName=[userName copy];
    }
    return self;
}

-(NSString *)changeUserName:(NSInteger)index
{
    NSString *curName=nil;
    if ([_delegate respondsToSelector:@selector(selectIndexFetcher:withIndex:)]) {
        curName=[_delegate selectIndexFetcher:self withIndex:index];
    }
    return curName;
}

-(void)getUserAddressWithName:(NSString *)name
{
    if ([_delegate respondsToSelector:@selector(networkFetcher:didReceiveName:)]) {
        [_delegate networkFetcher:self didReceiveName:name];
    }
}

@end
