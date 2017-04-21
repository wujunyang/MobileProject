//
//  MPContextView.m
//  MobileProject
//
//  Created by wujunyang on 2017/4/21.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPContextView.h"

@implementation MPContextView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
    }
    return self;
}


-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(ctx, 135.0/255.0, 232.0/255.0, 84.0/255.0, 1);
    CGContextSetRGBStrokeColor(ctx, 135.0/255.0, 232.0/255.0, 84.0/255.0, 1);
    //CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
    //CGContextFillEllipseInRect(ctx, CGRectMake(50, 50, 100, 100));
    CGContextMoveToPoint(ctx, 94.5, 33.5);
    
    //// Star Drawing
    CGContextAddLineToPoint(ctx,104.02, 47.39);
    CGContextAddLineToPoint(ctx,120.18, 52.16);
    CGContextAddLineToPoint(ctx,109.91, 65.51);
    CGContextAddLineToPoint(ctx,110.37, 82.34);
    CGContextAddLineToPoint(ctx,94.5, 76.7);
    CGContextAddLineToPoint(ctx,78.63, 82.34);
    CGContextAddLineToPoint(ctx,79.09, 65.51);
    CGContextAddLineToPoint(ctx,68.82, 52.16);
    CGContextAddLineToPoint(ctx,84.98, 47.39);
    CGContextClosePath(ctx);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

//操作说明：
//CGContextRef context = UIGraphicsGetCurrentContext();	设置上下文
//CGContextMoveToPoint	开始画线
//CGContextAddLineToPoint	画直线
//CGContextAddEllipseInRect	画一椭圆
//CGContextSetLineCap	设置线条终点形状
//CGContextSetLineDash	画虚线
//CGContextAddRect	画一方框
//CGContextStrokeRect	指定矩形
//CGContextStrokeRectWithWidth	指定矩形线宽度
//CGContextStrokeLineSegments	一些直线
//CGContextAddArc	画已曲线 前俩店为中心 中间俩店为起始弧度 最后一数据为0则顺时针画 1则逆时针
//CGContextAddArcToPoint(context,0,0, 2, 9, 40);	先画俩条线从point 到 第1点 ， 从第1点到第2点的线 切割里面的圆
//CGContextSetShadowWithColor	设置阴影
//CGContextSetRGBFillColor	这只填充颜色
//CGContextSetRGBStrokeColor	画笔颜色设置
//CGContextSetFillColorSpace	颜色空间填充
//CGConextSetStrokeColorSpace	颜色空间画笔设置
//CGContextFillRect	补充当前填充颜色的rect
//CGContextSetAlaha	透明度
//CGContextTranslateCTM	改变画布位置
//CGContextSetLineWidth	设置线的宽度
//CGContextAddRects	画多个线
//CGContextAddQuadCurveToPoint	画曲线
//CGContextStrokePath	开始绘制图片
//CGContextDrawPath	设置绘制模式
//CGContextClosePath	封闭当前线路
//CGContextTranslateCTM(context, 0, rect.size.height); CGContextScaleCTM(context, 1.0, -1.0);	反转画布
//CGContextSetInterpolationQuality	背景内置颜色质量等级
//CGImageCreateWithImageInRect	从原图片中取小图
//CGColorGetComponents（）	返回颜色的各个直 以及透明度 可用只读const float 来接收 是个数组
//CGContextEOFillPath	使用奇偶规则填充当前路径
//CGContextFillPath	使用非零绕数规则填充当前路径
//CGContextFillRect	填充指定的矩形
//CGContextFillRects	填充指定的一些矩形
//CGContextFillEllipseInRect	填充指定矩形中的椭圆
//CGContextDrawPath	两个参数决定填充规则，
//kCGPathFill	表示用非零绕数规则，
//kCGPathEOFill	表示用奇偶规则，
//kCGPathFillStroke	表示填充
//kCGPathEOFillStroke	表示描线，不是填充
//CGContextSetBlendMode	设置blend mode.
//CGContextSaveGState	保存blend mode.
//CGContextRestoreGState	在没有保存之前，用这个函数还原blend mode.
//CGContextSetBlendMode	混合俩种颜色



//1：写文字
//
//- (void)drawRect:(CGRect)rect
//{
//    //获得当前画板
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    //颜色
//    CGContextSetRGBStrokeColor(ctx, 0.2, 0.2, 0.2, 1.0);
//    //画线的宽度
//    CGContextSetLineWidth(ctx, 0.25);
//    //开始写字
//    [@"我是文字" drawInRect:CGRectMake(10, 10, 100, 30) withFont:font];
//    [super drawRect:rect];
//}
//
//
//2：画直线
//
//- (void)drawRect:(CGRect)rect
//{
//    //获得当前画板
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    //颜色
//    CGContextSetRGBStrokeColor(ctx, 0.2, 0.2, 0.2, 1.0);
//    //画线的宽度
//    CGContextSetLineWidth(ctx, 0.25);
//    //顶部横线
//    CGContextMoveToPoint(ctx, 0, 10);
//    CGContextAddLineToPoint(ctx, self.bounds.size.width, 10);
//    CGContextStrokePath(ctx);
//    [super drawRect:rect];
//}
//
//
//3：画圆
//
//- (void)drawRect:(CGRect)rect
//{
//    //获得当前画板
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    //颜色
//    CGContextSetRGBStrokeColor(ctx, 0.2, 0.2, 0.2, 1.0);
//    //画线的宽度
//    CGContextSetLineWidth(ctx, 0.25);
//    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
//    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
//    CGContextAddArc(ctx, 100, 20, 20, 0, 2*M_PI, 0); //添加一个圆
//    CGContextDrawPath(ctx, kCGPathStroke); //绘制路径
//    [super drawRect:rect];
//}
//
//4：画矩形
//
//- (void)drawRect:(CGRect)rect
//{
//    //获得当前画板
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    //颜色
//    CGContextSetRGBStrokeColor(ctx, 0.2, 0.2, 0.2, 1.0);
//    //画线的宽度
//    CGContextSetLineWidth(ctx, 0.25);
//    CGContextAddRect(ctx, CGRectMake(2, 2, 30, 30));
//    CGContextStrokePath(ctx);
//    [super drawRect:rect];
//}


@end
