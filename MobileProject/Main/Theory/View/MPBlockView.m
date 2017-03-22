//
//  MPBlockView.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPBlockView.h"

@interface MPBlockView()

@property(nonatomic,copy)blockViewErrorHandle myErrorBlock;

@end

@implementation MPBlockView

-(instancetype)initWithErrorBlcok:(blockViewErrorHandle)errorBlock
{
    if (self=[super init]) {
        
        _myErrorBlock=errorBlock;
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

-(instancetype)initWithNoClearErrorBlock:(blockViewErrorHandle)errorBlock
{
    if (self=[super init]) {
        
        _myErrorBlock=errorBlock;
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleNoClearSingleTap:)];
        
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    if (self.myErrorBlock) {
        self.myErrorBlock(@"调用block里面不用做处理，已经在调用block里面清空的block,打破循环");
        [self clearBlock];
    }
}

-(void)handleNoClearSingleTap:(UITapGestureRecognizer *)sender
{
    if (self.myErrorBlock) {
        self.myErrorBlock(@"记得调用地方block里要清空MPBlockView对象，打破循环");
    }
}

-(void)clearBlock
{
    self.myErrorBlock=nil;
}

@end
