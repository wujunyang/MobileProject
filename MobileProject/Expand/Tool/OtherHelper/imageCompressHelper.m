//
//  imageCompressHelper.m
//  zxptUser
//
//  Created by wujunyang on 16/4/14.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "imageCompressHelper.h"

@implementation imageCompressHelper

+(UIImage*)compressedImageToLimitSizeOfKB:(CGFloat)kb image:(UIImage*)image
{
    //大于多少kb的图片需要压缩
    long imagePixel = CGImageGetWidth(image.CGImage)*CGImageGetHeight(image.CGImage);
    long imageKB = imagePixel * CGImageGetBitsPerPixel(image.CGImage) / (8 * 1024);
    if (imageKB > kb){
        float compressedParam = kb / imageKB;
        return [UIImage imageWithData:UIImageJPEGRepresentation(image, compressedParam)];
    }
    //返回原图
    else{
        return image;
    }
}

+(NSData*)returnDataCompressedImageToLimitSizeOfKB:(CGFloat)kb image:(UIImage*)image
{
    //大于多少kb的图片需要压缩
    long imagePixel = CGImageGetWidth(image.CGImage)*CGImageGetHeight(image.CGImage);
    long imageKB = imagePixel * CGImageGetBitsPerPixel(image.CGImage) / (8 * 1024);
    if (imageKB > kb){
        float compressedParam = kb / imageKB;
        return UIImageJPEGRepresentation(image, compressedParam);
    }
    //返回原图
    else{
        return UIImageJPEGRepresentation(image, 1);
    }
}


+(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset
{
    //UIGraphicsBeginImageContext(image.size);
    //解决失真 模糊的问题
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //圆的边框宽度为2，颜色为红色
    
    CGContextSetLineWidth(context,2);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    //在圆区域内画出image原图
    
    [image drawInRect:rect];
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextStrokePath(context);
    
    //生成新的image
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
}

@end
