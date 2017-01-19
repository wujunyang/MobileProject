//
//  MPNavView.h
//  MobileProject
//
//  Created by wujunyang on 2017/1/19.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NaViewDelegate <NSObject>
@optional
- (void)NaLeft;
- (void)NaRight;
@end

@interface MPNavView : UIView

@property(nonatomic,assign)id<NaViewDelegate>delegate;
@property(nonatomic,strong)UIImageView * headBackView;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)UIColor * color;
@property(nonatomic,strong)NSString * left_bt_Image;
@property(nonatomic,strong)NSString * right_bt_Image;

@end
