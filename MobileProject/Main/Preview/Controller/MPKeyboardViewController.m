//
//  MPKeyboardViewController.m
//  MobileProject
//  此实例是为了演示没有开始时文本框，弹出后才有文本框的效果；点击事件只好改变视图的位置
//  如果页面一开始就有输入框 就可以采用更加简单的方式 修改其inputAccessoryView及inputView就可以搞定；这样要加载的视图就可以不用开始就加到self.view里面
//
//  Created by wujunyang on 2016/12/4.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPKeyboardViewController.h"

@interface MPKeyboardViewController ()
@property(strong,nonatomic)UIButton *myLeftButton,*myRightButton;
@property(strong,nonatomic)UITextField *myTextField;
@property(strong,nonatomic)UIView *myTopView,*myBottomView;
@property(nonatomic)BOOL isSelect;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *curve;

@property(nonatomic)CGFloat keyBoardHeight;
@end

static const CGFloat topViewHeigt=100;

@implementation MPKeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isSelect=NO;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    if (!self.myLeftButton) {
        self.myLeftButton = [[UIButton alloc]init];
        [self.myLeftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.myLeftButton setTitle:@"键盘监听" forState:UIControlStateNormal];
        [self.myLeftButton addTarget:self action:@selector(myOpenView)forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.myLeftButton];
        [self.myLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(100);
            make.left.mas_equalTo(30);
        }];
    }
    
    
    if (!self.myTopView) {
        self.myTopView=[[UIView alloc]init];
        self.myTopView.frame=CGRectMake(0, Main_Screen_Height, Main_Screen_Width, topViewHeigt);
        self.myTopView.backgroundColor=[UIColor redColor];
        [self.view addSubview:self.myTopView];
        
        if (!self.myTextField) {
            self.myTextField=[[UITextField alloc]init];
            self.myTextField.layer.borderColor=[UIColor grayColor].CGColor;
            self.myTextField.layer.borderWidth=0.5;
            self.myTextField.placeholder=@"请输入文本内容";
            [self.myTopView addSubview:self.myTextField];
            [self.myTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(10);
                make.left.mas_equalTo(10);
                make.right.mas_equalTo(-50);
                make.height.mas_equalTo(40);
            }];
        }
        
        if (!self.myRightButton) {
            self.myRightButton = [[UIButton alloc]init];
            [self.myRightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.myRightButton setTitle:@"照片" forState:UIControlStateNormal];
            [self.myRightButton addTarget:self action:@selector(myAction)forControlEvents:UIControlEventTouchUpInside];
            [self.myTopView addSubview:self.myRightButton];
            [self.myRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(20);
                make.right.mas_equalTo(-10);
            }];
        }
    }
    
    if (!self.myBottomView) {
        self.myBottomView=[[UIView alloc]init];
        
        self.myBottomView.hidden=YES;
        self.myBottomView.backgroundColor=[UIColor greenColor];
        
        UILabel *myLabel=[[UILabel alloc]init];
        myLabel.text=@"我是自定义视图";
        [self.myBottomView addSubview:myLabel];
        [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.myBottomView);
        }];
    }
    
    
    //增加监听，当键盘出现或改变时收到消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键盘退出时收到消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 重写BaseViewController设置内容

//设置导航栏背景色
-(UIColor*)set_colorBackground
{
    return [UIColor whiteColor];
}

////设置标题
-(NSMutableAttributedString*)setTitle
{
    return [self changeTitle:@"键盘处理操作"];
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

-(void)myOpenView
{
    [self.myTextField becomeFirstResponder];
}

-(void)myAction
{
    self.isSelect=!self.isSelect;
    
    [self.myTextField resignFirstResponder];
    self.myBottomView.hidden=NO;
    self.myBottomView.frame=CGRectMake(0, 0, Main_Screen_Width, self.keyBoardHeight);
    self.myTextField.inputView = self.isSelect ? self.myBottomView : nil;
    [self.myTextField becomeFirstResponder];
}


/**
 * 功能：当键盘出现或改变时调用
 */
- (void)keyboardWillShow:(NSNotification *)aNotification {
    // ------获取键盘的高度
    NSDictionary *userInfo    = [aNotification userInfo];
    
    // 键盘弹出后的frame的结构体对象
    NSValue *valueEndFrame = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // 得到键盘弹出后的键盘视图所在y坐标
    CGFloat keyBoardEndY = valueEndFrame.CGRectValue.origin.y;
    CGRect keyboardRect       = [valueEndFrame CGRectValue];
    CGFloat KBHeight              = keyboardRect.size.height;
    self.keyBoardHeight=KBHeight;
    // ------键盘出现或改变时的操作代码
    NSLog(@"当前的键盘高度为：%f",KBHeight);
    // 键盘弹出的动画时间
    self.duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    // 键盘弹出的动画曲线
    self.curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    
    // 添加移动动画，使视图跟随键盘移动(动画时间和曲线都保持一致)
    [UIView animateWithDuration:[_duration doubleValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        [UIView setAnimationCurve:[_curve intValue]];
        self.myTopView.frame=CGRectMake(0, keyBoardEndY+topViewHeigt+TopBarHeight, Main_Screen_Width, topViewHeigt);
    }];
}

/**
 * 功能：当键盘退出时调用
 */
- (void)keyboardWillHide:(NSNotification *)aNotification {
    // ------键盘退出时的操作代码
    NSDictionary *userInfo    = [aNotification userInfo];
    self.duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动(动画时间和曲线都保持一致)
    [UIView animateWithDuration:[_duration doubleValue] animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        [UIView setAnimationCurve:[_curve intValue]];
        self.myTopView.frame=CGRectMake(0, Main_Screen_Height, Main_Screen_Width, topViewHeigt);
    }];
}

@end
