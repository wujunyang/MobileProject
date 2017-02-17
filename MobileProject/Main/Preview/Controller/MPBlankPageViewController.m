//
//  MPBlankPageViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/8/2.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPBlankPageViewController.h"

@interface MPBlankPageViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) NSArray             *dataArray;
@property (nonatomic,strong) UITableView         *myTableView;
@end


@implementation MPBlankPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    if (!self.dataArray) {
        self.dataArray=[[NSArray alloc]init];
    }
    
    //初始化表格
    if (!_myTableView) {
        _myTableView                                = [[UITableView alloc] initWithFrame:CGRectMake(0,0.5, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator   = NO;
        _myTableView.tableFooterView=[UIView new];
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.dataSource                     = self;
        _myTableView.delegate                       = self;
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.view addSubview:_myTableView];
        MPWeakSelf(self);
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //模拟加载服务端数据
            MPStrongSelf(self);
            [self loadMyTableData];
        }];
        
        [_myTableView.mj_header beginRefreshing];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

//是否隐藏导航栏底部的黑线 默认也为NO
-(BOOL)hideNavigationBottomLine
{
    return NO;
}

////设置标题
-(NSMutableAttributedString*)setTitle
{
    return [self changeTitle:@"空白页展现"];
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

//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    UIButton *right_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65, 22)];
    [right_button setTitle:@"出错效果" forState:UIControlStateNormal];
    right_button.titleLabel.font=CHINESE_SYSTEM(14);
    [right_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    return right_button;
}

//设置右边事件
-(void)right_button_event:(UIButton*)sender
{
    __weak typeof(self)weakSelf = self;
    [self.view configBlankPage:EaseBlankPageTypeProject hasData:(self.dataArray.count>0) hasError:YES reloadButtonBlock:^(id sender) {
            [MBProgressHUD showInfo:@"重新加载的数据" ToView:self.view];
            [weakSelf.myTableView.mj_header beginRefreshing];
        }];
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
    
}

#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}


-(void)loadMyTableData
{
    //请求服务端接口并返回数据
    __weak typeof(self)weakSelf = self;
    
    //成功时
    [self.myTableView reloadData];
    [self.myTableView.mj_header endRefreshing];
    //增加无数据展现
    
    [self.view configBlankPage:EaseBlankPageTypeView hasData:self.dataArray.count hasError:(self.dataArray.count>0) reloadButtonBlock:^(id sender) {
        [MBProgressHUD showInfo:@"重新加载的数据" ToView:weakSelf.view];
        [weakSelf.myTableView.mj_header beginRefreshing];
    }];
    
    //失败时
    //    [self.view configBlankPage:EaseBlankPageTypeView hasData:(self.dataArray.count>0) hasError:YES reloadButtonBlock:^(id sender) {
    //        [MBProgressHUD showInfo:@"重新加载的数据" ToView:self.view];
    //        [weakSelf.myTableView reloadData];
    //    }];
}

@end
