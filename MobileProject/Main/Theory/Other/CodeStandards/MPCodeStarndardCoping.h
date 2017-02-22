//
//  MPCodeStarndardCoping.h
//  MobileProject  浅 深拷贝
//
//浅拷贝 深拷贝
//MPCodeStarndardCoping *codeStarndardCopint=[[MPCodeStarndardCoping alloc]initWithUserName:@"wujunyang" withAddress:@"厦门市"];
//NSLog(@"codeStarndardCopint %p",codeStarndardCopint);
//MPCodeStarndardCoping *twoCodeStarndardCopint=codeStarndardCopint;
//NSLog(@"twoCodeStarndardCopint %p",twoCodeStarndardCopint);
////输出：
////codeStarndardCopint 0x600000227f40
////twoCodeStarndardCopint 0x600000227f40
//MPCodeStarndardCoping *threeCodeStarndardCopint=[codeStarndardCopint copy];
//NSLog(@"threeCodeStarndardCopint %p",threeCodeStarndardCopint);
////threeCodeStarndardCopint 0x60800022be20

//  Created by wujunyang on 2017/2/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPCodeStarndardCoping : NSObject<NSCopying>

@property(nonatomic,copy,readonly)NSString *userName;
@property(nonatomic,copy,readonly)NSString *address;
@property(nonatomic,copy,readonly)NSArray *carList;

-(instancetype)initWithUserName:(NSString *)userName withAddress:(NSString *)address;

@end
