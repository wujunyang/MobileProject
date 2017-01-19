//
//  MPNavigationViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/1/19.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPNavigationViewController.h"

@interface MPNavigationViewController ()<UITableViewDataSource, UITableViewDelegate,NaViewDelegate>
@property (nonatomic,strong) UITableView *myTableView;
@property(nonatomic,strong)MPNavView *NavView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UIImageView *backgroundImgV;
@property(nonatomic,assign)float backImgHeight;
@property(nonatomic,assign)float backImgWidth;

@end

@implementation MPNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray =[[NSMutableArray alloc]init];
    for (int i = 0; i < 20; i++) {
        NSString * string=[NSString stringWithFormat:@"第%d行",i];
        [_dataArray addObject:string];
    }
    
    if (!_myTableView) {
        _myTableView                                = [[UITableView alloc] initWithFrame:CGRectMake(0,64, Main_Screen_Width, Main_Screen_Height-64) style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator   = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.dataSource                     = self;
        _myTableView.delegate                       = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.tableFooterView=[UIView new];
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.view addSubview:_myTableView];
    }
    
    //背景
    UIImage *image=[UIImage imageNamed:@"back"];
    _backgroundImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 64)];
    _backgroundImgV.image=image;
    _backgroundImgV.userInteractionEnabled=YES;
    [self.view addSubview:_backgroundImgV];
    _backImgHeight=_backgroundImgV.frame.size.height;
    _backImgWidth=_backgroundImgV.frame.size.width;
    
    
    //最上层 放最后
    self.NavView=[[MPNavView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 64)];
    self.NavView.title = @"我的";
    self.NavView.color = [UIColor whiteColor];
    self.NavView.left_bt_Image = @"left_";
    self.NavView.right_bt_Image = @"Setting";
    self.NavView.delegate = self;
    [self.view addSubview:self.NavView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //如果要隐藏NavigationBar
    [self changeNavigationBarTranslationY:-64];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //如果隐藏NavigationBar,退出去时还得开放出来
    [self changeNavigationBarTranslationY:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark NaViewDelegate

//左按钮
-(void)NaLeft
{
    NSLog(@"左按钮");
}
//右按钮
-(void)NaRight
{
    NSLog(@"右按钮");
}

#pragma mark UITableViewDataSource, UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    NSString *name=self.dataArray[indexPath.row];
    cell.textLabel.text=name;
    return cell;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsety = scrollView.contentOffset.y;
    
    if (scrollView.contentOffset.y<=64) {
        self.NavView.headBackView.alpha = scrollView.contentOffset.y/64;
        self.NavView.left_bt_Image = @"left_";
        self.NavView.right_bt_Image = @"Setting";
        self.NavView.color = [UIColor whiteColor];
        
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }else{
        self.NavView.headBackView.alpha = 1;
        
        self.NavView.left_bt_Image = @"left";
        self.NavView.right_bt_Image = @"Setting_";
        self.NavView.color = RGBA(87, 173, 104, 1);
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
    if (contentOffsety<0) {
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight-contentOffsety;
        rect.size.width = _backImgWidth* (_backImgHeight-contentOffsety)/_backImgHeight;
        rect.origin.x =  -(rect.size.width-_backImgWidth)/2;
        rect.origin.y = 0;
        _backgroundImgV.frame = rect;
    }else{
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight;
        rect.size.width = _backImgWidth;
        rect.origin.x = 0;
        rect.origin.y = -contentOffsety;
        _backgroundImgV.frame = rect;
        
    }
}

@end
