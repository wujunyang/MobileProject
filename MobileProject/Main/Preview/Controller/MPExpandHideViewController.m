//
//  MPExpandHideViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/8/16.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPExpandHideViewController.h"


@interface MPExpandHideViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) NSDictionary *dataDictionary; //数据
@property (nonatomic,strong) NSArray *listGroupNameArray; //排序后的组名数组
@property (nonatomic,strong) NSMutableArray *expandStateArray; //展开状态数组
@property (nonatomic,strong) UITableView *myTableView;
@end

@implementation MPExpandHideViewController

#pragma mark viewController生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    [self layoutPageView];
    [self loadPlistData];
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
    return [self changeTitle:@"列表行展开跟隐藏功能"];
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
    return self.dataDictionary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *groupName = [self.listGroupNameArray objectAtIndex:section];
    NSArray *curListTeamsArray = [self.dataDictionary objectForKey:groupName];
    if ([self CurrentLineExpandState:section]) {
        return curListTeamsArray.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor=[UIColor grayColor];
    
//    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerSectionAction)];
//    [view addGestureRecognizer:tapGesture];
//    
    
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.font=CHINESE_SYSTEM(13);
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.text=[self.listGroupNameArray objectAtIndex:section];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@100);
    }];
    
    UIImage *rightImage = [UIImage imageNamed:[self CurrentLineExpandState:section]?@"arrow_down_icon":@"arrow_up_icon"];
    
    UIButton *rightButton=[[UIButton alloc]init];
    rightButton.tag=1000+section;
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(headerSectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(rightImage.size.height);
        make.width.mas_equalTo(rightImage.size.width);
    }];
    
    //横线
    UIView *lineView=[[UIView alloc]init];
    lineView.backgroundColor=HEXCOLOR(0xdddddd);
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.3);
    }];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    NSString *groupName = [self.listGroupNameArray objectAtIndex:indexPath.section];
    NSArray *curListTeamsArray = [self.dataDictionary objectForKey:groupName];
    cell.textLabel.text   = curListTeamsArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.view addSubview:_myTableView];
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}

//加载数据
-(void)loadPlistData
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPathString = [bundle pathForResource:@"team_dictionary" ofType:@"plist"];
    //self.dataDictionary无顺序
    self.dataDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPathString];
    // 对key进行排序  取出来时就可以按顺序了
    self.listGroupNameArray = [[self.dataDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    //初始化展开状态
    self.expandStateArray=[[NSMutableArray alloc]init];
    for (NSInteger itemIndex=0; itemIndex<self.listGroupNameArray.count; itemIndex++) {
        [self.expandStateArray addObject:@YES];
    }
    
    [self.myTableView reloadData];
}

-(void)headerSectionAction:(UIButton *)sender
{
    NSInteger curHeadInt=sender.tag-1000;
    BOOL curExpandState=[self CurrentLineExpandState:curHeadInt];
    curExpandState=!curExpandState;
    //并把状态更新回数组
    [self.expandStateArray replaceObjectAtIndex:curHeadInt withObject:[NSNumber numberWithBool:curExpandState]];
    //添加旋转动画
    [UIView animateWithDuration: 0.5 delay: 0.1 options: UIViewAnimationOptionTransitionCurlUp  animations: ^{
            CGAffineTransform rotate = CGAffineTransformMakeRotation(-180 / 180.0 * M_PI );
            [sender setTransform:rotate];
    } completion: ^(BOOL finished) {
        [self.myTableView reloadData];
    }];
}

//当关的展开状态
-(BOOL)CurrentLineExpandState:(NSInteger)section
{
    BOOL result=YES;
    
    if (self.expandStateArray.count>section) {
        result=[self.expandStateArray[section] boolValue];
    }
    
    return result;
}

@end
