//
//  MPBarChartView.m
//  MobileProject
//
//  Created by wujunyang on 2017/5/19.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPBarChartView.h"

#define BAR_HEIGHT_COEFFICIENT 0.9

@implementation MPBarChartView

- (void)drawRect:(CGRect)rect{
    NSArray *arry = @[@300,@232.233,@324.324,@34,@435,@43.0];
    
    //    计算bar的宽度
    CGFloat barW = self.bounds.size.width / (arry.count * 2 - 1);
    
    //    找出数组中的最大数值
    CGFloat maxValue = [[arry valueForKeyPath:@"@max.floatValue"] floatValue];
    
    for (NSInteger i = 0; i < arry.count; i++) {
        //        计算bar的高度
        CGFloat barH = [arry[i] floatValue] * (self.bounds.size.height * BAR_HEIGHT_COEFFICIENT/ maxValue);
        
        //        计算bar的XY
        CGFloat barX = barW * i * 2;
        CGFloat barY = self.bounds.size.height - barH;
        
        //        绘制矩形
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(barX, barY, barW, barH)];
        
        //        给矩形添加随机色
        [[self randomUIColor] set];
        
        [path fill];
        
        
    }
}

- (UIColor *)randomUIColor{
    UIColor *color = [UIColor colorWithRed:(arc4random_uniform(256) / 255.0) green:(arc4random_uniform(256) / 255.0) blue:(arc4random_uniform(256) / 255.0) alpha:(arc4random_uniform(256) / 255.0)];
    return color;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self setNeedsDisplay];
}

@end
