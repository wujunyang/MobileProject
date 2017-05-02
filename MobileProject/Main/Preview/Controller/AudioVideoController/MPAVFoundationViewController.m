//
//  MPAVFoundationViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/5/2.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPAVFoundationViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MPAVFoundationViewController ()<AVAudioPlayerDelegate>

@property(nonatomic,strong)AVAudioPlayer *audioPlayer; //播放器
@property(nonatomic,strong)UIProgressView *playProgress; //播放进度
@property(nonatomic,strong)UIButton *playOrPauseButton;  //播放跟暂停按钮
@property(weak,nonatomic)NSTimer *timer; //进度定时器

@end

@implementation MPAVFoundationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:self.playProgress];
    [self.playProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-100);
        make.height.mas_equalTo(3);
    }];
    
    [self.view addSubview:self.playOrPauseButton];
    [self.playOrPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playProgress.bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
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
    return [self changeTitle:@"音乐AVFoundation运用"];
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



-(UIProgressView *)playProgress
{
    if(!_playProgress)
    {
        _playProgress=[[UIProgressView alloc]init];
        _playProgress.progressTintColor=[UIColor redColor];
        _playProgress.trackTintColor=[UIColor blueColor];
    }
    return _playProgress;
}

-(UIButton *)playOrPauseButton
{
    if (!_playOrPauseButton) {
        _playOrPauseButton=[[UIButton alloc]init];
        _playOrPauseButton.backgroundColor=[UIColor grayColor];
        _playOrPauseButton.tag=1;
        [_playOrPauseButton setTitle:@"开始" forState:UIControlStateNormal];
        [_playOrPauseButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playOrPauseButton;
}


-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    return _timer;
}

/**
 *  创建播放器
 *
 *  @return 音频播放器
 */
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSString *urlStr=[[NSBundle mainBundle]pathForResource:@"audio.mp3" ofType:nil];
        NSURL *url=[NSURL fileURLWithPath:urlStr];
        NSError *error=nil;
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops=1;//设置为0不循环
        _audioPlayer.delegate=self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
        
        //设置后台播放模式
        AVAudioSession *audioSession=[AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        //        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
        [audioSession setActive:YES error:nil];
        
        
        //添加通知，拔出耳机后暂停播放
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return _audioPlayer;
}

/**
 *  播放音频
 */
-(void)play{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
        self.timer.fireDate=[NSDate distantPast];//恢复定时器
    }
}

/**
 *  暂停播放
 */
-(void)pause{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        self.timer.fireDate=[NSDate distantFuture];//暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复

    }
}

/**
 *  更新播放进度
 */
-(void)updateProgress{
    float progress= self.audioPlayer.currentTime /self.audioPlayer.duration;
    [self.playProgress setProgress:progress animated:true];
}

/**
 *  点击播放/暂停按钮
 *
 *  @param sender 播放/暂停按钮
 */
- (void)playAction:(UIButton *)sender {
    if(sender.tag){
        sender.tag=0;
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        [sender setTitle:@"暂停" forState:UIControlStateHighlighted];
        [self play];
    }else{
        sender.tag=1;
        [sender setTitle:@"播放" forState:UIControlStateNormal];
        [sender setTitle:@"播放" forState:UIControlStateHighlighted];
        [self pause];
    }
}


/**
 *  一旦输出改变则执行此方法
 *
 *  @param notification 输出改变通知对象
 */
-(void)routeChange:(NSNotification *)notification{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            //处理显示同步问题
            [self.playOrPauseButton setTitle:@"播放" forState:UIControlStateNormal];
            [self.playOrPauseButton setTitle:@"播放" forState:UIControlStateHighlighted];
            self.playOrPauseButton.tag=1;
            //进行
            [self pause];
        }
    }
    
    //    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    //        NSLog(@"%@:%@",key,obj);
    //    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}


#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成...");
}


@end


//问题1：
//一直不想升级Xcode，但是没办法项目进度只能升级Xcode8，果然不出所料出现了不少bug，
//Xcode7运行一直没有问题，但是在Xcode8上一直输出AQDefaultDevice (173): skipping input stream
//
//网上查到解决办法
//1.选择 Product -->Scheme-->Edit Scheme
//2.选择 Arguments
//3.在Environment Variables添加一个环境变量 OS_ACTIVITY_MODE 设置值为"disable"
