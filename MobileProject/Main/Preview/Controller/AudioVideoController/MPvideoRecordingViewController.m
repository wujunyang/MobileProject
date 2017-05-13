//
//  MPvideoRecordingViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/5/10.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPvideoRecordingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MPClearCacheTool.h"


@interface MPvideoRecordingViewController ()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic,strong) AVCaptureMovieFileOutput *output;

@property (nonatomic,strong)NSURL *firstVideoPath;


@property (nonatomic,strong)NSURL *secondVideoPath;

@property (nonatomic,strong)NSMutableArray *videoPathArray;


@property (nonatomic,strong)NSString *videoName;

@end

@implementation MPvideoRecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self AVCaptureVideo];
    
    [self setUpUI];
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
    return [self changeTitle:@"视频录制合成实例"];
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

-(NSMutableArray *)videoPathArray{
    if (!_videoPathArray) {
        
        _videoPathArray = [NSMutableArray array];
        
    }
    return _videoPathArray;
}

-(void)setUpUI{
    
    UIButton *playButton = [[UIButton alloc]init];
    
    [playButton setTitle:@"录制" forState:(UIControlStateNormal)];
    
    [playButton setTitleColor:[UIColor greenColor] forState:(UIControlStateNormal)];
    [playButton setBackgroundColor:[UIColor purpleColor]];
    
    [self.view addSubview:playButton];
    
    [playButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view).offset(-50);
        make.left.equalTo(self.view).offset(50);
        make.width.offset(50);
        make.height.offset(40);
        
    }];
    [playButton addTarget:self action:@selector(clickVideoBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIButton *mergeButton = [[UIButton alloc]init];
    
    [mergeButton setTitle:@"合并" forState:(UIControlStateNormal)];
    
    [mergeButton setTitleColor:[UIColor purpleColor] forState:(UIControlStateNormal)];
    [mergeButton setBackgroundColor:[UIColor blueColor]];
    
    [self.view addSubview:mergeButton];
    
    [mergeButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.offset(-50);
        make.centerX.equalTo(self.view);
        make.width.offset(50);
        make.height.offset(40);
        
    }];
    
    [mergeButton addTarget:self action:@selector(clickMergeButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIButton *clear = [[UIButton alloc]init];
    
    [clear setTitle:@"清除缓存" forState:(UIControlStateNormal)];
    [clear setTitleColor:[UIColor yellowColor] forState:(UIControlStateNormal)];
    [clear setBackgroundColor:[UIColor redColor]];
    
    [self.view addSubview:clear];
    
    [clear makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-20);
        make.bottom.offset(-50);
        make.width.offset(80);
        make.height.offset(40);
        
    }];
    [clear addTarget:self action:@selector(clickClearMemory) forControlEvents:(UIControlEventTouchUpInside)];
    
}

