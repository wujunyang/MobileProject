//
//  MPTagAttribute.m
//  MobileProject
//
//  Created by wujunyang on 2017/6/2.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPTagAttribute.h"

@implementation MPTagAttribute

- (instancetype)init
{
    self = [super init];
    if (self) {
        int r = arc4random() % 255;
        int g = arc4random() % 255;
        int b = arc4random() % 255;
        
        UIColor *normalColor = [UIColor colorWithRed:b/255.0 green:r/255.0 blue:g/255.0 alpha:1.0];
        UIColor *normalBackgroundColor = [UIColor whiteColor];
        UIColor *selectedBackgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        
        _borderWidth = 0.5f;
        _borderColor = normalColor;
        _cornerRadius = 2.0;
        _normalBackgroundColor = normalBackgroundColor;
        _selectedBackgroundColor = selectedBackgroundColor;
        _titleSize = 14;
        _textColor = normalColor;
        _keyColor = [UIColor redColor];
        _tagSpace = 20;
    }
    return self;
}

@end
