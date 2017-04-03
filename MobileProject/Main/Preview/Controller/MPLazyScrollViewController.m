//
//  MPLazyScrollViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/4/2.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPLazyScrollViewController.h"

@interface MPLazyScrollViewController ()<TMMuiLazyScrollViewDataSource>

@property(nonatomic,strong)NSMutableArray * rectArray;

@end

@implementation MPLazyScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.rectArray  = [[NSMutableArray alloc] init];
    
    //STEP 1 . Create LazyScrollView
    TMMuiLazyScrollView *scrollview = [[TMMuiLazyScrollView alloc]init];
    scrollview.frame = self.view.bounds;
    scrollview.dataSource = self;
    
    [self.view addSubview:scrollview];
    
    //Create a single column layout with 5 elements;
    for (int i = 0; i < 5 ; i++) {
        [self.rectArray addObject:[NSValue valueWithCGRect:CGRectMake(10, i *80 + 2 , self.view.bounds.size.width-20, 80-2)]];
    }
    //Create a double column layout with 10 elements;
    for (int i = 0; i < 10 ; i++) {
        [self.rectArray addObject:[NSValue valueWithCGRect:CGRectMake((i%2)*self.view.bounds.size.width/2 + 3, 410 + i/2 *80 + 2 , self.view.bounds.size.width/2 -3, 80 - 2)]];
    }
    //Create a trible column layout with 15 elements;
    for (int i = 0; i < 15 ; i++) {
        [self.rectArray addObject:[NSValue valueWithCGRect:CGRectMake((i%3)*self.view.bounds.size.width/3 + 1, 820 + i/3 *80 + 2 , self.view.bounds.size.width/3 -3, 80 - 2)]];
    }
    
    for(int i=0; i<12;i++)
    {
        [self.rectArray addObject:[NSValue valueWithCGRect:CGRectMake((i%2)*self.view.bounds.size.width/2 + 3, 1230+i/2 *100 + 2, self.view.bounds.size.width/2 -6, 100-2)]];
    }
    
    scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 1830);
    //STEP 3 reload LazyScrollView
    [scrollview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TMMuiLazyScrollViewDataSource

//STEP 2 implement datasource delegate.
- (NSUInteger)numberOfItemInScrollView:(TMMuiLazyScrollView *)scrollView
{
    return self.rectArray.count;
}

- (TMMuiRectModel *)scrollView:(TMMuiLazyScrollView *)scrollView rectModelAtIndex:(NSUInteger)index
{
    CGRect rect = [(NSValue *)[self.rectArray objectAtIndex:index]CGRectValue];
    TMMuiRectModel *rectModel = [[TMMuiRectModel alloc]init];
    rectModel.absoluteRect = rect;
    rectModel.muiID = [NSString stringWithFormat:@"%ld",index];
    return rectModel;
}

- (UIView *)scrollView:(TMMuiLazyScrollView *)scrollView itemByMuiID:(NSString *)muiID
{
    
    NSInteger index = [muiID integerValue];
    
    if (index<self.rectArray.count-12) {
        //Find view that is reuseable first.
        MPLazyLableViewCustomView *label = (MPLazyLableViewCustomView *)[scrollView dequeueReusableItemWithIdentifier:@"testView"];
        
        if (!label)
        {
            label = [[MPLazyLableViewCustomView alloc]initWithFrame:[(NSValue *)[self.rectArray objectAtIndex:index]CGRectValue]];
            label.textAlignment = NSTextAlignmentCenter;
            label.reuseIdentifier = @"testView";
        }
        label.frame = [(NSValue *)[self.rectArray objectAtIndex:index]CGRectValue];
        label.text = [NSString stringWithFormat:@"%lu",(unsigned long)index];
        label.backgroundColor = [UIColor RandomColor];
        [scrollView addSubview:label];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)]];
        return label;
    }
    else
    {
        MPLazyImageViewCustomView *imageCustomView=(MPLazyImageViewCustomView *)[scrollView dequeueReusableItemWithIdentifier:@"imageView"];
        if(!imageCustomView)
        {
            imageCustomView=[[MPLazyImageViewCustomView alloc]initWithFrame:[(NSValue *)[self.rectArray objectAtIndex:index]CGRectValue]];
            imageCustomView.reuseIdentifier=@"imageView";
            
        }
        imageCustomView.backgroundColor=[UIColor RandomColor];
        imageCustomView.imageName=@"public_empty_loading";
        imageCustomView.frame = [(NSValue *)[self.rectArray objectAtIndex:index]CGRectValue];
        [scrollView addSubview:imageCustomView];
        
        return imageCustomView;
    }
}


- (void)click:(UIGestureRecognizer *)recognizer
{
    MPLazyLableViewCustomView *label = (MPLazyLableViewCustomView *)recognizer.view;
    
    NSLog(@"Click - %@",label.muiID);
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
    return [self changeTitle:@"可复用的滚动子视图"];
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

#pragma mark 自定义代码区

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}

@end
