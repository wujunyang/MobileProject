//
//  MPBlockLoopViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPBlockLoopViewController.h"
#import "MPChildBlockViewController.h"
#import "MPModelBlockViewController.h"

@interface MPBlockLoopViewController ()

@property(nonatomic,strong)UIButton *myButton,*myModelButton,*myBlockButton;

@property(nonatomic,strong)MPBlockView *myBlockView;

@end

@implementation MPBlockLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    MPMemoryHelper *memoryHelper=[[MPMemoryHelper alloc]init];
    NSLog(@"当前占用的内存：%f",[memoryHelper usedMemory]);
    NSLog(@"当前设备可用的内存：%f",[memoryHelper availableMemory]);
    
    [self.view addSubview:self.myButton];
    [self.myButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(20);
    }];
    
    
    [self.view addSubview:self.myBlockButton];
    [self.myBlockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(170);
        make.left.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.myModelButton];
    [self.myModelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(220);
        make.left.mas_equalTo(20);
    }];
    
    //1:Block内部就完成处理，block不要以属性开放出来，否则不好管理,MPWeakSelf、MPStrongSelf因为它block执行时就自个打破循环
    _myBlockView=[[MPBlockView alloc] init];
    _myBlockView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:_myBlockView];
    [_myBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    MPWeakSelf(self);
    [_myBlockView startWithErrorBlcok:^(NSString *name) {
        MPStrongSelf(self);
        //不要在这里面存放 关于MPBlockLoopViewController的属性 否则也会内存无法释放 例如：_info=name;
        [self showErrorMessage:name];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


-(UIButton *)myButton
{
    if (!_myButton) {
        _myButton=[UIButton new];
        _myButton.backgroundColor=[UIColor redColor];
        [_myButton setTitle:@"跳转子页" forState:UIControlStateNormal];
        [_myButton addTarget:self action:@selector(myButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myButton;
}

-(UIButton *)myModelButton
{
    if (!_myModelButton) {
        _myModelButton=[UIButton new];
        _myModelButton.backgroundColor=[UIColor redColor];
        [_myModelButton setTitle:@"弹出模态窗口" forState:UIControlStateNormal];
        [_myModelButton addTarget:self action:@selector(myModelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myModelButton;
}

-(UIButton *)myBlockButton
{
    if (!_myBlockButton) {
        _myBlockButton=[UIButton new];
        _myBlockButton.backgroundColor=[UIColor redColor];
        [_myBlockButton setTitle:@"响应MPBlockLoopOperation中的block" forState:UIControlStateNormal];
        [_myBlockButton addTarget:self action:@selector(myBlockButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myBlockButton;
}

//调用其它类的一些内存问题
-(void)myBlockButtonAction
{
    //1：
    [MPBlockLoopOperation operateWithSuccessBlock:^{
        [self showErrorMessage:@"成功执行完成"];
    }];
    
    //这种不会出现block 因为MPBlockLoopOperation没在MPBlockLoopViewController的属性中,所以三者不会是一个闭圈
    MPBlockLoopOperation *operation=[[MPBlockLoopOperation alloc]initWithAddress:@"厦门市思明区"];
    
    //2：单纯这么响应不会出现内存没有释放的问题
    [operation startNoBlockShow:@"12345677888"];
    
    //3：如果带有block 又引入self就要进行弱化对象operation，否则会出现内存释放的问题
    MPWeakSelf(operation);
    [operation startWithAddBlock:^(NSString *name) {
        MPStrongSelf(operation);
        [self showErrorMessage:operation.myAddress];
    }];
}

//子页开放的block
-(void)myButtonAction
{
    MPChildBlockViewController *vc=[[MPChildBlockViewController alloc]init];
    vc.successBlock=^()
    {
        [self loadPage];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)myModelButtonAction
{
    MPModelBlockViewController *vc=[[MPModelBlockViewController alloc]init];
    MPWeakSelf(vc);
    vc.successBlock=^()
    {
        MPStrongSelf(vc);
        if (vc) {
            [vc dismissViewControllerAnimated:YES completion:nil];
        }
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)showErrorMessage:(NSString *)message
{
    NSLog(@"当前信息,%@",message);
}

-(void)loadPage
{
    NSLog(@"刷新当前的数据源");
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
    return [self changeTitle:@"内存释放知识点"];
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
