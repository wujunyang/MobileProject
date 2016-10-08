//
//  MPJavaScriptCoreViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/10/8.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPJavaScriptCoreViewController.h"

@interface MPJavaScriptCoreViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation MPJavaScriptCoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor grayColor];
    
    [self.view addSubview:self.webView];
    
    //  // 一个JSContext对象，就类似于Js中的window，只需要创建一次即可。
    //  self.jsContext = [[JSContext alloc] init];
    //
    //  // jscontext可以直接执行JS代码。
    //  [self.jsContext evaluateScript:@"var num = 10"];
    //  [self.jsContext evaluateScript:@"var squareFunc = function(value) { return value * 2 }"];
    //  // 计算正方形的面积
    //  JSValue *square = [self.jsContext evaluateScript:@"squareFunc(num)"];
    //
    //  // 也可以通过下标的方式获取到方法
    //  JSValue *squareFunc = self.jsContext[@"squareFunc"];
    //  JSValue *value = [squareFunc callWithArguments:@[@"20"]];
    //  NSLog(@"%@", square.toNumber);
    //  NSLog(@"%@", value.toNumber);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 重写BaseViewController设置内容

//设置导航栏背景色
-(UIColor*)set_colorBackground
{
    return [UIColor whiteColor];
}

////设置标题
-(NSMutableAttributedString*)setTitle
{
    return [self changeTitle:@"JavaScriptCore运用"];
}

//设置左边按键
-(UIButton*)set_leftButton
{
    UIButton *left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [left_button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
    return left_button;
}

//设置左边事件
-(void)left_button_event:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 通过模型调用方法，这种方式更好些。
    MPJavaScriptModel *model  = [[MPJavaScriptModel alloc] init];
    self.jsContext[@"OCModel"] = model;
    model.jsContext = self.jsContext;
    model.webView = self.webView;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.scalesPageToFit = YES;
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        _webView.delegate = self;
    }
    
    return _webView;
}

@end
