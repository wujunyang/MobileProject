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



//会话类型	                                 说明	                               是否要求输入	是否要求输出	是否遵从静音键
//AVAudioSessionCategoryAmbient	         混音播放，可以与其他音频应用同时播放	       否	        是	        是
//AVAudioSessionCategorySoloAmbient	     独占播放	                               否	        是	        是
//AVAudioSessionCategoryPlayback	     后台播放，也是独占的	                   否           是           否
//AVAudioSessionCategoryRecord	         录音模式，用于录音时使用	               是           否           否
//AVAudioSessionCategoryPlayAndRecord	 播放和录音，此时可以录音也可以播放	       是           是           否
//AVAudioSessionCategoryAudioProcessing	 硬件解码音频，此时不能播放和录制	           否           否           否
//AVAudioSessionCategoryMultiRoute	     多种输入输出，例如可以耳机、USB设备同时播放   是           是           否
//
//注意：是否遵循静音键表示在播放过程中如果用户通过硬件设置为静音是否能关闭声音。


//设置后台播放
//1.设置后台运行模式：在plist文件中添加Required background modes，并且设置item 0=App plays audio or streams audio/video using AirPlay（其实可以直接通过Xcode在Project Targets-Capabilities-Background Modes中设置）
//2.设置AVAudioSession的类型为AVAudioSessionCategoryPlayback并且调用setActive::方法启动会话。


//属性	说明
//@property(readonly, getter=isPlaying) BOOL playing	是否正在播放，只读
//@property(readonly) NSUInteger numberOfChannels	音频声道数，只读
//@property(readonly) NSTimeInterval duration	音频时长
//@property(readonly) NSURL *url	音频文件路径，只读
//@property(readonly) NSData *data	音频数据，只读
//@property float pan	立体声平衡，如果为-1.0则完全左声道，如果0.0则左右声道平衡，如果为1.0则完全为右声道
//@property float volume	音量大小，范围0-1.0
//@property BOOL enableRate	是否允许改变播放速率
//@property float rate	播放速率，范围0.5-2.0，如果为1.0则正常播放，如果要修改播放速率则必须设置enableRate为YES
//@property NSTimeInterval currentTime	当前播放时长
//@property(readonly) NSTimeInterval deviceCurrentTime	输出设备播放音频的时间，注意如果播放中被暂停此时间也会继续累加
//@property NSInteger numberOfLoops	循环播放次数，如果为0则不循环，如果小于0则无限循环，大于0则表示循环次数
//@property(readonly) NSDictionary *settings	音频播放设置信息，只读
//@property(getter=isMeteringEnabled) BOOL meteringEnabled	是否启用音频测量，默认为NO，一旦启用音频测量可以通过updateMeters方法更新测量值


//对象方法	说明
//- (instancetype)initWithContentsOfURL:(NSURL *)url error:(NSError **)outError	使用文件URL初始化播放器，注意这个URL不能是HTTP URL，AVAudioPlayer不支持加载网络媒体流，只能播放本地文件
//- (instancetype)initWithData:(NSData *)data error:(NSError **)outError	使用NSData初始化播放器，注意使用此方法时必须文件格式和文件后缀一致，否则出错，所以相比此方法更推荐使用上述方法或- (instancetype)initWithData:(NSData *)data fileTypeHint:(NSString *)utiString error:(NSError **)outError方法进行初始化
//- (BOOL)prepareToPlay;	加载音频文件到缓冲区，注意即使在播放之前音频文件没有加载到缓冲区程序也会隐式调用此方法。
//- (BOOL)play;	播放音频文件
//- (BOOL)playAtTime:(NSTimeInterval)time	在指定的时间开始播放音频
//- (void)pause;	暂停播放
//- (void)stop;	停止播放
//- (void)updateMeters	更新音频测量值，注意如果要更新音频测量值必须设置meteringEnabled为YES，通过音频测量值可以即时获得音频分贝等信息
//- (float)peakPowerForChannel:(NSUInteger)channelNumber;	获得指定声道的分贝峰值，注意如果要获得分贝峰值必须在此之前调用updateMeters方法
//- (float)averagePowerForChannel:(NSUInteger)channelNumber	获得指定声道的分贝平均值，注意如果要获得分贝平均值必须在此之前调用updateMeters方法
//@property(nonatomic, copy) NSArray *channelAssignments	获得或设置播放声道
//代理方法	说明
//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag	音频播放完成
//- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error	音频解码发生错误
