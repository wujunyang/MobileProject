//
//  MPUploadImageItemService.m
//  MobileProject
//
//  Created by wujunyang on 16/7/25.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPUploadImageItemService.h"


@interface MPUploadImageItemService()
{
    MPImageItemModel *_model;
}
@end

@implementation MPUploadImageItemService

- (instancetype)initWithUploadImageItem:(MPImageItemModel *)model
{
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
    return @"";
}

- (AFConstructingBlock)constructingBodyBlock {
    if (_model.image) {
        return ^(id<AFMultipartFormData> formData) {
            NSData *data = UIImageJPEGRepresentation(_model.image, 0.9);
            NSString *name = @"files";
            NSString *formKey = _model.photoName?:@"image.jpg";
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:name fileName:formKey mimeType:type];
        };
    }
    else
    {
        return nil;
    }
}

@end
