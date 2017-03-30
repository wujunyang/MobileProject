//
//  MPImageProgressCollectionCell.m
//  MobileProject
//
//  Created by wujunyang on 16/7/22.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPImageProgressCollectionCell.h"


@interface MPImageProgressCollectionCell()
@property(nonatomic,strong)M13ProgressViewPie *progressView;
@property(nonatomic)CGFloat propress;
@end

@implementation MPImageProgressCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (!_imgView) {
            _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageCollectionCell_Width, kImageCollectionCell_Width)];
            _imgView.contentMode = UIViewContentModeScaleAspectFill;
            _imgView.clipsToBounds = YES;
            _imgView.layer.masksToBounds = YES;
            _imgView.layer.cornerRadius = 2.0;
            [self.contentView addSubview:_imgView];
        }
        
        if (!_deleteBtn) {
            _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kImageCollectionCell_Width-20, 0, 20, 20)];
            _deleteBtn.hidden=YES;
            [_deleteBtn setImage:[UIImage imageNamed:@"btn_right_delete_image"] forState:UIControlStateNormal];
            _deleteBtn.backgroundColor = [UIColor blackColor];
            _deleteBtn.layer.cornerRadius = CGRectGetWidth(_deleteBtn.bounds)/2;
            _deleteBtn.layer.masksToBounds = YES;
            
            [_deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_deleteBtn];
        }
        
        if (!_progressView) {
            _progressView=[[M13ProgressViewPie alloc]initWithFrame:CGRectMake(kImageCollectionCell_Width-25, kImageCollectionCell_Width-25, 20, 20)];
            _progressView.primaryColor=[UIColor whiteColor];
            _progressView.secondaryColor=[UIColor grayColor];
            [self.contentView addSubview:_progressView];
        }
    }
    return self;
}


-(void)setCurImageItem:(MPImageItemModel *)curImageItem
{
    _curImageItem=curImageItem;
    if (_curImageItem) {
        
        _imgView.image=curImageItem.thumbnailImage;
        _deleteBtn.hidden = YES;
        
        RAC(self.imgView, image) = [RACObserve(self.curImageItem, thumbnailImage)takeUntil:self.rac_prepareForReuseSignal];
        
        if (self.curImageItem.image&&_curImageItem.uploadState==MPImageUploadStateSuccess) {
            self.deleteBtn.hidden=NO;
            self.progressView.hidden=YES;
        }
        else if (self.curImageItem.image&&_curImageItem.uploadState!=MPImageUploadStateSuccess)
        {
            self.deleteBtn.hidden=YES;
            self.progressView.hidden=NO;
        }
        else
        {
            self.deleteBtn.hidden=YES;
            self.progressView.hidden=YES;
        }
        //上传任务，并赋值给当前propress
        MPWeakSelf(self)
        [[RACObserve(self.curImageItem, image) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(UIImage *imageItem) {
            MPStrongSelf(self)
            if (imageItem&&self.curImageItem.uploadState!=MPImageUploadStateSuccess) {
                    MPUploadImageItemService *req=[[MPUploadImageItemService alloc]initWithUploadImageItem:self.curImageItem];
                
                //上传进度 记得放上面才会进行触发
                req.uploadPropressBlock = ^(NSProgress *uploadProgress){
                    
                    MPStrongSelf(self);
                    CGFloat propress = uploadProgress.completedUnitCount*1.0/uploadProgress.totalUnitCount;
                    NSLog(@"进度进度：%lld/%lld___%2f",uploadProgress.completedUnitCount,uploadProgress.completedUnitCount,propress);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.propress=propress;
                    });
                };
                
                    [req startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
                        //上传成功后返回图片信息
                        self.curImageItem.upServicePath=@"2sdfsdfsdf.JPG";
                        
                    } failure:^(__kindof YTKBaseRequest *request) {
                        [MPRequstFailedHelper requstFailed:request];
                    }];
                
            }
        }];
    }
    else
    {
        _imgView.image = [UIImage imageNamed:@"btn_addPicture_BgImage"];
        if (_deleteBtn) {
            _deleteBtn.hidden = YES;
        }
        
        if (_progressView) {
            _progressView.hidden=YES;
        }
    }
}


-(void)setPropress:(CGFloat)propress
{
    _propress=propress;
    MPWeakSelf(self)
    if (_propress) {
        [[RACObserve(self, propress) takeUntil:
          [RACSignal combineLatest:@[self.rac_prepareForReuseSignal, self.rac_willDeallocSignal]]]
         subscribeNext:^(NSNumber *fractionCompleted) {
             MPStrongSelf(self)
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.progressView setProgress:fractionCompleted.floatValue animated:YES];
                 if (fractionCompleted.floatValue>=1) {
                     //上传完成修改一些相应的状态
                     self.curImageItem.uploadState=MPImageUploadStateSuccess;
                     self.progressView.hidden=YES;
                     self.deleteBtn.hidden=NO;
                     
                     //删除沙盒里面的对应图片
                     [MPFileManager deleteUploadDataWithName:self.curImageItem.photoName];
                 }
                 else
                 {
                     self.curImageItem.uploadState=MPImageUploadStateIng;
                     self.progressView.hidden=NO;
                     self.deleteBtn.hidden=YES;
                 }
             });
         }];
    }
    else
    {
        self.progressView.hidden=YES;
    }
}


- (void)deleteBtnClicked:(id)sender{
    if (_deleteImageBlock) {
        _deleteImageBlock(_curImageItem);
    }
}

+(CGSize)ccellSize{
    return CGSizeMake(kImageCollectionCell_Width,kImageCollectionCell_Width);
}


@end
