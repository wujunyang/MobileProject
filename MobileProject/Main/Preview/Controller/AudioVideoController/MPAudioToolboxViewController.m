//
//  MPAudioToolboxViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/5/2.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPAudioToolboxViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MPAudioToolboxViewController ()

@end

@implementation MPAudioToolboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self playSoundEffect:@"videoRing.caf"];
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
    return [self changeTitle:@"音效(AudioToolbox)运用"];
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


/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    NSLog(@"播放完成...");
}

/**
 *  播放音效文件
 *
 *  @param name 音频文件名称
 */
-(void)playSoundEffect:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
    //    AudioServicesPlayAlertSound(soundID);//播放音效并震动
}


//知识点：
//1:System Sound Service是一种简单、底层的声音播放服务，但是它本身也存在着一些限制：
//音频播放时间不能超过30s
//数据必须是PCM或者IMA4格式
//音频文件必须打包成.caf、.aif、.wav中的一种

//2:使用System Sound Service 播放音效的步骤如下
//调用AudioServicesCreateSystemSoundID(   CFURLRef  inFileURL, SystemSoundID*   outSystemSoundID)函数获得系统声音ID。
//如果需要监听播放完成操作，则使用AudioServicesAddSystemSoundCompletion(  SystemSoundID inSystemSoundID,
//                                                      CFRunLoopRef  inRunLoop, CFStringRef  inRunLoopMode, AudioServicesSystemSoundCompletionProc  inCompletionRoutine, void*  inClientData)方法注册回调函数。
//调用AudioServicesPlaySystemSound(SystemSoundID inSystemSoundID) 或者AudioServicesPlayAlertSound(SystemSoundID inSystemSoundID) 方法播放音效（后者带有震动效果）。

@end
