//
//  MPDataSourceViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/31.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPDataSourceViewController.h"
#import "MPArrayDataSource.h"
#import "MPPhotoCell.h"
#import "MPPhotoCell+ConfigureForPhoto.h"


@interface MPDataSourceViewController()<UITableViewDelegate>

@property (nonatomic,strong) NSArray             *dataArray;
@property (nonatomic,strong) UITableView         *myTableView;
@property(nonatomic,strong)MPArrayDataSource *photosArrayDataSource;
@end


@implementation MPDataSourceViewController

#pragma mark 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"TableViewDataSource提取";
    
    if (!self.dataArray) {
        self.dataArray=@[@"照片一",@"照片二",@"照片三",@"照片四",@"照片五"];
    }
    
    //初始化表格
    if (!_myTableView) {
        _myTableView                                = [[UITableView alloc] initWithFrame:CGRectMake(0,0.5, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator   = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.delegate                       = self;
        [self.view addSubview:_myTableView];
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    
    [self setupTableDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 自定义代码

- (void)setupTableDataSource
{
    TableViewCellConfigureBlock configureCell = ^(MPPhotoCell *cell, NSString *photoName) {
        [cell configureForPhoto:photoName];
    };
    self.photosArrayDataSource = [[MPArrayDataSource alloc] initWithItems:self.dataArray
                                                         cellIdentifier:NSStringFromClass([MPPhotoCell class])
                                                     configureCellBlock:configureCell];
    self.myTableView.dataSource = self.photosArrayDataSource;
    [self.myTableView registerClass:[MPPhotoCell class] forCellReuseIdentifier:NSStringFromClass([MPPhotoCell class])];
}


#pragma mark UITableViewDelegate内容

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"当前的名称：%@",self.dataArray[indexPath.row]);
}

@end
