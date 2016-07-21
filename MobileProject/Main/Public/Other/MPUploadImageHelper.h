//
//  MPUploadImageHelper.h
//  MobileProject
//
//  Created by wujunyang on 16/7/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPImageItemModel.h"

@interface MPUploadImageHelper : NSObject

//不要直接操作imagesArray 在操作selectedAssetURLs时会利用KVO直接操作
@property (readwrite, nonatomic, strong) NSMutableArray *imagesArray;
@property (readwrite, nonatomic, strong) NSMutableArray *selectedAssetURLs;


- (void)addASelectedAssetURL:(NSURL *)assetURL;
- (void)deleteASelectedAssetURL:(NSURL *)assetURL;
- (void)deleteAImage:(MPImageItemModel *)imageInfo;

+(MPUploadImageHelper *)MPUploadImageForSend;

@end
