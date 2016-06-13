//
//  JSPatchHelper.m
//  MobileProject
//
//  Created by wujunyang on 16/6/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "JSPatchHelper.h"

NSString * const jsPatchJsFileName=@"main.js";

@implementation JSPatchHelper

+ (instancetype)sharedInstance
{
    static JSPatchHelper* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JSPatchHelper new];
    });

    return instance;
}


+(void)HSDevaluateScript
{
    //从本地获取下载的JS文件
    NSURL *p = FilePath;
    //获取内容
    NSString *js = [NSString stringWithContentsOfFile:[p.path stringByAppendingString:[NSString stringWithFormat:@"/%@",jsPatchJsFileName]] encoding:NSUTF8StringEncoding error:nil];
    
    //如果有内容
    if (js.length > 0)
    {
        //-------
        //服务端要对JS内容进行加密，在此处解密js内容；增加安全性
        //----
        
        
        //运行
        [JPEngine startEngine];
        [JPEngine evaluateScript:js];
    }
}


+(void)loadJSPatch
{
    //使用AFNetWork下载在服务器的js文件
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:kJSPatchServerPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
                                              {
                                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                                                  if (httpResponse.statusCode==200) {
                                                      NSURL *documentsDirectoryURL = FilePath;
                                                      //保存到本地 Library/Caches目录下
                                                      return [documentsDirectoryURL URLByAppendingPathComponent:jsPatchJsFileName];
                                                  }
                                                  else
                                                  {
                                                      return nil;
                                                  }
                                              }
                                                            completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
                                              {
                                                  NSLog(@"下载失败 to: %@", filePath);
                                              }];
    [downloadTask resume];
}


@end
