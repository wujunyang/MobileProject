//
//  MPCADisplayLinkViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/4/5.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPCADisplayLinkViewController.h"

@interface MPCADisplayLinkViewController ()
@property(nonatomic)CADisplayLink *myLink;
@end


//CADisplayLink知识点
//CADisplayLink是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器。我们在应用中创建一个新的 CADisplayLink 对象，把它添加到一个runloop中，并给它提供一个 target 和selector 在屏幕刷新的时候调用。
//
//一但 CADisplayLink 以特定的模式注册到runloop之后，每当屏幕需要刷新的时候，runloop就会调用CADisplayLink绑定的target上的selector，这时target可以读到  CADisplayLink 的每次调用的时间戳，用来准备下一帧显示需要的数据。例如一个视频应用使用时间戳来计算下一帧要显示的视频数据。在UI做动画的过程中，需要通过时间戳来计算UI对象在动画的下一帧要更新的大小等等。
//在添加进runloop的时候我们应该选用高一些的优先级，来保证动画的平滑。可以设想一下，我们在动画的过程中，runloop被添加进来了一个高优先级的任务，那么，下一次的调用就会被暂停转而先去执行高优先级的任务，然后在接着执行CADisplayLink的调用，从而造成动画过程的卡顿，使动画不流畅。
//
//duration属性提供了每帧之间的时间，也就是屏幕每次刷新之间的的时间。我们可以使用这个时间来计算出下一帧要显示的UI的数值。但是 duration只是个大概的时间，如果CPU忙于其它计算，就没法保证以相同的频率执行屏幕的绘制操作，这样会跳过几次调用回调方法的机会。

//frameInterval属性是可读可写的NSInteger型值，标识间隔多少帧调用一次selector 方法，默认值是1，即每帧都调用一次。如果每帧都调用一次的话，对于iOS设备来说那刷新频率就是60HZ也就是每秒60次，如果将 frameInterval 设为2 那么就会两帧调用一次，也就是变成了每秒刷新30次。

//我们通过pause属性开控制CADisplayLink的运行。当我们想结束一个CADisplayLink的时候，应该调用-(void)invalidate

//timestamp属性: 只读的CFTimeInterval值，表示屏幕显示的上一帧的时间戳，这个属性通常被target用来计算下一帧中应该显示的内容。 打印timestamp值，其样式类似于：179699.631584。

//从runloop中删除并删除之前绑定的 target跟selector
//
//另外CADisplayLink 不能被继承。

//iOS设备的刷新频率事60HZ也就是每秒60次。那么每一次刷新的时间就是1/60秒 大概16.7毫秒。当我们的frameInterval值为1的时候我们需要保证的是 CADisplayLink调用的｀target｀的函数计算时间不应该大于 16.7否则就会出现严重的丢帧现象。

@implementation MPCADisplayLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    MPWeakSelf(self);
    self.myLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [self.myLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    //操作link的运行跟停止
    [self.view addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        MPStrongSelf(self);
        if (self.myLink.paused) {
            self.myLink.paused=NO;
        }
        else
        {
            self.myLink.paused=YES;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.myLink invalidate];
    [super viewWillDisappear:animated];
}

- (void)tick:(CADisplayLink *)link {
    
    //可以在这边进行一些操作 比如YYFPSLabel在这查看 滚动的丢帧情况  还有如 UIBezierPath实现果冻效果 用它来时时反映出当前被拉动点的位置坐标
    //iOS设备的刷新频率事60HZ也就是每秒60次。那么每一次刷新的时间就是1/60秒 大概16.7毫秒。当我们的frameInterval值为1的时候我们需要保证的是 CADisplayLink调用的｀target｀的函数计算时间不应该大于 16.7否则就会出现严重的丢帧现象
    NSLog(@"当前的: %f",link.duration);
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
    return [self changeTitle:@"CADisplayLink知识运用"];
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


@end
