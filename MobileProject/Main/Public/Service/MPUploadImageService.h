//
//  MPUploadImageService.h
//  MobileProject  批量上传图片请求类
//
//  Created by wujunyang on 16/7/21.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPUploadImageHelper.h"

@interface MPUploadImageService : BaseRequestService

- (instancetype)initWithUploadImages:(MPUploadImageHelper *)model;

@end
