//
//  MPCustomAlertViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/8/4.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPCustomAlertViewController.h"

@interface MPCustomAlertViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) NSArray             *dataArray;
@property (nonatomic,strong) UITableView         *myTableView;
@property (nonatomic,strong)WJYAlertView *alertView;
@end


@implementation MPCustomAlertViewController

#pragma mark viewController生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    if (!self.dataArray) {
        self.dataArray=@[@"底部两个Button效果",@"底部单个Button效果",@"无标题效果",@"底部Button样式修改",@"多个Button效果",@"自定义弹出视图，模态不能关闭",@"有标题自定义输入视图",@"无标题自定义输入视图"];
    }
    
    //初始化表格
    if (!_myTableView) {
        _myTableView                                = [[UITableView alloc] initWithFrame:CGRectMake(0,0.5, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator   = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.dataSource                     = self;
        _myTableView.delegate                       = self;
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.view addSubview:_myTableView];
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    return [self changeTitle:@"自定义弹出窗效果"];
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


#pragma mark UITableViewDataSource, UITableViewDelegate相关内容

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text   = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self showAlertView:indexPath.row];
}



#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}


-(void)showAlertView:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            [WJYAlertView showTwoButtonsWithTitle:@"提示信息" Message:@"这里为提示的信息内容，里面会根据内容的高度进行计算，当大于弹出窗默认的高度时会自行适应高度(并自动转成UITextView来加载内容)" ButtonType:WJYAlertViewButtonTypeNone ButtonTitle:@"取消" Click:^{
                NSLog(@"您点取消事件");
            } ButtonType:WJYAlertViewButtonTypeNone ButtonTitle:@"确定" Click:^{
                NSLog(@"你点确定事件");
            }];
            break;
        }
        case 1:
        {
            [WJYAlertView showOneButtonWithTitle:@"信息提示" Message:@"你可以单独设置底部每个Button的样式，只要相应枚举进行调整，若不满足可以对针WJYAlertView源代码进行修改，增加相应的枚举类型及其代码" ButtonType:WJYAlertViewButtonTypeNone ButtonTitle:@"知道了" Click:^{
                NSLog(@"响应事件");
            }];
            break;
        }
        case 2:
        {
            [WJYAlertView showOneButtonWithTitle:nil Message:@"你可以把Title设置为nil" ButtonType:WJYAlertViewButtonTypeNone ButtonTitle:@"知道了" Click:^{
                NSLog(@"响应事件");
            }];
            break;
        }
        case 3:
        {
            [WJYAlertView showTwoButtonsWithTitle:@"提示信息" Message:@"你可以设置ButtonType的样式来调整效果，而且还可以分开设置，更加灵活，不效果项目要求可以修改源代码" ButtonType:WJYAlertViewButtonTypeCancel ButtonTitle:@"取消" Click:^{
                NSLog(@"您点取消事件");
            } ButtonType:WJYAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:^{
                NSLog(@"你点确定事件");
            }];
            break;
        }
        case 4:
        {
            [WJYAlertView showMultipleButtonsWithTitle:@"信息内容" Message:@"可以设置多个的Button,同样也是可以有不同的样式效果" Click:^(NSInteger index) {
                NSLog(@"你点击第几个%zi", index);
            } Buttons:@{@(WJYAlertViewButtonTypeDefault):@"确定"},@{@(WJYAlertViewButtonTypeCancel):@"取消"},@{@(WJYAlertViewButtonTypeWarn):@"知道了"}, nil];
            break;
        }
        case 5:
        {
            //自定义视图
            UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 200)];
            customView.backgroundColor = [UIColor blueColor];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
            [btn setTitle:@"点我关闭" forState:UIControlStateNormal];
            btn.center = CGPointMake(120, 100);
            [customView addSubview:btn];
            [btn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
            
            // dismissWhenTouchedBackground:NO表示背景蒙层没有关闭弹出窗效果
            _alertView = [[WJYAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:NO];
            [_alertView show];
            break;
        }
        case 6:
        {
         
            WJYAlertInputTextView *myInputView=[[WJYAlertInputTextView alloc]initPagesViewWithTitle:@"消息内容" leftButtonTitle:@"取消" rightButtonTitle:@"确定" placeholderText:@"请输入正确的订单号"];
           
            __weak typeof(self)weakSelf = self;
            myInputView.leftBlock=^(NSString *text)
            {
                NSLog(@"当前值：%@",text);
                [weakSelf.alertView dismissWithCompletion:nil];
            };
            myInputView.rightBlock=^(NSString *text)
            {
                if (text.length==0) {
                    //ToView:weakSelf.alertView这样才会显示出来 否则会被AlertView盖住
                    [MBProgressHUD showError:@"内容没有输入" ToView:weakSelf.alertView];
                    return;
                }
                weakSelf.alertView.window.windowLevel = UIWindowLevelStatusBar +1;
                [MBProgressHUD showAutoMessage:[NSString stringWithFormat:@"当前内容为:%@",text]];
                [weakSelf.alertView dismissWithCompletion:nil];
            };
            
            
            _alertView=[[WJYAlertView alloc]initWithCustomView:myInputView dismissWhenTouchedBackground:NO];
            [_alertView show];
            break;
        }
        case 7:
        {
            WJYAlertInputTextView *myInputView=[[WJYAlertInputTextView alloc]initPagesViewWithTitle:nil leftButtonTitle:@"取消" rightButtonTitle:@"确定" placeholderText:@"请输入正确的订单号"];
            
            __weak typeof(self)weakSelf = self;
            myInputView.leftBlock=^(NSString *text)
            {
                NSLog(@"当前值：%@",text);
                [weakSelf.alertView dismissWithCompletion:nil];
            };
            myInputView.rightBlock=^(NSString *text)
            {
                if (text.length==0) {
                    //ToView:weakSelf.alertView这样才会显示出来 否则会被AlertView盖住
                    [MBProgressHUD showError:@"内容没有输入" ToView:weakSelf.alertView];
                    
                    return;
                }
                weakSelf.alertView.window.windowLevel = UIWindowLevelStatusBar +1;
                [MBProgressHUD showAutoMessage:[NSString stringWithFormat:@"当前内容为:%@",text]];
                [weakSelf.alertView dismissWithCompletion:nil];
            };
            
            
            _alertView=[[WJYAlertView alloc]initWithCustomView:myInputView dismissWhenTouchedBackground:NO];
            [_alertView show];
            
            break;
        }
        default:
            break;
    }
}


-(void)closeBtnClick
{
    // 如果没有其它事件要处理可以直接用下面这样关闭
    // [_alert dismissWithCompletion:nil];
    
    [_alertView dismissWithCompletion:^{
        // 处理内容
        NSLog(@"弹出窗被关闭了");
    }];
}

@end
