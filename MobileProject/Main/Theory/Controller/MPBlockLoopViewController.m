//
//  MPBlockLoopViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/22.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPBlockLoopViewController.h"

@interface MPBlockLoopViewController ()

@property(nonatomic,copy)NSString *curInfo;

@property(nonatomic,strong)UIButton *myButton,*myBlockButton;

@property(nonatomic,strong)MPBlockView *myBlockView;

@property(nonatomic,strong)MPBlockView *myNoClaerBlockView;

@end

@implementation MPBlockLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
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
    
    MPWeakSelf(self);
    //1:Block内部就完成处理，block不要以属性开放出来，否则不好管理 因为block执行一次就给nil了,内部block处理为空，所以它就不能再进行响应,比较适合那种响应就重新创建一个实例调用其block(见实例MPBlockLoopOperation),如果一定会执行Block里面的代码就可以不用写，MPWeakSelf、MPStrongSelf因为它block执行时就自个打破循环
    _myBlockView=[[MPBlockView alloc]initWithErrorBlcok:^(NSString *name) {
        MPStrongSelf(self);
        _curInfo=name;
        [self showErrorMessage:name];
    }];
    
    _myBlockView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:_myBlockView];
    [_myBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    
    //2:block里面没有进行处理，所以要弱引用跟强引用，并在block执行完成后进行清空block所属的对象，这种写法不建议，不应该开发给调用者自个处理，毕竟可能会忘记；这样self.myNoClaerBlockView=nil可能会忘记写
    _myNoClaerBlockView=[[MPBlockView alloc]initWithNoClearErrorBlock:^(NSString *name) {
        MPStrongSelf(self);
        _curInfo=name;
        [self showErrorMessage:name];
        _myNoClaerBlockView=nil;
    }];
    _myNoClaerBlockView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:_myNoClaerBlockView];
    [_myNoClaerBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(160);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    //****： 上面两种打破block循环的代码都放在block里面执行，所以会出现一种情况，当进来页面但没有去执行这两个block，所以要用MPWeakSelf弱化处理 block内在强化
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIButton *)myButton
{
    if (!_myButton) {
        _myButton=[UIButton new];
        _myButton.backgroundColor=[UIColor redColor];
        [_myButton setTitle:@"返回" forState:UIControlStateNormal];
        [_myButton addTarget:self action:@selector(myButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myButton;
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


-(void)myBlockButtonAction
{
    //这种不会出现block 因为MPBlockLoopOperation没在MPBlockLoopViewController的属性中,所以三者不会是一个闭圈
    MPBlockLoopOperation *operation=[[MPBlockLoopOperation alloc]initWithAddress:@"厦门市思明区"];
    
    [operation startWithAddBlock:^(NSString *name) {
        _curInfo=name;
        [self showErrorMessage:operation.myAddress];
    }];
    
    
    [MPBlockLoopOperation operateWithSuccessBlock:^{
        [self showErrorMessage:@"成功执行完成"];
    }];
}


-(void)myButtonAction
{
    if (self.successBlock) {
        self.successBlock();
    }
}


-(void)showErrorMessage:(NSString *)message
{
    NSLog(@"当前信息,%@",message);
}



@end
