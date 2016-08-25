//
//  FaceRecognitionController.m
//  MobileProject
//
//  Created by pro－cookie on 16/8/12.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "FaceRecognitionController.h"
#import "FaceStreamDetectorViewController.h"

@interface FaceRecognitionController()<FaceDetectorDelegate>
{
    UIImageView *imgView;
    UILabel *label;
}


@end


@implementation FaceRecognitionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    self.navigationItem.title = @"人脸识别";
    [self createView];
}
- (void)createView {
    [self buttonWithTitle:@"验证" frame:CGRectMake(CGRectGetMinX(self.view.frame) + 50, CGRectGetMinX(self.view.frame) + 80, 100, 30) action:@selector(check) AddView:self.view];
    [self buttonWithTitle:@"注册" frame:CGRectMake(CGRectGetMaxX(self.view.frame) - 50 - 100, CGRectGetMinX(self.view.frame) + 80, 100, 30) action:@selector(regis) AddView:self.view];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, [UIScreen mainScreen].bounds.size.width, 70)];
    label.numberOfLines = 0;
    label.text = @"请先注册，直接验证会报错，同一人验证匹配度在94以上，非同一人匹配度在45左右，右边按钮为注册，左边为验证";
    label.backgroundColor = [UIColor colorWithRed:0.453 green:0.750 blue:1.000 alpha:1.000];
    [self.view addSubview:label];
    
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 220, self.view.frame.size.width-100, 300)];
    imgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imgView];
}
-(void)sendFaceImage:(UIImage *)faceImage
{
    imgView.image = faceImage;
}
- (void)regis {
    label.text = @"";
    FaceStreamDetectorViewController *faceVC = [[FaceStreamDetectorViewController alloc]init];
    faceVC.faceDelegate = self;
    [self.navigationController pushViewController:faceVC animated:YES];
    faceVC.isController = NSTypePaiZhao;
    faceVC.sendBlock = ^(NSString *resultInfo) {
        label.text = resultInfo;
    };
    
}
-(void)check
{
    label.text = @"";
    FaceStreamDetectorViewController *faceVC = [[FaceStreamDetectorViewController alloc]init];
    faceVC.faceDelegate = self;
    [self.navigationController pushViewController:faceVC animated:YES];
    faceVC.isController = NSTypeYanZhen;
    faceVC.sendBlock = ^(NSString *resultInfo) {
        label.text = resultInfo;
    };
}

#pragma mark --- 创建button公共方法
-(UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action AddView:(id)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.backgroundColor = [UIColor colorWithRed:0.601 green:0.596 blue:0.906 alpha:1.000];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    [view addSubview:button];
    return button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
