//
//  MPReduceTimeViewController.m
//  MobileProject  项目中的时间CELL中的时间都要从服务端获取，本实例只以本地时间只是为了测试效果
//  原理获取服务端的相应时间，然后存在本地的一个数组中，然后定时器不断的--，并更新到数组中，并判断当前的状态，刷新每一行的效果；
//  Created by wujunyang on 16/8/1.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPReduceTimeViewController.h"

@interface MPReduceTimeViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) UITableView         *myTableView;
@property (nonatomic,strong) NSMutableArray      *dataMutableArray;
//所有剩余时间数组
@property (nonatomic,strong) NSMutableArray      *totalLastTime;
@property(nonatomic)NSTimer *timer;
//服务器的当前时间，正式项目请求服务端获取，此实例以本地为例
@property(nonatomic)NSDate *server_DateTime;
@end

@implementation MPReduceTimeViewController


#pragma mark viewController 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"列表倒计时";
    
    if (!self.totalLastTime) {
        self.totalLastTime=[[NSMutableArray alloc]init];
    }
    
    self.server_DateTime=[NSDate new];
    
    if (!_myTableView) {
        _myTableView                                = [[UITableView alloc] initWithFrame:CGRectMake(0,0, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator   = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.dataSource                     = self;
        _myTableView.delegate                       = self;
        [_myTableView registerClass:[MPReduceTimeCell class] forCellReuseIdentifier:NSStringFromClass([MPReduceTimeCell class])];
        [self.view addSubview:_myTableView];
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    
    //模拟服务端获取数据
    [self loadTableData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
}

#pragma mark UITableViewDataSource, UITableViewDelegate相关内容

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MPReduceTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MPReduceTimeCell class]) forIndexPath:indexPath];
    MPReduceTimeModel *model=self.dataMutableArray[indexPath.row];
    [cell configCellWithImage:model.imageName name:model.name];
    NSInteger seconders=[[[self.totalLastTime objectAtIndex:indexPath.row] objectForKey:@"lastTime"]integerValue];
    [cell configCellState:seconders>0?MPReduceTimeStateIng:MPReduceTimeStateEnd currentTime:[self lessSecondToDay:seconders]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark 自定义代码

/**
 *  @author wujunyang, 16-08-01 13:08:10
 *
 *  @brief  加载列表数据 真实请求服务端接口获取 **注意：时间也是服务端的时间
 */
-(void)loadTableData
{
    if (!self.dataMutableArray) {
        self.dataMutableArray=[[NSMutableArray alloc]init];
    }
    
    for (int num=0; num<20; num++) {
        MPReduceTimeModel *model=[[MPReduceTimeModel alloc]init];
        model.name=[NSString stringWithFormat:@"产品名称%d",num];
        model.imageName=@"project_icon";
        model.date=[NSDate dateWithMinutesFromNow:num];
        
        
        //此处时间要从服务端获取，倒计时都要以服务端时间为准
        NSDate *start_date = model.date;
        //NSDate *server_date = ;
        
        NSDictionary *dic = @{@"indexPath":[NSString stringWithFormat:@"%i",num],@"lastTime": [NSNumber numberWithInteger:[self getCurrentSecondsWithServerDate:self.server_DateTime start_date:start_date]]};
        [self.totalLastTime addObject:dic];
        
        [self.dataMutableArray addObject:model];
    }
    
    [self startTimer];
    [self.myTableView reloadData];
}

/**
 *  @author wujunyang, 16-08-01 13:08:24
 *
 *  @brief  时间转换
 *
 *  @param seconds <#seconds description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)lessSecondToDay:(NSUInteger)seconds
{
    NSUInteger hour = (NSUInteger)(seconds%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(seconds%(3600))/60;
    NSUInteger second = (NSUInteger)(seconds%60);
    
    NSString *time = [NSString stringWithFormat:@" %02lu:%02lu:%02lu",(unsigned long)hour,(unsigned long)min,(unsigned long)second];
    return time;
}

//倒计时事件
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:@"" repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
}

- (void)refreshLessTime
{
    NSInteger time;
    for (int i = 0; i < self.totalLastTime.count; i++) {
        time = [[[self.totalLastTime objectAtIndex:i] objectForKey:@"lastTime"]integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[[[self.totalLastTime objectAtIndex:i] objectForKey:@"indexPath"] integerValue] inSection:0];
        MPReduceTimeCell *cell = (MPReduceTimeCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
        if (time==0) {
            --time;
            [cell configCellState:MPReduceTimeStateEnd currentTime:@""];
        }
        else if(time>0)
        {
            [cell configCellState:MPReduceTimeStateIng currentTime:[self lessSecondToDay:--time]];
        }
        NSDictionary *dic = @{@"indexPath": [NSString stringWithFormat:@"%d",indexPath.row],@"lastTime": [NSString stringWithFormat:@"%li",(long)time]};
        [self.totalLastTime replaceObjectAtIndex:i withObject:dic];
    }
}

//两时间比较 获取总秒数 用于倒计时
-(NSInteger)getCurrentSecondsWithServerDate:(NSDate *)server_date start_date:(NSDate *)start_date
{
    NSInteger seconds=-1;
    seconds=[start_date timeIntervalSinceDate:server_date];
    return seconds;
}
@end
