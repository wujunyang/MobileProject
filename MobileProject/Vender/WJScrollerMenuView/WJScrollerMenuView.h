//
//  WJScrollerMenuView.h
//  MobileProject
//
//使用
//    WJScrollerMenuView *vc=[[WJScrollerMenuView alloc]initWithFrame:CGRectMake(0, 64, 320, 50) showArrayButton:NO];
//WJScrollerMenuView *vc=[[WJScrollerMenuView alloc]initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 50) showArrayButton:YES];
//vc.delegate=self;
//vc.backgroundColor=[UIColor greenColor];
//vc.selectedColor=[UIColor blueColor];
//vc.noSlectedColor=[UIColor blackColor];
//vc.myTitleArray=@[@"第一阶段",@"第二阶段",@"第三阶段",@"第四阶段",@"第五阶段"];
//vc.currentIndex=0;
//[self.view addSubview:vc];
//  Created by wujunyang on 16/1/22.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJPopupMenuView.h"

@protocol WJScrollerMenuDelegate <NSObject>

@optional

- (void)itemDidSelectedWithIndex:(NSInteger)index;



@end


@interface WJScrollerMenuView : UIView
@property (nonatomic, weak) id  <WJScrollerMenuDelegate>delegate;
//菜单名称数组
@property(nonatomic,copy)NSArray *myTitleArray;
//选中菜单时的文字颜色
@property(nonatomic,strong)UIColor *selectedColor;
//未选中菜单的文字颜色
@property(nonatomic,strong)UIColor *noSlectedColor;
//文字的字体
@property(nonatomic,strong)UIFont *titleFont;
//下划线的颜色
@property(nonatomic,strong)UIColor *LineColor;
//当前选中的索引值
@property (nonatomic, assign) NSInteger currentIndex;


- (instancetype)initWithFrame:(CGRect)frame showArrayButton:(BOOL)yesOrNo;

@end
