//
//  MPVideoClipViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/5/9.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPVideoClipViewController.h"
#import "QBImagePickerController.h"
#import "cameraHelper.h"



@interface MPVideoClipViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, QBImagePickerControllerDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UIButton *selectVideoButtom;
@property(nonatomic,strong)UIButton *pauseButton;
@property(nonatomic,strong)NSURL *assetURL;
@property(nonatomic,strong)AVAsset *asset;
@property(nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) AVPlayerLayer *playerlayer;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) UIImageView *firstImageView;
@property (nonatomic,strong) UIButton *playButton;
@property(nonatomic,strong) UILabel *beginlabel;
@property(nonatomic,strong) UILabel *endLabel;
//底部的预览视图
@property(nonatomic,strong) UIScrollView *quickLookView;
@property (nonatomic,strong) NSMutableArray *quickLookArr;

//刻度尺
@property(nonatomic,strong) UIImageView *positionImageView;


@property(nonatomic,assign) NSInteger totalTime;
//记录是否是人为拖动
@property (nonatomic,assign) BOOL isPlaying;
//开始裁剪按钮
@property (nonatomic,strong) UIButton *beginCutBtn;
//记录开始裁剪的状态
@property (nonatomic,assign) BOOL isCutting;
@property (nonatomic,assign) CGFloat beginoffset;
//记录是否赋了剪切初值
@property (nonatomic,assign) BOOL hasBeginTime;
@property (nonatomic,assign) CGFloat endoffset;
//标记的红色视图
@property (nonatomic,strong) UIImageView *redView;
@end


static CGFloat imageWidth;
static CGFloat imageheight;

@implementation MPVideoClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:self.selectVideoButtom];
    [self.selectVideoButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80);
        make.left.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.quickLookView];
    [self.quickLookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-100);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.beginCutBtn];
    [self.beginCutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
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
    return [self changeTitle:@"视频剪编效果的实例"];
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

-(void)setAssetURL:(NSURL *)assetURL
{
    _beginoffset=0; _endoffset=0;
    [self.redView removeFromSuperview];
    _isCutting=NO;
    _isPlaying=NO;
    
    for (UIImageView *img in _quickLookArr) {
        [img removeFromSuperview];
    }
    [_quickLookArr removeAllObjects];
    
    [_beginCutBtn setTitle:@"开始裁剪" forState:UIControlStateNormal];
    
    _hasBeginTime=NO;
    _assetURL=assetURL;
    _asset = [AVAsset assetWithURL:assetURL];
    CGFloat totalTime=_asset.duration.value*1.0f/_asset.duration.timescale;
    
    _totalTime = [[NSNumber numberWithFloat:totalTime] integerValue];
    int time=[[NSNumber  numberWithFloat:totalTime] intValue];
    
    NSTimeInterval begintime=[[NSNumber numberWithInt:0] doubleValue] ;
    UIImage *firstImage=[self thumbnailImageForVideo:assetURL atTime:begintime];
    
    imageWidth=firstImage.size.width;
    imageheight=firstImage.size.height;
    CGFloat scale = imageWidth/imageheight;
    
    imageWidth = Main_Screen_Width;
    imageheight = Main_Screen_Width / scale;
    if (imageheight>[UIScreen mainScreen].bounds.size.height-200) {
        imageheight=[UIScreen mainScreen].bounds.size.height-200;
        imageWidth=imageheight*(scale);
    }
    
    
    self.firstImageView.frame=CGRectMake((Main_Screen_Width-imageWidth)*0.5, 150, imageWidth, imageheight);
    _firstImageView.image=firstImage;
    
    [self.view addSubview:_firstImageView];
    
    self.playButton.frame = CGRectMake((imageWidth-30)*0.5, (imageheight-30)*0.5, 30, 30);
    [_playButton setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
    [_firstImageView addSubview:_playButton];
    _firstImageView.userInteractionEnabled=YES;
    [_playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    
    self.beginlabel.frame=CGRectMake(0, CGRectGetMaxY(_firstImageView.frame), 50, 20);
    self.endLabel.frame =CGRectMake([UIScreen mainScreen].bounds.size.width-50, CGRectGetMaxY(_firstImageView.frame), 50, 20);
    _beginlabel.text=@"0";
    _beginlabel.textColor=[UIColor whiteColor];
    _beginlabel.font=[UIFont systemFontOfSize:15];
    _beginlabel.textAlignment=NSTextAlignmentCenter;
    _endLabel.text=[NSNumber numberWithInt:time].description;
    _endLabel.textColor=[UIColor whiteColor];
    _endLabel.font=[UIFont systemFontOfSize:15];
    _endLabel.textAlignment=NSTextAlignmentCenter;
    
    [self.view addSubview:_beginlabel];
    [self.view addSubview:_endLabel];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pauseTheVideo)];
    
    [_firstImageView addGestureRecognizer:tap];
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(coutLabelPlus) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    
    [self creatQuickLookImage];
}

//生成预览
-(void)creatQuickLookImage{

    for (int i=0; i<_totalTime; i++) {
        NSTimeInterval cuttime=[[NSNumber numberWithInt:i*_asset.duration.timescale] doubleValue] ;
        
        UIImage *cImage=[self thumbnailImageForVideo:_assetURL atTime:cuttime];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width*0.5+50*(imageWidth/imageheight)*i, 0, 50*(imageWidth/imageheight), 50)];
        imageView.image=cImage;
        [self.quickLookArr addObject:imageView];
        [_quickLookView addSubview:imageView];
    }
    
    _quickLookView.contentSize=CGSizeMake(50*(imageWidth/imageheight)*_totalTime+Main_Screen_Width, 50);
    _quickLookView.scrollEnabled=YES;
    [_quickLookView setContentOffset:CGPointMake(0, 0)];
    _quickLookView.showsHorizontalScrollIndicator=NO;
    _quickLookView.showsVerticalScrollIndicator=NO;
    
    
    _quickLookView.delegate=self;
}

