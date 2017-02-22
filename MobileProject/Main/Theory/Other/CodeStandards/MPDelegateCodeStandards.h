//
//  MPDelegateCodeStandards.h
//  MobileProject
//  @required的部份是規定要實作的(默认)，@optional的話就隨你高興了。要注意的是@required跟@optional這兩個語法的影響範圍，是從它以下所有的method都會被影響，直到另一個directive或是@end為止，所以如果你要省略@required的話，記得那些method要寫在@optional前面
//
//  Created by wujunyang on 2017/2/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPDelegateCodeStandards;

@protocol MPCodeStandardsDelegate <NSObject>

@required
-(void)networkFetcher:(MPDelegateCodeStandards *)codestandards didReceiveName:(NSString *)name;

-(NSString *)selectIndexFetcher:(MPDelegateCodeStandards *)codestandards withIndex:(NSInteger)index;

@optional
-(void)networkFetcher:(MPDelegateCodeStandards *)codestandards didFaileWithError:(NSError *)error;

@end

@interface MPDelegateCodeStandards : NSObject

@property(nonatomic,weak)id <MPCodeStandardsDelegate> delegate;

@property(nonatomic,copy,readonly)NSString *userName;

-(instancetype)initWithUserName:(NSString *)userName;

-(NSString *)changeUserName:(NSInteger)index;

-(void)getUserAddressWithName:(NSString *)name;

@end
