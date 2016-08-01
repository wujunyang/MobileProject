//
//  MPReduceTimeCell.h
//  MobileProject 倒计时Cell
//
//  Created by wujunyang on 16/8/1.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MPReduceTimeState)
{
    MPReduceTimeStateNotStart = 0,
    MPReduceTimeStateIng,
    MPReduceTimeStateEnd,
};


@interface MPReduceTimeCell : UITableViewCell

-(void)configCellWithImage:(NSString *)imageName name:(NSString *)name;

-(void)configCellState:(MPReduceTimeState)reduceTimeState currentTime:(NSString *)currentTime;

@end