-(UIScrollView *)quickLookView
{
    if (_quickLookView==nil) {
        _quickLookView=[[UIScrollView alloc]init];
        _quickLookView.backgroundColor=[UIColor redColor];
    }
    
    return _quickLookView;
}

-(UIImageView *)firstImageView
{
    if (_firstImageView==nil) {
        _firstImageView=[[UIImageView alloc]init];
    }
    
    return _firstImageView;
}
-(UIButton *)playButton{
    if (_playButton==nil) {
        _playButton=[[UIButton alloc]init];
    }
    
    return _playButton;
}

-(NSMutableArray *)quickLookArr
{
    if (_quickLookArr==nil) {
        _quickLookArr=[NSMutableArray array];
    }
    return _quickLookArr;
}

-(UIButton *)beginCutBtn
{
    if (_beginCutBtn==nil) {
        _beginCutBtn=[[UIButton alloc]init];
        [_beginCutBtn setTitle:@"开始裁剪" forState:UIControlStateNormal];
        [_beginCutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_beginCutBtn addTarget:self action:@selector(beginCutBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [_beginCutBtn setBackgroundColor:[UIColor redColor]];
    }
    return _beginCutBtn;
}

-(UIImageView *)redView
{
    if (_redView==nil) {
        _redView=[[UIImageView alloc]init];
        _redView.backgroundColor=[UIColor colorWithRed:220/225.0 green:1/225.0 blue:1/225.0 alpha:0.4];
    }
    return _redView;
}


-(UIButton *)selectVideoButtom
{
    if(!_selectVideoButtom)
    {
        _selectVideoButtom=[[UIButton alloc]init];
        _selectVideoButtom.backgroundColor=[UIColor grayColor];
        [_selectVideoButtom setTitle:@"选择视频文件" forState:UIControlStateNormal];
        [_selectVideoButtom addTarget:self action:@selector(selectVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectVideoButtom;
}

-(UILabel *)beginlabel
{
    if (_beginlabel==nil) {
        _beginlabel=[[UILabel alloc]init];
    }
    return _beginlabel;
}
-(UILabel *)endLabel
{
    if (_endLabel==nil) {
        _endLabel=[[UILabel alloc]init];
    }
    return _endLabel;
}

- (NSURL*)clipUrl {
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    return [NSURL fileURLWithPath:[documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",@"wjyabcde"]]];
}
//获取视频中图片
- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil] ;
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset] ;
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, asset.duration.timescale) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]  : nil;
    
    return thumbnailImage;
}

//选择视频

-(void)selectVideoAction:(UIButton *)sender
{
    NSLog(@"选择文件");
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate=self;
    picker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark UINavigationControllerDelegate


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{    
    NSURL *videoURL=info[@"UIImagePickerControllerMediaURL"];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.assetURL=videoURL;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//播放点击事件
-(void)playVideo{
    
    [_playButton removeFromSuperview];
    
    //    AVURLAsset *avasset = [[AVURLAsset alloc]initWithURL:_sourceURL options:nil];
    if (_player==nil||_player.currentTime.value==_asset.duration.value) {
        _player=nil;
        
        AVPlayerItem *item=[[AVPlayerItem alloc]initWithAsset:_asset];
        
        _player = [[AVPlayer alloc] initWithPlayerItem:item];
        
        _playerlayer=[AVPlayerLayer playerLayerWithPlayer:_player];
        _playerlayer.frame=_firstImageView.bounds;
        [_firstImageView.layer addSublayer: _playerlayer];
        
    }
    
    [_player play];
    //         _isPlaying=YES;
    [_timer setFireDate:[NSDate distantPast]];
    
}
//暂停播放
-(void)pauseTheVideo{
    
    if (_player!=nil) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_player pause];
        //        _isPlaying=NO;
        
    }
    [_firstImageView addSubview:_playButton];
}


//拖动预览可暂停视频
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isPlaying=YES;
    
    if (_isCutting==YES&&_hasBeginTime==NO) {
        _hasBeginTime=YES;
        _beginoffset=(scrollView.contentOffset.x);
    }
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //当是拖动发起的时候就操作
    if (_isPlaying==YES) {
        
        CGFloat percent = (scrollView.contentOffset.x)/(scrollView.contentSize.width-Main_Screen_Width);
        double dpercent=[[NSNumber numberWithFloat:percent] doubleValue];
        double cuttime=_asset.duration.value*(dpercent);
        //        NSLog(@"%.2f",(scrollView.contentOffset.x)/(scrollView.contentSize.width-ScreenW));
        CMTime begintime=CMTimeMake(cuttime, _asset.duration.timescale);
        [_player seekToTime:begintime];
    }
    
    
    if (_isCutting==YES&&_hasBeginTime==YES) {
        NSLog(@"%.2f",_beginoffset);
        _endoffset=(scrollView.contentOffset.x);
        self.redView.frame=CGRectMake(_beginoffset+Main_Screen_Width*0.5, 0,(scrollView.contentOffset.x-_beginoffset), 50);
        [self.quickLookView addSubview:self.redView];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView==_quickLookView) {
        _isPlaying=NO;
    }
}


// 开始裁剪按钮点击
-(void)beginCutBtnDidClicked{
    if([_beginCutBtn.currentTitle isEqualToString:@"开始裁剪"] ){
        [self pauseTheVideo];
        [_beginCutBtn setTitle:@"剪切完成" forState:UIControlStateNormal];
        _isCutting=YES;
    }else{
        [self beginToCutterVideo];
    }
    
    
    
}

//裁剪操作
-(void)beginToCutterVideo{
    
    NSFileManager *fileMag=[NSFileManager defaultManager];
    
    [fileMag removeItemAtURL:[self clipUrl] error:nil];

    
    NSURL *clipPath = _assetURL;
    AVMutableComposition *mainComposition = [[AVMutableComposition alloc]init];
    AVMutableCompositionTrack *videoTrack=[mainComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *audioTrack =[mainComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime duration=kCMTimeZero;
    AVAsset *asset = [AVAsset assetWithURL:clipPath];
    CGFloat beginValue = _totalTime*(_beginoffset/(_quickLookView.contentSize.width-Main_Screen_Width));
    CGFloat endValue = _totalTime*(_endoffset/(_quickLookView.contentSize.width-Main_Screen_Width));
    
    NSLog(@"--%.2f---%.2f",beginValue,endValue);
    
    CMTimeRange rangeTime = CMTimeRangeMake(CMTimeMakeWithSeconds( beginValue, asset.duration.timescale), CMTimeMakeWithSeconds(endValue, asset.duration.timescale));
    [videoTrack insertTimeRange:rangeTime ofTrack:[asset tracksWithMediaType:AVMediaTypeVideo].firstObject atTime:duration error:nil];
    
    [audioTrack insertTimeRange:rangeTime ofTrack:[asset tracksWithMediaType:AVMediaTypeAudio].firstObject atTime:duration error:nil];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mainComposition presetName:AVAssetExportPreset1280x720];
    
    exporter.outputURL = [self clipUrl];
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    NSLog(@"%@",exporter.outputURL);
    
    
    __weak typeof (self) weakSelf = self;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        
        NSLog(@"%zd",exporter.status);
        
        switch (exporter.status) {
                
            case AVAssetExportSessionStatusWaiting:
                break;
            case AVAssetExportSessionStatusExporting:
                break;
            case AVAssetExportSessionStatusCompleted:{
                NSLog(@"exporting completed");
                dispatch_async(dispatch_get_main_queue(), ^{

                    self.assetURL=[self clipUrl];
                    
                });
                
            }
                
                break;
            default:
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
                NSLog(@"exporting failed %@",[exporter error]);
                break;
        }
        
    }];
    
    
    
    
    
    NSLog(@"kaishikaishikaishi");
}


//计数方法
-(void)coutLabelPlus{
    //      AVURLAsset *avasset = [[AVURLAsset alloc]initWithURL:_sourceURL options:nil];
    
    if (_player!=nil) {
        
        CMTime time = _player.currentTime;
        
        CGFloat floatTime=time.value*1.0f/time.timescale;
        //        CGFloat scale = time.value/_asset.duration.value;
        //        NSLog(@"%.2f",scale);
        NSInteger currentTime=[[NSNumber numberWithFloat:floatTime] integerValue];
        _beginlabel.text=[NSString stringWithFormat:@"%zd",currentTime];
        NSLog(@"%.2f",floatTime);
        if (floatTime<_totalTime) {
            
            [_quickLookView setContentOffset:CGPointMake(floatTime*(50*(imageWidth/imageheight)), 0) animated:YES];
        }
        
        
    }
    if (_player.currentTime.value==_asset.duration.value) {
        [_timer setFireDate:[NSDate distantFuture]];
        //        _beginlabel.text=[NSString stringWithFormat:@"%zd",0];
        
    }
}

@end