-(void)AVCaptureVideo{
    
    //创建视频设备(摄像头前，后)
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //初始化一个摄像头输入设备(first是后置摄像头，last是前置摄像头)
    AVCaptureDeviceInput *inputVideo = [AVCaptureDeviceInput deviceInputWithDevice:[devices firstObject] error:NULL];
    //创建麦克风设备
    AVCaptureDevice *deviceAudio = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //初始化麦克风输入设备
    AVCaptureDeviceInput *inputAudio = [AVCaptureDeviceInput deviceInputWithDevice:deviceAudio error:NULL];
    
    //初始化一个movie的文件输出
    AVCaptureMovieFileOutput *output = [[AVCaptureMovieFileOutput alloc] init];
    self.output = output; //保存output，方便下面操作
    
    //初始化一个会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    //将输入输出设备添加到会话中
    if ([session canAddInput:inputVideo]) {
        [session addInput:inputVideo];
    }
    if ([session canAddInput:inputAudio]) {
        [session addInput:inputAudio];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    
    
    //添加一个视频预览图层，设置大小，添加到控制器view的图层上
    //创建一个预览涂层
    AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    //设置图层的大小
    preLayer.frame = self.view.bounds;
    //添加到view上
    [self.view.layer addSublayer:preLayer];
    
    //开始会话
    [session startRunning];
    
}


#pragma mark ==============
#pragma mark ===录制按钮======
- (void)clickVideoBtn:(UIButton *)sender {
    //判断是否在录制,如果在录制，就停止，并设置按钮title
    if ([self.output isRecording]) {
        [self.output stopRecording];
        
        
        [sender setTitle:@"录制" forState:UIControlStateNormal];
        return;
    }
    
    //设置按钮的title
    [sender setTitle:@"停止" forState:UIControlStateNormal];
    
    //设置录制视频保存的路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                          NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",[NSDate date]]];
    
    
    //转为视频保存的url
    NSURL *url  = [NSURL fileURLWithPath:path];
    
    //    UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil);
    
    //开始录制,并设置控制器为录制的代理
    [self.output startRecordingToOutputFileURL:url recordingDelegate:self];
}
//清楚缓存
- (void)clickClearMemory{
    
    NSString *path = [MPClearCacheTool getCacheSizeWithFilePath: [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定清除%@缓存吗?",path] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //创建一个取消和一个确定按钮
    UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //因为需要点击确定按钮后改变文字的值，所以需要在确定按钮这个block里面进行相应的操作
    UIAlertAction *actionOk=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        //清楚缓存
        BOOL isSuccess = [MPClearCacheTool clearCacheWithFilePath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
        if (isSuccess) {
            [MBProgressHUD showSuccess:@"清楚成功" ToView:self.view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
        }
        
        
        
    }   ];
    //将取消和确定按钮添加进弹框控制器
    [alert addAction:actionCancle];
    [alert addAction:actionOk];
    //添加一个文本框到弹框控制器
    
    //显示弹框控制器
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
//录制完成代理
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    [MBProgressHUD showSuccess:@"录制完成" ToView:self.view];
    
    [self setAlertView:outputFileURL];
    
}


#pragma mark ==============
#pragma mark ===输入框======
-(void)setAlertView:(NSURL *)inPutUrl{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入视频名称" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField*textField) {
        
        textField.text = [NSString stringWithFormat:@"%@",[NSDate date]];
        
        [textField addTarget:self action:@selector(changValue:) forControlEvents:(UIControlEventEditingChanged)];
        
        self.videoName = textField.text;
        
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self ZIPVideo:inPutUrl VideoName:self.videoName];
    }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark ==============
#pragma mark ===视频压缩======
- (void) lowQuailtyWithInputURL:(NSURL*)inputURL
                      outputURL:(NSURL*)outputURL
                   blockHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset     presetName:AVAssetExportPresetMediumQuality];
    session.outputURL = outputURL;
    session.outputFileType = AVFileTypeQuickTimeMovie;
    [session exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(session);
     }];
}
-(void)ZIPVideo:(NSURL *)inputURl VideoName:(NSString *)videoName{
    
    //设置录制视频保存的路径
    NSString *outpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",videoName]];
    
    //转为视频保存的url
    NSURL *outurl  = [NSURL fileURLWithPath:outpath];
    
    //把path添加到数组中(合并视频)
    [self.videoPathArray addObject:outpath];
    
    [self lowQuailtyWithInputURL:inputURl outputURL:outurl blockHandler:^(AVAssetExportSession *session)
     {
         if (session.status == AVAssetExportSessionStatusCompleted)
         {
             NSLog(@"压缩成功");
             
         }
         else
         {
             NSLog(@"压缩失败");
             
         }
     }];
}

#pragma mark ==============
#pragma mark ===监听textfield======
-(void)changValue:(UITextField *)text{
    
    self.videoName = text.text;
    
}

//视频合并按钮
-(void)clickMergeButton{
    
    [self mergeAndExportVideos:self.videoPathArray withOutPath:[self videoPath]];
}
#pragma mark =====下面是合成视频的方法===========
- (void)mergeAndExportVideos:(NSArray*)videosPathArray withOutPath:(NSString*)outpath{
    if (videosPathArray.count == 0) {
        [MBProgressHUD showError:@"请录制视频" ToView:self.view];
        return;
    }
    
    //合成中
    [MBProgressHUD showLoadToView:self.view];
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //视频旋转270(视频合并后默认旋转了-90度)
    videoTrack.preferredTransform = CGAffineTransformMake(0, 1.0, -1.0, 0, 0, 0);
    
    CMTime totalDuration = kCMTimeZero;
    for (int i = 0; i < videosPathArray.count; i++) {
        AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videosPathArray[i]]];
        
        NSError *erroraudio = nil;
        //获取AVAsset中的音频 或者视频
        AVAssetTrack *assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        
        
        
        //向通道内加入音频或者视频
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetAudioTrack
                             atTime:totalDuration
                              error:&erroraudio];
        
        //        NSLog(@"erroraudio:%@",erroraudio);
        NSError *errorVideo = nil;
        AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]firstObject];
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetVideoTrack
                             atTime:totalDuration
                              error:&errorVideo];
        
        //        NSLog(@"errorVideo:%@",errorVideo);
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
    }
    
    NSURL *mergeFileURL = [NSURL fileURLWithPath:outpath];
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        
        if (exporter.error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view];
                
                [MBProgressHUD showSuccess:@"合并失败" ToView:self.view];
            });
            NSLog(@"合并失败");
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view];
                
                [MBProgressHUD showSuccess:@"合并成功" ToView:self.view];
            });
            
            NSLog(@"合并成功");
        }
        //保存到相册
        //        UISaveVideoAtPathToSavedPhotosAlbum([mergeFileURL path], nil, nil, nil);
        
    }];
}

//路径
- (NSString *)videoPath {
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *moviePath = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"qqq%@.mov",[NSDate date]]];
    return moviePath;
}


@end
