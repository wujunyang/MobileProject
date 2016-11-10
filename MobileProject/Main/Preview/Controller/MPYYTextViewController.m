//
//  MPYYTextViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/8/8.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPYYTextViewController.h"

@interface MPYYTextViewController()

@end


@implementation MPYYTextViewController


#pragma mark viewController生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    [self layoutPageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    return [self changeTitle:@"YYText实例效果"];
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


#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}

-(void)layoutPageView
{
    //1：YYLable普通显示
    YYLabel *lable=[[YYLabel alloc]init];
    lable.frame=CGRectMake(10, 100, Main_Screen_Width-20, 30);
    lable.font=CHINESE_SYSTEM(14);
    lable.textColor=[UIColor redColor];
    lable.textAlignment=NSTextAlignmentLeft;
    lable.numberOfLines=0;
    lable.text=@"我是第一个测试内容，关于yylabel的简单运用；";
    [self.view addSubview:lable];
    
    
    
    //2：YYLable运用textLayout计算高宽
    CGSize aSize=CGSizeMake(Main_Screen_Width-20, CGFLOAT_MAX);
    NSMutableAttributedString *aAttributedString=[[NSMutableAttributedString alloc]initWithString:@"测试文本内容的长度控制，并且显示文体的内容，测试文本内容的长度控制，并且显示文体的内容，测试文本内容的长度控制，并且显示文体的内容"];
    aAttributedString.yy_lineSpacing=8;
    aAttributedString.yy_font=CHINESE_SYSTEM(14);
    aAttributedString.yy_color=[UIColor whiteColor];
    
    YYTextLayout *layout=[YYTextLayout layoutWithContainerSize:aSize text:aAttributedString];
    YYLabel *aLable=[[YYLabel alloc]init];
    aLable.frame=CGRectMake(10, 130, layout.textBoundingSize.width, layout.textBoundingSize.height);
    aLable.textLayout=layout;
    [self.view addSubview:aLable];
    
    
    //3：YYLable高亮效果，并点点击效果
    CGSize bSize=CGSizeMake(Main_Screen_Width-20, CGFLOAT_MAX);
    NSString *bAllString=@"这个是一个高度显示的效果，测试文本内容的长度控制，并且显示文体的内容，测试文本内容的长度控制，并且显示文体的内容，测试文本内容的长度控制，并且显示文体的内容，mobileProject项目的内容";
    NSString *bHeightString=@"mobileProject";
    NSRange brange =  [bAllString rangeOfString:bHeightString];
    
    NSMutableAttributedString *bAttributedString=[[NSMutableAttributedString alloc]initWithString:bAllString];
    bAttributedString.yy_lineSpacing=4;
    bAttributedString.yy_font=CHINESE_SYSTEM(14);
    bAttributedString.yy_color=[UIColor blueColor];
    
    [bAttributedString yy_setTextHighlightRange:brange
                                          color:[UIColor yellowColor]
                                backgroundColor:[UIColor grayColor]
                                      tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                          DDLogError(@"你点击高亮效果（mobileProject）");
                                      }];
    YYTextLayout *blayout=[YYTextLayout layoutWithContainerSize:bSize text:bAttributedString];
    
    YYLabel *bLabel=[[YYLabel alloc]init];
    bLabel.frame=CGRectMake(10, CGRectGetMaxY(aLable.frame)+10, blayout.textBoundingSize.width, blayout.textBoundingSize.height);
    bLabel.textLayout=blayout;
    [self.view addSubview:bLabel];
    
    //4：YYLable带边框效果
    NSMutableAttributedString *cAttributedString=[[NSMutableAttributedString alloc]initWithString:@"MobileProject"];
    cAttributedString.yy_font=CHINESE_SYSTEM(15);
    cAttributedString.yy_color=[UIColor redColor];
    cAttributedString.yy_alignment=NSTextAlignmentCenter;
    
    //设置边框效果
    YYTextBorder *border = [YYTextBorder new];
    border.cornerRadius = 20;
    border.insets = UIEdgeInsetsMake(-5,-10, -5, -10);
    border.strokeWidth = 0.5;
    border.strokeColor = [UIColor whiteColor];
    border.lineStyle = YYTextLineStyleSingle;
    cAttributedString.yy_textBorder = border;
    
    YYLabel *cLabel=[[YYLabel alloc]init];
    cLabel.frame=CGRectMake(20, CGRectGetMaxY(bLabel.frame)+20, Main_Screen_Width-40, 50);
    cLabel.attributedText=cAttributedString;
    cLabel.backgroundColor=[UIColor blackColor];
    [self.view addSubview:cLabel];
    
    
    
    NSString * htmlString = @"<html><body>显示HTML标签<font color=\"#ffffff\"> Some </font>html string \n <font size=\"13\" color=\"red\">This is some text!</font> </body></html>";
    
    YYLabel *htmlLabel=[[YYLabel alloc]init];
    htmlLabel.attributedText = [self getAttr:htmlString];
    htmlLabel.numberOfLines=0;
    //htmlLabel.textColor=[UIColor yellowColor];
    htmlLabel.frame=CGRectMake(20, CGRectGetMaxY(cLabel.frame)+20, Main_Screen_Width-40, 80);
    [self.view addSubview:htmlLabel];
    
}

- (NSMutableAttributedString*)getAttr:(NSString*)attributedString {
    NSMutableAttributedString * resultAttr = [[NSMutableAttributedString alloc] initWithData:[attributedString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    //对齐方式 这里是 两边对齐
    resultAttr.yy_alignment = NSTextAlignmentJustified;
    //设置行间距
    resultAttr.yy_lineSpacing = 5;
    //设置字体大小
    resultAttr.yy_font = [UIFont systemFontOfSize:12];
    //可以设置某段字体的大小
    //[resultAttr yy_setFont:[UIFont boldSystemFontOfSize:CONTENT_FONT_SIZE] range:NSMakeRange(0, 3)];
    //设置字间距
    resultAttr.yy_kern = [NSNumber numberWithFloat:2.0];
    
    return resultAttr;
    
}


@end















