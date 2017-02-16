//
//  MPRunTimeTest+Other.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/10.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPRunTimeTest+Other.h"

@implementation MPRunTimeTest (Other)

static char mpWorkNameKey;

- (void) setWorkName:(NSString *) workName
{
    objc_setAssociatedObject(self,&mpWorkNameKey, workName, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    //对应的类型ASSIGN RETAIN_NONATOMIC COPY_NONATOMIC RETAIN COPY
    //OBJC_ASSOCIATION_ASSIGN
    //OBJC_ASSOCIATION_RETAIN_NONATOMIC
    //OBJC_ASSOCIATION_COPY_NONATOMIC
    //OBJC_ASSOCIATION_RETAIN
    //OBJC_ASSOCIATION_COPY
}

- (NSString *) getWorkName
{
    return objc_getAssociatedObject(self, &mpWorkNameKey);
}

@end
