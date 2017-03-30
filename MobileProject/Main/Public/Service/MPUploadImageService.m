//
//  MPUploadImageService.m
//  MobileProject
//
//  Created by wujunyang on 16/7/21.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPUploadImageService.h"

@interface MPUploadImageService()
{
    MPUploadImageHelper *_model;
}
@end

@implementation MPUploadImageService

- (instancetype)initWithUploadImages:(MPUploadImageHelper *)model{
    
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
    
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSTimeInterval)requestTimeoutInterval
{
    return 60;
}

-(SERVERCENTER_TYPE)centerType
{
    return PICTURE_SERVERCENTER;
}

- (NSString *)requestUrl {
    return @"upload-image";
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        for (MPImageItemModel *imageItem in _model.imagesArray) {
            NSData *data = UIImageJPEGRepresentation(imageItem.image, 0.9);
            NSString *name = @"files";
            NSString *formKey = imageItem.photoName?:@"image.jpg";
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:name fileName:formKey mimeType:type];
        }
    };
}

@end
