//
//  MPFormViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/8/19.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPFormViewController.h"

@interface MPFormViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) UITableView *myTableView;

@property(nonatomic,copy)NSString *myUserName,*mySex,*myBirthday,*myAddress;
@end


@implementation MPFormViewController

#pragma mark viewController生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    [self layoutPageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager]setEnable:YES];
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
    return [self changeTitle:@"常见表单行类型"];
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


#pragma mark UITableViewDataSource, UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==4) {
        return [MPMultitextCell cellHeight];
    }
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MPWeakSelf(self)
    if (indexPath.row==0) {
        MPIconAndTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MPIconAndTitleCell class]) forIndexPath:indexPath];
        [cell configCellIconName:@"mine_setting_icon" cellTitle:@"系统设置" showLine:YES];
        
        return cell;
    }
    else if (indexPath.row==1) {
        MPTitleAndPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MPTitleAndPromptCell class]) forIndexPath:indexPath];
        [cell setCellDataKey:@"姓名" curValue:self.myUserName blankValue:@"请输入姓名" isShowLine:YES cellType:MPTitleAndPromptCellTypeInput];
        return cell;
    }
    else if (indexPath.row==2)
    {
         MPTitleAndPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MPTitleAndPromptCell class]) forIndexPath:indexPath];
        [cell setCellDataKey:@"性别" curValue:self.mySex blankValue:@"请选择性别" isShowLine:YES cellType:MPTitleAndPromptCellTypeSelect];
        return cell;
    }
    else if (indexPath.row==3)
    {
        MPTitleAndPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MPTitleAndPromptCell class]) forIndexPath:indexPath];
        [cell setCellDataKey:@"生日" curValue:self.myBirthday blankValue:@"请选择出生日期" isShowLine:YES cellType:MPTitleAndPromptCellTypeSelect];
        return cell;
    }
    else
    {
        MPMultitextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MPMultitextCell class]) forIndexPath:indexPath];
        [cell setCellDataKey:@"家庭地址" textValue:self.myAddress blankValue:@"请输入家庭地址" showLine:NO];
        cell.placeFontSize=15;
        cell.textValueChangedBlock=^(NSString* text)
        {
            MPStrongSelf(self)
            self.myAddress=text;
        };
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self)weakSelf = self;
    
    //主要为了兼容UUInputAccessoryView跟IQKeyboardManager时的问题，凡是有用到UUInputAccessoryView都会关掉IQKeyboardManager，其它则打开
    [[IQKeyboardManager sharedManager]setEnable:YES];
    
    if (indexPath.row==0) {
        [MBProgressHUD showInfo:@"跳转成功" ToView:self.view];
    }
    else if(indexPath.row==1)
    {
        UIKeyboardType type = UIKeyboardTypeDefault;
        NSString *content = self.myUserName;
        //凡是有用到UUInputAccessoryView都会关掉IQKeyboardManager
        [[IQKeyboardManager sharedManager]setEnable:NO];
        [UUInputAccessoryView showKeyboardType:type
                                       content:content
                                         Block:^(NSString *contentStr)
         {
             if (contentStr.length == 0) return ;
             weakSelf.myUserName=contentStr;
             [weakSelf.myTableView reloadData];
         }];
    }
    else if(indexPath.row==2)
    {
        NSArray *sexArray=@[@"男",@"女"];
        NSInteger mySexLevel=[self indexOfFirst:self.mySex firstLevelArray:sexArray];
        
        [ActionSheetStringPicker showPickerWithTitle:nil rows:sexArray initialSelection:mySexLevel doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            weakSelf.mySex=selectedValue;
            [weakSelf.myTableView reloadData];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.view];
    }
    else if (indexPath.row==3)
    {
        NSDate* curDate = [NSDate date];
        //datePickerMode可以设置时间类型
        ActionSheetDatePicker* picker = [[ActionSheetDatePicker alloc] initWithTitle:nil
                                                                      datePickerMode:UIDatePickerModeDate
                                                                        selectedDate:curDate
                                                                           doneBlock:^(ActionSheetDatePicker* picker, NSDate* selectedDate, id origin) {
                                                                               weakSelf.myBirthday =[selectedDate formatYMD];
                                                                               [weakSelf.myTableView reloadData];
                                                                           } cancelBlock:^(ActionSheetDatePicker* picker) {
                                                                               
                                                                           }                                                             origin:self.view];
        //picker.minimumDate = curDate; //设置最早时间点
        [picker showActionSheetPicker];
    }
}

#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}

-(void)layoutPageView
{
    //初始化表格
    if (!_myTableView) {
        _myTableView                                = [[UITableView alloc] initWithFrame:CGRectMake(0,0.5, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator   = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.dataSource                     = self;
        _myTableView.delegate                       = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.tableFooterView=[UIView new];
        [_myTableView registerClass:[MPTitleAndPromptCell class] forCellReuseIdentifier:NSStringFromClass([MPTitleAndPromptCell class])];
        [_myTableView registerClass:[MPIconAndTitleCell class] forCellReuseIdentifier:NSStringFromClass([MPIconAndTitleCell class])];
        [_myTableView registerClass:[MPMultitextCell class] forCellReuseIdentifier:NSStringFromClass([MPMultitextCell class])];
        [self.view addSubview:_myTableView];
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}

- (NSInteger)indexOfFirst:(NSString *)firstLevelName firstLevelArray:(NSArray *)firstLevelArray
{
    NSInteger index = [firstLevelArray indexOfObject:firstLevelName];
    if (index == NSNotFound) {
        return 0;
    }
    return index;
}

@end
