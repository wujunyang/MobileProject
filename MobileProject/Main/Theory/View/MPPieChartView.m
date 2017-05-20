//
//  MPPieChartView.m
//  MobileProject
//
//  Created by wujunyang on 2017/5/19.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPPieChartView.h"

@implementation MPPieChartView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    NSArray *arry = @[@300,@232.233,@324.324,@34,@4352,@43.0];
    
    //    计算数组中所有数值之和
    CGFloat sumValue = [[arry valueForKeyPath:@"@sum.floatValue"] floatValue];
    
    //设定圆弧的圆点、起始弧度
    CGPoint origin = CGPointMake(80, 80);
    CGFloat startAngle = 0;
    CGFloat endAngle = 0;
    
    
    for (NSInteger i = 0 ; i < arry.count; i++) {
        
        //        每个数据的弧度
        CGFloat angle = [arry[i] floatValue] * M_PI * 2 / sumValue;
        
        //        计算这一段弧度的结束为止
        endAngle = startAngle + angle;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:origin radius:40 startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        //        计算下一段弧度开始的位置
        startAngle = endAngle;
        
        //        从弧边，绘制到原点。用于封闭路径，可以绘制扇形
        [path addLineToPoint:origin];
        //        给扇形添加随机色
        [[self randomUIColor] set];
        [path fill];
    }
    
}

- (UIColor *)randomUIColor{
    UIColor *color = [UIColor colorWithRed:(arc4random_uniform(256) / 255.0) green:(arc4random_uniform(256) / 255.0) blue:(arc4random_uniform(256) / 255.0) alpha:(arc4random_uniform(256) / 255.0)];
    return color;
}
//触屏后重新渲染
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setNeedsDisplay];
}

@end
