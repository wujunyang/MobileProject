//
//  BaseViewController.h
//  MobileProject 基控制器
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Color.h"

@protocol  BBBaseViewControllerDataSource<NSObject>

-(NSMutableAttributedString*)setTitle;
-(UIButton*)set_leftButton;
-(UIButton*)set_rightButton;
-(UIColor*)set_colorBackground;
-(CGFloat)set_navigationHeight;
-(UIView*)set_bottomView;
-(UIImage*)navBackgroundImage;
-(UIImage*)set_leftBarButtonItemWithImage;
-(UIImage*)set_rightBarButtonItemWithImage;
@end


@protocol BBBaseViewControllerDelegate <NSObject>

@optional
-(void)left_button_event:(UIButton*)sender;
-(void)right_button_event:(UIButton*)sender;
-(void)title_click_event:(UIView*)sender;
@end

@interface BaseViewController : UIViewController<BBBaseViewControllerDataSource , BBBaseViewControllerDelegate>

-(void)setContentAlpha:(CGFloat)alpha;
-(void)changeNavigationBarHeight:(CGFloat)offset;
-(void)changeNavigationBarTranslationY:(CGFloat)translationY;
-(void)set_Title:(NSMutableAttributedString *)title;
@end
