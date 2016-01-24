//
//  WJPopupMenuView.h
//  MobileProject
//
//  Created by wujunyang on 16/1/24.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJIndicatorView.h"

@protocol WJPopupMenuViewDelegate <NSObject>

-(void)didSelectIdex:(NSInteger)idex;
-(void)dimiss_popUp;
@end

@interface WJPopupMenuView : UIView
@property(nonatomic,weak)id<WJPopupMenuViewDelegate>delegate;
@property(nonatomic,assign)NSInteger selectIndex;
@property(nonatomic ,strong)NSArray *titles;
@property(nonatomic,readonly)BOOL isShow;
//选中菜单时的文字颜色
@property(nonatomic,strong)UIColor *selectedColor;
//未选中菜单的文字颜色
@property(nonatomic,strong)UIColor *noSlectedColor;

-(id)initWithTitles;
-(void)show:(UIView*)contentView Poprect:(CGRect)rect;
-(void)dismiss;
@end
