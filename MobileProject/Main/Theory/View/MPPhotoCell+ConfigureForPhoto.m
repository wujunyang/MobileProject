//
//  MPPhotoCell+ConfigureForPhoto.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/31.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPPhotoCell+ConfigureForPhoto.h"

@implementation MPPhotoCell (ConfigureForPhoto)

- (void)configureForPhoto:(NSString *)photoName
{
    self.myNameLabel.text=photoName;
}

@end
