//
//  LoggerViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/1/27.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "LoggerViewController.h"

@interface LoggerViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *myTableView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, weak) DDFileLogger *fileLogger;
@property (nonatomic, strong) NSArray *logFiles;
@end

@implementation LoggerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fileLogger = [MyFileLogger sharedManager].fileLogger;
    [self loadLogFiles];

    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) style:UITableViewStyleGrouped];
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator=NO;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableView class])];
        [self.view addSubview:_myTableView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//读取日志的文件个数
- (void)loadLogFiles
{
    self.logFiles = self.fileLogger.logFileManager.sortedLogFileInfos;
}

//时间格式
- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter) {
        return _dateFormatter;
    }
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return _dateFormatter;
}


#pragma mark - TableView dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 40;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.logFiles.count;
    }
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30)];
    if (section==0) {
        UILabel *myLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.width, 30)];
        myLabel.text=@"日记列表";
        [headView addSubview:myLabel];
    }
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableView class])];
    if (indexPath.section == 0) {
        DDLogFileInfo *logFileInfo = (DDLogFileInfo *)self.logFiles[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = indexPath.row == 0 ? NSLocalizedString(@"当前", @"") : [self.dateFormatter stringFromDate:logFileInfo.creationDate];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = NSLocalizedString(@"清理旧的记录", @"");
    }
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        DDLogFileInfo *logFileInfo = (DDLogFileInfo *)self.logFiles[indexPath.row];
        NSData *logData = [NSData dataWithContentsOfFile:logFileInfo.filePath];
        NSString *logText = [[NSString alloc] initWithData:logData encoding:NSUTF8StringEncoding];
        
        LoggerDetailViewController *detailViewController = [[LoggerDetailViewController alloc] initWithLog:logText
                                                                                             forDateString:[self.dateFormatter stringFromDate:logFileInfo.creationDate]];
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else {
        for (DDLogFileInfo *logFileInfo in self.logFiles) {
            //除了当前 其它进行清除
            if (logFileInfo.isArchived) {
                [[NSFileManager defaultManager] removeItemAtPath:logFileInfo.filePath error:nil];
            }
        }
        
        [self loadLogFiles];
        [self.myTableView reloadData];
    }
}


@end
