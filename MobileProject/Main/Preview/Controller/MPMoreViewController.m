//
//  MPMoreViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/7/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPMoreViewController.h"
#import "YYFPSLabel.h"

@interface MPMoreViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) NSArray             *dataArray;
@property (nonatomic,strong) UITableView         *myTableView;

@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end


@implementation MPMoreViewController



#pragma mark 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"功能导航";
    
    if (!self.dataArray) {
        self.dataArray=@[@"JSPatch热更新",@"LKDB数据库运用",@"百度地图",@"二维码",@"照片上传",@"照片上传附带进度",@"字体适配机型",@"日志记录",@"列表倒计时",@"H5交互WebViewJavascriptBridge",@"继承BaseViewController运用",@"列表空白页展现",@"省市区三级联动",@"自定义弹出窗",@"YYText富文本实例",@"列表行展开跟回收隐藏",@"常见表单行类型" ,@"人脸识别注册及验证",@"JavaScriptCore运用",@"viewController生命周期",@"Masonry布局实例",@"键盘处理操作"];
    }
    
    //弹出提示
    [self showNewStatusesCount:self.dataArray.count];
    
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
    
    
    if (!_fpsLabel) {
        _fpsLabel = [YYFPSLabel new];
        _fpsLabel.frame=CGRectMake(20, 80, 30, 30);
        [_fpsLabel sizeToFit];
        _fpsLabel.alpha = 0.6;
        [self.view addSubview:_fpsLabel];
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
            case 5:
        {
            MPUploadWithPropressViewController *vc=[[MPUploadWithPropressViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 6:
        {
            MPAdaptationFontViewController *vc=[[MPAdaptationFontViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 7:
        {
            LoggerViewController *vc=[[LoggerViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 8:
        {
            MPReduceTimeViewController *vc=[[MPReduceTimeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 9:
        {
            MPWebViewController *vc=[[MPWebViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 10:
        {
            MPChildrenViewController *vc=[[MPChildrenViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 11:
        {
            MPBlankPageViewController *vc=[[MPBlankPageViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 12:
        {
            MPAddressPickViewController *vc=[[MPAddressPickViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 13:
        {
            MPCustomAlertViewController *vc=[[MPCustomAlertViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 14:
        {
            MPYYTextViewController *vc=[[MPYYTextViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 15:
        {
            MPExpandHideViewController *vc=[[MPExpandHideViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 16:
        {
            MPFormViewController *vc=[[MPFormViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            case 17:
        {
            [self.navigationController pushViewController:[NSClassFromString(@"FaceRecognitionController") new] animated:YES];
            break;
        }
            case 18:
        {
            MPJavaScriptCoreViewController *vc=[[MPJavaScriptCoreViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            case 19:
        {
            MPViewControllerLifeCycle *vc=[[MPViewControllerLifeCycle alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            case 20:
        {
            MPMasonryViewController *vc=[[MPMasonryViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 21:
        {
            MPKeyboardViewController *vc=[[MPKeyboardViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}


#pragma mark 自定义代码

- (void)showNewStatusesCount:(NSInteger)count
{
    // 1.创建一个UILabel
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    
    // 2.显示文字
    if (count) {
        label.text = [NSString stringWithFormat:@"共有%ld条实例数据", count];
    } else {
        label.text = @"没有最新的数据";
    }
    
    // 3.设置背景
    label.backgroundColor = [UIColor colorWithRed:254/255.0  green:129/255.0 blue:0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    // 4.设置frame
    label.width = self.view.frame.size.width;
    label.height = 35;
    label.x = 0;
    label.y = CGRectGetMaxY([self.navigationController navigationBar].frame) - label.frame.size.height;
    
    // 5.添加到导航控制器的view
    //[self.navigationController.view addSubview:label];
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 6.动画
    CGFloat duration = 0.75;
    //label.alpha = 0.0;
    [UIView animateWithDuration:duration animations:^{
        // 往下移动一个label的高度
        label.transform = CGAffineTransformMakeTranslation(0, label.frame.size.height);
        //label.alpha = 1.0;
    } completion:^(BOOL finished) { // 向下移动完毕
        
        // 延迟delay秒后，再执行动画
        CGFloat delay = 1.0;
        
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            // 恢复到原来的位置
            label.transform = CGAffineTransformIdentity;
            //label.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            // 删除控件
            [label removeFromSuperview];
        }];
    }];
}

@end
