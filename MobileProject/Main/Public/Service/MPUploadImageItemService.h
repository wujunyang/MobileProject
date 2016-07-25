//
//  MPUploadImageItemService.h
//  MobileProject
//
//  Created by wujunyang on 16/7/25.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPImageItemModel.h"

@interface MPUploadImageItemService : BaseRequestService

- (instancetype)initWithUploadImageItem:(MPImageItemModel *)model;

@end
