//
//  MPImageCollectionCell.m
//  MobileProject
//
//  Created by wujunyang on 16/7/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPImageCollectionCell.h"



@implementation MPImageCollectionCell

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
            [_deleteBtn setImage:[UIImage imageNamed:@"btn_right_delete_image"] forState:UIControlStateNormal];
            _deleteBtn.backgroundColor = [UIColor blackColor];
            _deleteBtn.layer.cornerRadius = CGRectGetWidth(_deleteBtn.bounds)/2;
            _deleteBtn.layer.masksToBounds = YES;
            
            [_deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_deleteBtn];
        }
    }
    return self;
}


-(void)setCurImageItem:(MPImageItemModel *)curImageItem
{
    _curImageItem=curImageItem;
    if (_curImageItem) {
        
        RAC(self.imgView, image) = [RACObserve(self.curImageItem, thumbnailImage) takeUntil:self.rac_prepareForReuseSignal];
        _deleteBtn.hidden = NO;
    }
    else
    {
        _imgView.image = [UIImage imageNamed:@"btn_addPicture_BgImage"];
        if (_deleteBtn) {
            _deleteBtn.hidden = YES;
        }
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
