//
//  MPMasonryViewController.m
//  MobileProject
//
//  Created by wujunyang on 2016/11/11.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPMasonryViewController.h"

@interface MPMasonryViewController ()
@property(strong,nonatomic)MPMasonryView *myMasonryView;
@end

@implementation MPMasonryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self masonryArrayButtonLayout];
    
    [self masonryLabelHeightLayout];
    
    [self masonryPriorityLayout];
    [self masonryPriorityOtherLayout];
    
    [self masonryEdgesCenterLayout];
    
    [self masonryScrollViewLayout];
    
    [self masonryUpdateLayout];
    
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

//是否隐藏导航栏底部的黑线 默认也为NO
-(BOOL)hideNavigationBottomLine
{
    return NO;
}

////设置标题
-(NSMutableAttributedString*)setTitle
{
    return [self changeTitle:@"Masonry实例运用"];
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




#pragma mark 布局实例代码

//数组排列
-(void)masonryArrayButtonLayout
{
    NSArray *strArr=@[@"确认",@"取消",@"再考虑一下"];
    
    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i<3; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:strArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor blackColor].CGColor;
        [button addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 2;
        [self.view addSubview:button];
        [mutableArr addObject:button];
    }
    
    //axisType轴线方向 fixedSpacing间隔大小 leadSpacing头部间隔 tailSpacing尾部间隔
    [mutableArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
    [mutableArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@80);
        make.height.equalTo(@40);
    }];
}

-(void)show:(UIButton *)sender
{
    NSLog(@"操作了");
}


//不设置UILabel宽跟高的值
-(void)masonryLabelHeightLayout
{
    //文本控件UILabel、按钮UIButton、图片视图UIImageView等，它们具有自身内容尺寸（Intrinsic Content Size），此类用户控件会根据自身内容尺寸添加布局约束。也就是说，如果开发者没有显式给出其宽度或者高度约束，则其自动添加的自身内容约束将会起作用。因此看似“缺失”约束，实际上并非如此
    
    UILabel *myLabel=[[UILabel alloc]init];
    myLabel.backgroundColor=[UIColor redColor];
    myLabel.text=@"A测试Label不设高度时它的默认值";
    [self.view addSubview:myLabel];
    [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(130);
        make.left.mas_equalTo(20);
    }];
    
    UILabel *mySecondLabel=[[UILabel alloc]init];
    mySecondLabel.backgroundColor=[UIColor blueColor];
    mySecondLabel.text=@"确认";
    [self.view addSubview:mySecondLabel];
    [mySecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myLabel);
        make.left.mas_equalTo(myLabel.right).offset(10);
    }];
    
}

//优先级 及至少的情况
-(void)masonryPriorityLayout
{
    UILabel *myLabel=[[UILabel alloc]init];
    myLabel.backgroundColor=[UIColor redColor];
    myLabel.text=@"B1测试Label不设高度时它的默认值,再增加文字长度时的情况";
    [self.view addSubview:myLabel];
    [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(160);
        make.left.mas_equalTo(20);
        
        //至少至右边有80的空间，优先级设高，如果文字不够长 它会以文字本来的宽度
        make.right.mas_lessThanOrEqualTo(-80).with.priorityHigh();

    }];
    
    UILabel *mySecondLabel=[[UILabel alloc]init];
    mySecondLabel.backgroundColor=[UIColor blueColor];
    mySecondLabel.text=@"确认";
    [self.view addSubview:mySecondLabel];
    [mySecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myLabel);
        make.left.mas_equalTo(myLabel.right).offset(10);
    }];
    
}
//跟上面对比
-(void)masonryPriorityOtherLayout
{
    UILabel *myLabel=[[UILabel alloc]init];
    myLabel.backgroundColor=[UIColor redColor];
    myLabel.text=@"B1测试Label不设高度时它的默";
    [self.view addSubview:myLabel];
    [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(190);
        make.left.mas_equalTo(20);
        
        //至少至右边有80的空间，优先级设高，如果文字不够长 它会以文字本来的宽度
        make.right.mas_lessThanOrEqualTo(-80).with.priorityHigh();
        
    }];
    
    UILabel *mySecondLabel=[[UILabel alloc]init];
    mySecondLabel.backgroundColor=[UIColor blueColor];
    mySecondLabel.text=@"确认";
    [self.view addSubview:mySecondLabel];
    [mySecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myLabel);
        make.left.mas_equalTo(myLabel.right).offset(10);
    }];
}

//关于Edges,Center的运用
-(void)masonryEdgesCenterLayout
{
    UIView *myView=[[UIView alloc]init];
    myView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:myView];
    [myView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(220);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(150,100));
    }];
    
    UIView *myleftView=[[UIView alloc]init];
    myleftView.backgroundColor=[UIColor blackColor];
    [myView addSubview:myleftView];
    [myleftView mas_makeConstraints:^(MASConstraintMaker *make) {
        // top = superview.top + 10, left = superview.left + 5,
        // bottom = superview.bottom - 15, right = superview.right - 5
        make.edges.mas_equalTo(myView).insets(UIEdgeInsetsMake(10, 5, 15, 5));
    }];
    
    UIView *myrightView=[[UIView alloc]init];
    myrightView.backgroundColor=[UIColor redColor];
    [myView addSubview:myrightView];
    [myrightView mas_makeConstraints:^(MASConstraintMaker *make) {
        //centerX = superview.centerX - 5, centerY = superview.centerY + 10
        make.center.mas_equalTo(myView).centerOffset(CGPointMake(-5, 10));
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

//如何结合滚动视图
-(void)masonryScrollViewLayout
{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(220);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(150,100));
    }];
    UIView *container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    int count = 10;
    UIView *lastView = nil;
    for ( int i = 1 ; i <= count ; ++i )
    {
        UIView *subv = [UIView new];
        [container addSubview:subv];
        subv.backgroundColor = [UIColor colorWithHue:( arc4random() % 256 / 256.0 )
                                          saturation:( arc4random() % 128 / 256.0 ) + 0.5
                                          brightness:( arc4random() % 128 / 256.0 ) + 0.5
                                               alpha:1];
        
        [subv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(container);
            make.height.mas_equalTo(@(20*i));
            
            if ( lastView )
            {
                make.top.mas_equalTo(lastView.mas_bottom);
            }
            else
            {
                make.top.mas_equalTo(container.mas_top);
            }
        }];
        
        lastView = subv;
    }
    //container这个view起到了一个中间层的作用 能够自动的计算uiscrollView的contentSize 下面这句很关键
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom);
    }];
}


//更新布局的应用 setNeedsUpdateConstraints 及 [super updateConstraints]
-(void)masonryUpdateLayout
{
    if (!self.myMasonryView) {
        self.myMasonryView=[[MPMasonryView alloc]init];
        self.myMasonryView.leftWidth=120;
        self.myMasonryView.rightWidth=0;
        [self.view addSubview:self.myMasonryView];
        
        [self.myMasonryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(340);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(200, 100));
        }];
        
        //增加点击事件
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        
        [self.myMasonryView addGestureRecognizer:singleTap];
    }
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    self.myMasonryView.leftWidth=0;
    self.myMasonryView.rightWidth=150;
}

@end
