//
//  MPAdaptationCell.h
//  MobileProject 适配字体CELL
//
//  Created by wujunyang on 16/7/26.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Size.h"

@interface MPAdaptationCell : UITableViewCell

-(void)configCellWithText:(NSString *)text dateText:(NSString *)dateText;

+(CGFloat)cellHegith:(NSString *)text;

@end
