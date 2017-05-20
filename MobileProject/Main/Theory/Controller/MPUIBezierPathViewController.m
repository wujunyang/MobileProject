//
//  MPUIBezierPathViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/4/7.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPUIBezierPathViewController.h"
#import "MPBarChartView.h"
#import "MPPieChartView.h"

@interface MPUIBezierPathViewController ()<CAAnimationDelegate>
{
    UIView *_view;
}

@end

@implementation MPUIBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self drawLine];
    
    [self drawRounded];
    
    [self drawFillRounded];
    
    [self drawTriangle];
    
    [self drawFillTriangle];
    
    [self drawCurvedLine];
    
    [self drawRectangle];
    
    [self drawDottedLine];
    
    [self drawTick];
    
    [self Bubble];
    
    [self circleAnimation];
    
    
    //画柱状图
    MPBarChartView *barChartView=[[MPBarChartView alloc]initWithFrame:CGRectMake(20, 440, 200, 150)];
    barChartView.backgroundColor=[UIColor grayColor];
    [self.view addSubview:barChartView];
    
    //画饼图
    MPPieChartView *pieChartView=[[MPPieChartView alloc]initWithFrame:CGRectMake(230, 350, 150, 150)];
    pieChartView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:pieChartView];
}


//画直线
-(void)drawLine
{
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    //两点
    [aPath moveToPoint:CGPointMake(30, 130)];
    [aPath addLineToPoint:CGPointMake(30, 200)];
    //绘制
    [aPath stroke];
    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path=aPath.CGPath;
    shapeLayer.strokeColor=[UIColor redColor].CGColor;
    shapeLayer.fillColor=[UIColor redColor].CGColor;
    shapeLayer.lineWidth=10;
    
    [self.view.layer addSublayer:shapeLayer];
    
}

//画三角形
-(void)drawTriangle
{
    UIBezierPath *aPath=[UIBezierPath bezierPath];
    
    [aPath moveToPoint:CGPointMake(50, 170)];
    [aPath addLineToPoint:CGPointMake(80, 130)];
    [aPath addLineToPoint:CGPointMake(80, 200)];
    [aPath stroke];
    [aPath closePath];
    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path=aPath.CGPath;
    shapeLayer.strokeColor=[UIColor redColor].CGColor;
    shapeLayer.fillColor=[UIColor clearColor].CGColor;
    shapeLayer.lineWidth=3;
    
    [self.view.layer addSublayer:shapeLayer];
}


//画实心三角形
-(void)drawFillTriangle
{
    UIBezierPath *aPath=[UIBezierPath bezierPath];
    
    [aPath moveToPoint:CGPointMake(110, 170)];
    [aPath addLineToPoint:CGPointMake(140, 130)];
    [aPath addLineToPoint:CGPointMake(140, 200)];
    
    [aPath stroke];
    [aPath closePath];
    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path=aPath.CGPath;
    shapeLayer.strokeColor=[UIColor redColor].CGColor;
    shapeLayer.fillColor=[UIColor blueColor].CGColor;
    shapeLayer.lineWidth=3;
    //交叉处特别处理 微圆角
    shapeLayer.lineJoin=kCALineJoinRound;
    
    [self.view.layer addSublayer:shapeLayer];
}

//画空心圆
-(void)drawRounded
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(40, 70, 60, 60) cornerRadius:30];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor purpleColor].CGColor;
    
    [self.view.layer addSublayer:layer];
}

//画实心圆
-(void)drawFillRounded
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(110, 70, 60, 60) cornerRadius:30];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor redColor].CGColor;
    layer.strokeColor = [UIColor purpleColor].CGColor;
    
    [self.view.layer addSublayer:layer];
}


//画一个弧线
-(void)drawCurvedLine
{
    UIBezierPath* aPath = [UIBezierPath bezierPath];

    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    [aPath moveToPoint:CGPointMake(100, 200)]; //左边点
    [aPath addQuadCurveToPoint:CGPointMake(200, 200) controlPoint:CGPointMake(150, 100)]; //右边点  中间点
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor=[UIColor blueColor].CGColor;
    layer.fillColor=[UIColor clearColor].CGColor;
    layer.path=aPath.CGPath;
    
    [self.view.layer addSublayer:layer];
}

//空心矩形
-(void)drawRectangle
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 250, 100, 80)];
    layer.path = path.CGPath;
    //填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    //边框颜色
    layer.strokeColor = [UIColor blackColor].CGColor;
    
    [self.view.layer addSublayer:layer];
}


//画虚线
-(void)drawDottedLine
{
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    //两点
    [aPath moveToPoint:CGPointMake(200, 130)];
    [aPath addLineToPoint:CGPointMake(320, 130)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth=1;
    layer.strokeColor=[UIColor blackColor].CGColor;
    layer.path=aPath.CGPath;
    layer.lineDashPattern=@[@3,@1]; //3=线的宽度 1=每条线的间距
    [self.view.layer addSublayer:layer];
}


//打勾效果
-(void)drawTick
{
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    //两点
    [aPath moveToPoint:CGPointMake(200, 280)];
    [aPath addLineToPoint:CGPointMake(240, 310)];
    [aPath addLineToPoint:CGPointMake(300, 220)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth=3;
    layer.strokeColor=[UIColor blueColor].CGColor;
    layer.fillColor=[UIColor clearColor].CGColor;
    layer.path=aPath.CGPath;
    //交叉处特别处理 微圆角
    layer.lineJoin=kCALineJoinRound;
    //直线头部的 微圆角效果
    layer.lineCap=kCALineCapRound;

    [self.view.layer addSublayer:layer];
}


//气泡
-(void)Bubble
{
    CAShapeLayer *rectangleLayer = [CAShapeLayer layer];
    
    //画个矩形 然后设置其四个角的圆形 也可以单个或多个设置UIRectCornerTopLeft ||UIRectCornerTopRight....
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 340, 100, 80) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    rectangleLayer.path = path.CGPath;
    //填充颜色
    rectangleLayer.fillColor = [UIColor redColor].CGColor;
    //边框颜色
    rectangleLayer.strokeColor = [UIColor blackColor].CGColor;
    rectangleLayer.lineJoin=kCALineCapRound;
    [self.view.layer addSublayer:rectangleLayer];
    
    
    CAShapeLayer *fillTriangleLayer=[CAShapeLayer layer];
    
    UIBezierPath *aPath=[UIBezierPath bezierPath];
    [aPath moveToPoint:CGPointMake(50, 418)];
    [aPath addLineToPoint:CGPointMake(70, 418)];
    [aPath addLineToPoint:CGPointMake(60, 435)];
    [aPath stroke];
    [aPath closePath];
    
    fillTriangleLayer.path=aPath.CGPath;
    fillTriangleLayer.fillColor=[UIColor redColor].CGColor;
    
    [self.view.layer addSublayer:fillTriangleLayer];
    
}


//画动画效果的圆
-(void)circleAnimation{
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(260, 170, 60, 60) cornerRadius:30];
    
    layer.path = path.CGPath;
    layer.lineWidth=5;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor purpleColor].CGColor;
    
    [self.view.layer addSublayer:layer];
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = 5;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    checkAnimation.delegate = self;
    [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    [layer addAnimation:checkAnimation forKey:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self changeTitle:@"CAShapeLayer与UIBezierPath知识运用"];
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

#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}


@end
