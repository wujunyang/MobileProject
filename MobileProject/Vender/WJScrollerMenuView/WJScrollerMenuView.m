//
//  WJScrollerMenuView.m
//  MobileProject
//
//  Created by wujunyang on 16/1/22.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "WJScrollerMenuView.h"

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define ARROW_BUTTON_WIDTH 44

@interface WJScrollerMenuView()<WJPopupMenuViewDelegate>
//滚动视图
@property(strong,nonatomic)UIScrollView *myScrollView;
//滚动下划线
@property(strong,nonatomic)UIView *line;
//所有的Button集合
@property(nonatomic,strong)NSMutableArray  *items;
//所有的Button的宽度集合
@property(nonatomic,copy)NSArray *itemsWidth;
//被选中前面的宽度合（用于计算是否进行超过一屏，没有一屏则进行平分）
@property(nonatomic,assign)CGFloat selectedTitlesWidth;
//滚动视图的宽
@property(nonatomic,assign)CGFloat navigationTabBarWidth;
//是否显示右边更多的Button
@property(nonatomic,assign)BOOL showArrayButton;

@property(nonatomic,strong)WJPopupMenuView *PopupView;
@end

@implementation WJScrollerMenuView


- (instancetype)initWithFrame:(CGRect)frame showArrayButton:(BOOL)yesOrNo
{
    if (self = [super initWithFrame:frame]) {
        _showArrayButton = yesOrNo;
        [self loadDataAndView];
    }
    return self;
}

-(void)loadDataAndView
{
    //初始化数组
    self.items=[[NSMutableArray alloc]init];
    
    self.itemsWidth=[[NSArray alloc]init];

    self.selectedColor=[UIColor whiteColor];
    
    self.noSlectedColor=[UIColor blackColor];

    self.LineColor=[UIColor blueColor];

    self.titleFont=[UIFont systemFontOfSize:15.f];
    
    _navigationTabBarWidth = _showArrayButton ? self.bounds.size.width - ARROW_BUTTON_WIDTH : self.bounds.size.width;
    
    CGRect myScrollViewRect=self.bounds;
    myScrollViewRect.size.width=_navigationTabBarWidth;
    
    //初始化滚动
    if (!self.myScrollView) {
        self.myScrollView=[[UIScrollView alloc]initWithFrame:myScrollViewRect];
        self.myScrollView.backgroundColor=self.backgroundColor;
        self.myScrollView.showsHorizontalScrollIndicator = NO;
        self.myScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.myScrollView];
    }
    if (_showArrayButton) {
        UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        arrowButton.frame = CGRectMake(_navigationTabBarWidth, 0, ARROW_BUTTON_WIDTH, self.bounds.size.height);
        arrowButton.backgroundColor = self.backgroundColor;
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"btn_navigation_close"] forState:UIControlStateNormal];
        [arrowButton addTarget:self action:@selector(arrowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:arrowButton];
    }
}

