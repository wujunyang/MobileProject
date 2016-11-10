//
//  MPViewControllerLifeCycle.m
//  MobileProject
//
//  Created by wujunyang on 2016/11/10.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPViewControllerLifeCycle.h"

@interface MPViewControllerLifeCycle ()
@property(nonatomic,strong)UIView *myView,*myOtherView;

@end

@implementation MPViewControllerLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"第一个VC viewDidLoad");
    self.view.backgroundColor=[UIColor blueColor];
    
    if (!self.myView) {
        self.myView=[[UIView alloc]init];
        self.myView.backgroundColor=[UIColor redColor];
        [self.view addSubview:self.myView];
        [self.myView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(120, 200));
        }];
    }
    
    if (!self.myOtherView) {
        self.myOtherView=[[UIView alloc]init];
        self.myOtherView.backgroundColor=[UIColor yellowColor];
        [self.view addSubview:self.myOtherView];
    }
    
    NSLog(@"myView当前的坐标：: %@",NSStringFromCGRect(self.myView.frame));
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"第一个VC viewWillAppear");
    
    NSLog(@"myView当前的坐标：: %@",NSStringFromCGRect(self.myView.frame));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"第一个VC didReceiveMemoryWarning");
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    NSLog(@"第一个VC viewWillDisappear");
}
-(void)loadView
{
    [super loadView];
    NSLog(@"第一个VC loadView");
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NSLog(@"第一个VC viewWillLayoutSubviews");
    
    NSLog(@"myView当前的坐标：: %@",NSStringFromCGRect(self.myView.frame));
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"第一个VC viewDidLayoutSubviews");
    
    NSLog(@"myView当前的坐标：: %@",NSStringFromCGRect(self.myView.frame));
    
    NSLog(@"---------------");
    NSLog(@"坐标值，要到viewDidLayoutSubviews 才正确。根视图的大小改变了，子视图必须相应做出调整才可以正确显示，这就是为什么要在 viewDidLayoutSubviews 中调整动态视图的frame");
    NSLog(@"---------------");
    
    CGRect myViewFrame=self.myView.frame;
    
    CGFloat myOtherViewY=CGRectGetMaxY(myViewFrame)+20;
    myViewFrame.origin.y=myOtherViewY;
    
    self.myOtherView.frame=myViewFrame;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSLog(@"第一个VC viewDidAppear");
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    NSLog(@"第一个VC viewDidDisappear");
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"第一个VC awakeFromNib");
}


#pragma mark 重写BaseViewController设置内容

//设置导航栏背景色
-(UIColor*)set_colorBackground
{
    return [UIColor whiteColor];
}

//是否隐藏导航栏底部的黑线 默认也为NO
-(BOOL)hideNavigationBottomLine
{
    return NO;
}

////设置标题
-(NSMutableAttributedString*)setTitle
{
    return [self changeTitle:@"ViewController生命周期"];
}

//设置左边按键
-(UIButton*)set_leftButton
{
    UIButton *left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [left_button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
    return left_button;
}

//设置左边事件
-(void)left_button_event:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}

@end
