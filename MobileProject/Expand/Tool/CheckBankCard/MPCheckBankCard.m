//
//  MPCheckBankCard.m
//  MobileProject
//
//  Created by 韩学鹏 on 16/6/17.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPCheckBankCard.h"

@implementation MPCheckBankCard

+ (BOOL)checkBankCard:(NSString *)cardId
{
    cardId = [cardId stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //位数校验
    if (cardId.length == 16 || cardId.length == 19) {
        
    } else {
        return NO;
    }
    
    char bit = [self getBankCardCheckCode:[cardId substringToIndex:cardId.length - 1]];
    if (bit == 'N') {
        return NO;
    } else {
        return [cardId characterAtIndex:cardId.length - 1] == bit;
    }
}

+ (char)getBankCardCheckCode:(NSString *)nonCheckCodeCardId
{
    if (nonCheckCodeCardId == nil || [self isEmptyString:nonCheckCodeCardId] || ![self isNo:nonCheckCodeCardId]) {
        return 'N';
    }
    const char *chs = [nonCheckCodeCardId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].UTF8String;
    int luhmSum = 0;
    for (int i = (int)strlen(chs) - 1, j = 0; i >= 0; i--, j++) {
        int k = chs[i] - '0';
        if (j % 2 == 0) {
            k *= 2;
            k = k / 10 + k % 10;
        }
        luhmSum += k;
    }
    return (luhmSum % 10 == 0) ? '0' : (char) ((10 - luhmSum % 10) + '0');
}

+ (BOOL)isNo:(NSString *)no
{
    NSString *carRegex = @"\\d+";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:no];
}

+ (BOOL)isEmptyString:(NSString *)str
{
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

@end
