//
//  BaseViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    CGFloat navigationY;
    CGFloat navBarY;
    CGFloat verticalY;
    BOOL _isShowMenu;
    
}
@property CGFloat original_height;
@property(nonatomic ,strong)UIView *overlay;

@end

@implementation BaseViewController

-(id)init
{
    if (self == [super init]) {
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController setNavigationBarHidden:YES];
        navBarY = 0;
        navigationY = 0;
        
        
    }
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(backgroundImage)]) {
        UIImage *bgimage = [self navBackgroundImage];
        [self setNavigationBack:bgimage];
    }
    if ([self respondsToSelector:@selector(setTitle)]) {
        NSMutableAttributedString *titleAttri = [self setTitle];
        [self set_Title:titleAttri];
    }
    if (![self leftButton]) {
        [self configLeftBaritemWithImage];
    }
    
    if (![self rightButton]) {
        [self configRightBaritemWithImage];
    }
    
    //去掉系统自带的黑边
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:NO];
    if ([self respondsToSelector:@selector(set_colorBackground)]) {
        UIColor *backgroundColor =  [self set_colorBackground];
        UIImage *bgimage = [UIImage imageWithColor:backgroundColor];
        
        //if (!self.overlay) {
        [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.navigationController.navigationBar.bounds) + 20)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.navigationController.navigationBar insertSubview:self.overlay atIndex:0];
        //}
        self.overlay.backgroundColor = backgroundColor;
        
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)setNavigationBack:(UIImage*)image
{
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:image ];
    [self.navigationController.navigationBar setShadowImage:image];
}

#pragma mark --- NORMAl

-(void)set_Title:(NSMutableAttributedString *)title
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.numberOfLines=0;//可能出现多行的标题
    [label setAttributedText:title];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
    [label addGestureRecognizer:tap];
    self.navigationItem.titleView = label;
    
}


-(void)titleClick:(UIGestureRecognizer*)Tap
{
    
    UIView *view = Tap.view;
    if ([self respondsToSelector:@selector(title_click_event:)]) {
        [self title_click_event:view];
    }
}

#pragma mark -- left_item
-(void)configLeftBaritemWithImage
{
    if ([self respondsToSelector:@selector(set_leftBarButtonItemWithImage)]) {
        UIImage *image = [self set_leftBarButtonItemWithImage];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleBordered target:self  action:@selector(left_click:)];
        self.navigationItem.backBarButtonItem = item;
    }
}

-(void)configRightBaritemWithImage
{
    if ([self respondsToSelector:@selector(set_rightBarButtonItemWithImage)]) {
        UIImage *image = [self set_rightBarButtonItemWithImage];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleBordered target:self  action:@selector(right_click:)];
        self.navigationItem.rightBarButtonItem = item;
    }
}


#pragma mark -- left_button
-(BOOL)leftButton
{
    BOOL isleft =  [self respondsToSelector:@selector(set_leftButton)];
    if (isleft) {
        UIButton *leftbutton = [self set_leftButton];
        [leftbutton addTarget:self action:@selector(left_click:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
        self.navigationItem.leftBarButtonItem = item;
    }
    return isleft;
}

#pragma mark -- right_button
-(BOOL)rightButton
{
    BOOL isright = [self respondsToSelector:@selector(set_rightButton)];
    if (isright) {
        UIButton *right_button = [self set_rightButton];
        [right_button addTarget:self action:@selector(right_click:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:right_button];
        self.navigationItem.rightBarButtonItem = item;
    }
    return isright;
}


-(void)left_click:(id)sender
{
    if ([self respondsToSelector:@selector(left_button_event:)]) {
        [self left_button_event:sender];
    }
}

-(void)right_click:(id)sender
{
    if ([self respondsToSelector:@selector(right_button_event:)]) {
        [self right_button_event:sender];
    }
}

-(void)changeNavigationBarHeight:(CGFloat)offset
{
    [UIView animateWithDuration:0.3f animations:^{
        self.navigationController.navigationBar.frame  = CGRectMake(
                                                                    self.navigationController.navigationBar.frame.origin.x,
                                                                    navigationY,
                                                                    self.navigationController.navigationBar.frame.size.width,
                                                                    self.navigationController.navigationBar.frame.size.height-offset
                                                                    );
        verticalY = verticalY+offset;
        [self.navigationItem.leftBarButtonItem setBackgroundVerticalPositionAdjustment:verticalY forBarMetrics:UIBarMetricsDefault];
        [self.navigationItem.rightBarButtonItem setBackgroundVerticalPositionAdjustment:verticalY forBarMetrics:UIBarMetricsDefault];
        
    }];
    
}

-(void)changeNavigationBarTranslationY:(CGFloat)translationY
{
    self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, translationY);
}

-(void)setContentAlpha:(CGFloat)alpha
{
    for (UIView *subview in self.navigationController.navigationBar.subviews) {
        subview.alpha = alpha;
    }
}

@end
