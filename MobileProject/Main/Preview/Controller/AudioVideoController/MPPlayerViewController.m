//
//  MPPlayerViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/5/3.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MPPlayerViewController ()<MPMediaPickerControllerDelegate>

@property (nonatomic,strong) MPMediaPickerController *mediaPicker;//媒体选择控制器
@property (nonatomic,strong) MPMusicPlayerController *musicPlayer; //音乐播放器
@property(nonatomic,strong)UIButton *selectButtom,*playButtom,*stopButtom,*nextButtom,*prevButtom,*puaseButtom;
@end

@implementation MPPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:self.selectButtom];
    [self.view addSubview:self.playButtom];
    [self.view addSubview:self.stopButtom];
    [self.view addSubview:self.nextButtom];
    [self.view addSubview:self.prevButtom];
    [self.view addSubview:self.puaseButtom];
    
    [self.selectButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.playButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectButtom.right).offset(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.stopButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playButtom.right).offset(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.nextButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stopButtom.right).offset(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.prevButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nextButtom.right).offset(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.puaseButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.prevButtom.right).offset(10);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [self.musicPlayer endGeneratingPlaybackNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.musicPlayer=nil;
    self.mediaPicker=nil;
}

/**
 *  获得音乐播放器
 *
 *  @return 音乐播放器
 */
-(MPMusicPlayerController *)musicPlayer{
    if (!_musicPlayer) {
        _musicPlayer=[MPMusicPlayerController systemMusicPlayer];
        [_musicPlayer beginGeneratingPlaybackNotifications];//开启通知，否则监控不到MPMusicPlayerController的通知
        [self addNotification];//添加通知
        //如果不使用MPMediaPickerController可以使用如下方法获得音乐库媒体队列
        //[_musicPlayer setQueueWithItemCollection:[self getLocalMediaItemCollection]];
    }
    return _musicPlayer;
}

/**
 *  创建媒体选择器
 *
 *  @return 媒体选择器
 */
