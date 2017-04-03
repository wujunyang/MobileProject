//
//  MPLazyImageViewCustomView.m
//  MobileProject
//
//  Created by wujunyang on 2017/4/2.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPLazyImageViewCustomView.h"

@interface MPLazyImageViewCustomView()

@property(nonatomic,strong)UIImageView *myImageView;

@end


@implementation MPLazyImageViewCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.myImageView];
        [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.centerX).offset(0);
            make.top.mas_equalTo(self.centerY).offset(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

-(void)setImageName:(NSString *)imageName
{
    _imageName=imageName;
    self.myImageView.image=[UIImage imageNamed:imageName];
}


-(UIImageView *)myImageView
{
    if (!_myImageView) {
        _myImageView=[UIImageView new];
    }
    return _myImageView;
}

@end
