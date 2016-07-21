//
//  MPMoreViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/7/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPMoreViewController.h"

@interface MPMoreViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) NSArray             *dataArray;
@property (nonatomic,strong) UITableView         *myTableView;
@end


@implementation MPMoreViewController



#pragma mark 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"功能导航";

    if (!self.dataArray) {
        self.dataArray=@[@"JSPatch热更新",@"LKDB数据库运用",@"百度地图",@"二维码",@"照片上传"];
    }

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

    switch (indexPath.row) {
        case 0:
        {
            JSPatchViewController *vc=[[JSPatchViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            case 1:
        {
            MPLkdbViewController *vc=[[MPLkdbViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            case 2:
        {
            BaiDuMapViewController *vc=[[BaiDuMapViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            case 3:
        {
            MPQRCodeViewController *vc=[[MPQRCodeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            case 4:
        {
            MPUploadImagesViewController *vc=[[MPUploadImagesViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}


@end
