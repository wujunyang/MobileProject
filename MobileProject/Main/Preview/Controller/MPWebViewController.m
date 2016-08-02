//
//  MPWebViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/8/1.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPWebViewController.h"

@interface MPWebViewController()<UIWebViewDelegate>
@property WebViewJavascriptBridge* bridge;
@property(nonatomic,strong)UIWebView *myWebView;
@end


@implementation MPWebViewController

#pragma mark 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"与H5进行交互";
    
    //布局
    [self layoutWebPage];
    
    //加载Html页面
    [self loadExamplePage];

    //注册Handler代码
    [self registerHandlerCode];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"开启加载");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"结束加载");
}


#pragma mark 自定义代码

//布局视图
-(void)layoutWebPage
{
    //初始化webView
    if (!self.myWebView) {
        self.myWebView=[[UIWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:self.myWebView];
    }
    
    if (_bridge) {
        return;
    }
    
    //开启调试
    [WebViewJavascriptBridge enableLogging];
    
    //web桥接器初始化
    _bridge=[WebViewJavascriptBridge bridgeForWebView:self.myWebView];
    [_bridge setWebViewDelegate:self];
}

//加载实例Html
-(void)loadExamplePage
{
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    if(htmlPath.length==0)
    {
        return;
    }
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [self.myWebView loadHTMLString:appHtml baseURL:baseURL];
}

//注册调用JS事件
-(void)registerHandlerCode
{
    if (!_bridge) {
        return;
    }
    
    //JS根据mpTestObjcCallBack来调用OC的代码并回调给JS
    [_bridge registerHandler:@"mpTestObjcCallBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"获得到的内容为：%@",data);
        
        responseCallback(@"Response From mpTestObjecCallBack");
    }];
    
    //OC调用JS中的Handler为jsTestObjcCallBack的代码
    [_bridge callHandler:@"jsTestObjcCallBack" data:@{ @"name":@"wujunyang" }];
    
    //OC调用JS中的Handler为jsTestObjcCallBack的代码 并接受JS传回的回调内容
    [_bridge callHandler:@"jsTestObjcCallBack" data:@{ @"password":@"123456" } responseCallback:^(id responseData) {
        NSLog(@"JS回调的内容为：%@",responseData);
    }];
}

@end