-(MPMediaPickerController *)mediaPicker{
    if (!_mediaPicker) {
        //初始化媒体选择器，这里设置媒体类型为音乐，其实这里也可以选择视频、广播等
        //        _mediaPicker=[[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeMusic];
        _mediaPicker=[[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeAny];
        _mediaPicker.allowsPickingMultipleItems=YES;//允许多选
        //        _mediaPicker.showsCloudItems=YES;//显示icloud选项
        _mediaPicker.prompt=@"请选择要播放的音乐";
        _mediaPicker.delegate=self;//设置选择器代理
    }
    return _mediaPicker;
}

/**
 *  取得媒体队列
 *
 *  @return 媒体队列
 */
-(MPMediaQuery *)getLocalMediaQuery{
    MPMediaQuery *mediaQueue=[MPMediaQuery songsQuery];
    for (MPMediaItem *item in mediaQueue.items) {
        NSLog(@"标题：%@,%@",item.title,item.albumTitle);
    }
    return mediaQueue;
}

/**
 *  取得媒体集合
 *
 *  @return 媒体集合
 */
-(MPMediaItemCollection *)getLocalMediaItemCollection{
    MPMediaQuery *mediaQueue=[MPMediaQuery songsQuery];
    NSMutableArray *array=[NSMutableArray array];
    for (MPMediaItem *item in mediaQueue.items) {
        [array addObject:item];
        NSLog(@"标题：%@,%@",item.title,item.albumTitle);
    }
    MPMediaItemCollection *mediaItemCollection=[[MPMediaItemCollection alloc]initWithItems:[array copy]];
    return mediaItemCollection;
}

#pragma mark - MPMediaPickerController代理方法
//选择完成
-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    MPMediaItem *mediaItem=[mediaItemCollection.items firstObject];//第一个播放音乐
    //注意很多音乐信息如标题、专辑、表演者、封面、时长等信息都可以通过MPMediaItem的valueForKey:方法得到,但是从iOS7开始都有对应的属性可以直接访问
    //    NSString *title= [mediaItem valueForKey:MPMediaItemPropertyAlbumTitle];
    //    NSString *artist= [mediaItem valueForKey:MPMediaItemPropertyAlbumArtist];
    //    MPMediaItemArtwork *artwork= [mediaItem valueForKey:MPMediaItemPropertyArtwork];
    //UIImage *image=[artwork imageWithSize:CGSizeMake(100, 100)];//专辑图片
    NSLog(@"标题：%@,表演者：%@,专辑：%@",mediaItem.title ,mediaItem.artist,mediaItem.albumTitle);
    [self.musicPlayer setQueueWithItemCollection:mediaItemCollection];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//取消选择
-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 通知
/**
 *  添加通知
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(playbackStateChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
}

/**
 *  播放状态改变通知
 *
 *  @param notification 通知对象
 */
-(void)playbackStateChange:(NSNotification *)notification{
    switch (self.musicPlayer.playbackState) {
        case MPMusicPlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMusicPlaybackStatePaused:
            NSLog(@"播放暂停.");
            break;
        case MPMusicPlaybackStateStopped:
            NSLog(@"播放停止.");
            break;
        default:
            break;
    }
}

#pragma mark - UI事件
- (void)selectClick:(UIButton *)sender {
    [self presentViewController:self.mediaPicker animated:YES completion:nil];
}

- (void)playClick:(UIButton *)sender {
    [self.musicPlayer play];
}

- (void)puaseClick:(UIButton *)sender {
    [self.musicPlayer pause];
}

- (void)stopClick:(UIButton *)sender {
    [self.musicPlayer stop];
}

- (void)nextClick:(UIButton *)sender {
    [self.musicPlayer skipToNextItem];
}

- (void)prevClick:(UIButton *)sender {
    [self.musicPlayer skipToPreviousItem];
}




-(UIButton *)selectButtom
{
    if (!_selectButtom) {
        _selectButtom=[[UIButton alloc]init];
        _selectButtom.backgroundColor=[UIColor grayColor];
        [_selectButtom setTitle:@"选择" forState:UIControlStateNormal];
        [_selectButtom addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButtom;
}

-(UIButton *)playButtom
{
    if (!_playButtom) {
        _playButtom=[[UIButton alloc]init];
        _playButtom.backgroundColor=[UIColor grayColor];
        [_playButtom setTitle:@"播放" forState:UIControlStateNormal];
        [_playButtom addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButtom;
}

-(UIButton *)puaseButtom
{
    if (!_puaseButtom) {
        _puaseButtom=[[UIButton alloc]init];
        _puaseButtom.backgroundColor=[UIColor grayColor];
        [_puaseButtom setTitle:@"暂停" forState:UIControlStateNormal];
        [_puaseButtom addTarget:self action:@selector(puaseClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _puaseButtom;
}

-(UIButton *)stopButtom
{
    if(!_stopButtom)
    {
        _stopButtom=[[UIButton alloc]init];
        _stopButtom.backgroundColor=[UIColor grayColor];
        [_stopButtom setTitle:@"停止" forState:UIControlStateNormal];
        [_stopButtom addTarget:self action:@selector(stopClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButtom;
}

-(UIButton *)nextButtom
{
    if(!_nextButtom)
    {
        _nextButtom=[[UIButton alloc]init];
        _nextButtom.backgroundColor=[UIColor grayColor];
        [_nextButtom setTitle:@"下一首" forState:UIControlStateNormal];
        [_nextButtom addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButtom;
}

-(UIButton *)prevButtom
{
    if (!_prevButtom) {
        _prevButtom=[[UIButton alloc]init];
        _prevButtom.backgroundColor=[UIColor grayColor];
        [_prevButtom setTitle:@"上一首" forState:UIControlStateNormal];
        [_prevButtom addTarget:self action:@selector(prevClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _prevButtom;
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
    return [self changeTitle:@"播放音乐库中的音乐"];
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


//MPMusicPlayerController的常用属性和方法
//属性	说明
//@property (nonatomic, readonly) MPMusicPlaybackState playbackState	播放器状态，枚举类型：
//MPMusicPlaybackStateStopped：停止播放 MPMusicPlaybackStatePlaying：正在播放
//MPMusicPlaybackStatePaused：暂停播放
//MPMusicPlaybackStateInterrupted：播放中断
//MPMusicPlaybackStateSeekingForward：向前查找
//MPMusicPlaybackStateSeekingBackward：向后查找
//@property (nonatomic) MPMusicRepeatMode repeatMode	重复模式，枚举类型：
//MPMusicRepeatModeDefault：默认模式，使用用户的首选项（系统音乐程序设置）
//MPMusicRepeatModeNone：不重复
//MPMusicRepeatModeOne：单曲循环
//MPMusicRepeatModeAll：在当前列表内循环
//@property (nonatomic) MPMusicShuffleMode shuffleMode	随机播放模式，枚举类型：
//MPMusicShuffleModeDefault：默认模式，使用用户首选项（系统音乐程序设置）
//MPMusicShuffleModeOff：不随机播放
//MPMusicShuffleModeSongs：按歌曲随机播放
//MPMusicShuffleModeAlbums：按专辑随机播放
//@property (nonatomic, copy) MPMediaItem *nowPlayingItem	正在播放的音乐项
//@property (nonatomic, readonly) NSUInteger indexOfNowPlayingItem	当前正在播放的音乐在播放队列中的索引
//@property(nonatomic, readonly) BOOL isPreparedToPlay	是否准好播放准备
//@property(nonatomic) NSTimeInterval currentPlaybackTime	当前已播放时间，单位：秒
//@property(nonatomic) float currentPlaybackRate	当前播放速度，是一个播放速度倍率，0表示暂停播放，1代表正常速度
//
//类方法	说明
//+ (MPMusicPlayerController *)applicationMusicPlayer;	获取应用播放器，注意此类播放器无法在后台播放
//+ (MPMusicPlayerController *)systemMusicPlayer	获取系统播放器，支持后台播放
//
//对象方法	说明
//- (void)setQueueWithQuery:(MPMediaQuery *)query	使用媒体队列设置播放源媒体队列
//- (void)setQueueWithItemCollection:(MPMediaItemCollection *)itemCollection	使用媒体项集合设置播放源媒体队列
//- (void)skipToNextItem	下一曲
//- (void)skipToBeginning	从起始位置播放
//- (void)skipToPreviousItem	上一曲
//- (void)beginGeneratingPlaybackNotifications	开启播放通知，注意不同于其他播放器，MPMusicPlayerController要想获得通知必须首先开启，默认情况无法获得通知
//- (void)endGeneratingPlaybackNotifications	关闭播放通知
//- (void)prepareToPlay	做好播放准备（加载音频到缓冲区），在使用play方法播放时如果没有做好准备回自动调用该方法
//- (void)play	开始播放
//- (void)pause	暂停播放
//- (void)stop	停止播放
//- (void)beginSeekingForward	开始向前查找（快进）
//- (void)beginSeekingBackward	开始向后查找（快退）
//- (void)endSeeking	结束查找
//
//通知	说明
//（注意：要想获得MPMusicPlayerController通知必须首先调用beginGeneratingPlaybackNotifications开启通知）
//MPMusicPlayerControllerPlaybackStateDidChangeNotification	播放状态改变
//MPMusicPlayerControllerNowPlayingItemDidChangeNotification	当前播放音频改变
//MPMusicPlayerControllerVolumeDidChangeNotification	声音大小改变
//MPMediaPlaybackIsPreparedToPlayDidChangeNotification	准备好播放
