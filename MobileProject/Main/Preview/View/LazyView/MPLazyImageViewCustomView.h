//
//  MPLazyImageViewCustomView.h
//  MobileProject
//
//  Created by wujunyang on 2017/4/2.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMMuiLazyScrollView.h"

@interface MPLazyImageViewCustomView : UIView<TMMuiLazyScrollViewCellProtocol>

@property(nonatomic,copy)NSString *imageName;

@end