/**
 *  @author wujunyang, 16-01-22 13:01:45
 *
 *  @brief  计算宽度
 *
 *  @param titles <#titles description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    _selectedTitlesWidth = 0;
    for (NSString *title in titles)
    {
        CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleFont} context:nil].size;
        CGFloat eachButtonWidth = size.width + 20.f;
        _selectedTitlesWidth += eachButtonWidth;
        NSNumber *width = [NSNumber numberWithFloat:eachButtonWidth];
        [widths addObject:width];
    }
    if (_selectedTitlesWidth < self.navigationTabBarWidth) {
        [widths removeAllObjects];
        NSNumber *width = [NSNumber numberWithFloat:self.navigationTabBarWidth/ titles.count];
        for (int index = 0; index < titles.count; index++) {
            [widths addObject:width];
        }
    }
    return widths;
}
/**
 *  @author wujunyang, 16-01-22 13:01:14
 *
 *  @brief  初始化Button
 *
 *  @param widths <#widths description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    [self cleanData];
    CGFloat buttonX = 0;
    for (NSInteger index = 0; index < widths.count; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, 0, [widths[index] floatValue], self.bounds.size.height);
        button.titleLabel.font = self.titleFont;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:self.myTitleArray[index] forState:UIControlStateNormal];
        [button setTitleColor:self.noSlectedColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.myScrollView addSubview:button];
        
        [_items addObject:button];
        buttonX += [widths[index] floatValue];
    }
    if (widths.count) {
        [self showLineWithButtonWidth:[widths[0] floatValue]];
    }
    return buttonX;
}

/**
 *  @author wujunyang, 16-01-22 13:01:33
 *
 *  @brief  选中
 *
 *  @param currentIndex 选中索引
 *
 *  @since <#version number#>
 */
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (_items.count>0) {
        _currentIndex = currentIndex;
        UIButton *button = nil;
        button = _items[currentIndex];
        [button setTitleColor:self.selectedColor forState:UIControlStateNormal];
        CGFloat offsetX = button.center.x - self.navigationTabBarWidth * 0.5;
        CGFloat offsetMax = _selectedTitlesWidth - self.navigationTabBarWidth;
        if (offsetX < 0 || offsetMax < 0) {
            offsetX = 0;
        } else if (offsetX > offsetMax){
            offsetX = offsetMax;
        }
        [self.myScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        [UIView animateWithDuration:.2f animations:^{
            _line.frame = CGRectMake(button.frame.origin.x + 2.0f, _line.frame.origin.y, [_itemsWidth[currentIndex] floatValue] - 4.0f, _line.frame.size.height);
        }];
    }
}

-(void)setMyTitleArray:(NSArray *)myTitleArray
{
    _myTitleArray=myTitleArray;
    _itemsWidth = [self getButtonsWidthWithTitles:myTitleArray];
    CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
    self.myScrollView.contentSize = CGSizeMake(contentWidth, 0);
}

/**
 *  @author wujunyang, 16-01-22 13:01:47
 *
 *  @brief  增加下划线
 *
 *  @param width Button的宽
 *
 *  @since <#version number#>
 */
- (void)showLineWithButtonWidth:(CGFloat)width
{
    _line = [[UIView alloc] initWithFrame:CGRectMake(2.0f, self.bounds.size.height - 3.0f, width - 4.0f, 3.0f)];
    _line.backgroundColor = self.LineColor;
    [self.myScrollView addSubview:_line];
}

- (void)cleanData
{
    [_items removeAllObjects];
    [self.myScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

/**
 *  @author wujunyang, 16-01-22 11:01:27
 *
 *  @brief  选中时的事件
 *
 *  @param button <#button description#>
 *
 *  @since <#version number#>
 */
- (void)itemPressed:(UIButton *)button
{
    NSInteger index = [_items indexOfObject:button];
    [self curSelectedIndex:index];
    
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            button.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            
        }];
    }];
}

-(void)curSelectedIndex:(NSInteger)index
{
    self.currentIndex=index;
    
    if ([self.delegate respondsToSelector:@selector(itemDidSelectedWithIndex:)]) {
        [self.delegate itemDidSelectedWithIndex:index];
    }
    
    //修改选中跟没选中的Button字体颜色
    for (int i=0; i<_items.count; i++) {
        [_items[i] setTitleColor:(i==index)?self.selectedColor:self.noSlectedColor forState:UIControlStateNormal];
    }
    
    //如果有弹出窗就进行关闭
    if (_PopupView) {
        [_PopupView dismiss];
        _PopupView = nil;
    }
}


- (void)arrowBtnClick:(UIButton *)button
{
    CGRect rc =self.frame;
    if (!_PopupView) {
        _PopupView = [[WJPopupMenuView alloc]initWithTitles];
        _PopupView.titles = self.myTitleArray;
        _PopupView.selectIndex = self.currentIndex;
        _PopupView.selectedColor=self.selectedColor;
        _PopupView.noSlectedColor=self.noSlectedColor;
        _PopupView.delegate = self;
        [_PopupView show:self Poprect:rc];
    }
    else
    {
        [_PopupView dismiss];
        _PopupView = nil;
    }
}


#pragma mark --ZCPopupMenuViewDelegate
-(void)didSelectIdex:(NSInteger)idex
{
    [self curSelectedIndex:idex];
    [_PopupView dismiss];
    _PopupView = nil;
    
}

-(void)dimiss_popUp
{
    [_PopupView dismiss];
    _PopupView = nil;
}
@end
