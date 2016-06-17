//
//  UIImage+QR.h
//  MobileProject
//
//  Created by 韩学鹏 on 16/6/17.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QR)


/**
 *  使用字符串生成二维码
 *
 *  @param qrString 需要生成二维码的字符串
 *  @param size     图片尺寸
 *  @param red      red description
 *  @param green    green description
 *  @param blue     blue description
 *
 *  @return return value description
 */
+ (UIImage *)qrCodeImageWithString:(NSString *)qrString withSize:(CGFloat)size withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

@end
