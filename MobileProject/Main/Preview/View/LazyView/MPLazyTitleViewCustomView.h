//
//  MPLazyTitleViewCustomView.h
//  MobileProject
//
//  Created by wujunyang on 2017/4/2.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMMuiLazyScrollView.h"

@interface MPLazyTitleViewCustomView : UIView<TMMuiLazyScrollViewCellProtocol>

-(instancetype)initWithTitle:(NSString *)title;

@end
