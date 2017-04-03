//
//  MPLazyTitleViewCustomView.m
//  MobileProject
//
//  Created by wujunyang on 2017/4/2.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPLazyTitleViewCustomView.h"

@interface MPLazyTitleViewCustomView()

@property(nonatomic,strong)UILabel *myTitleLabel;

@end

@implementation MPLazyTitleViewCustomView

- (instancetype)init
{
    return [self initWithTitle:@""];
}

-(instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        [self addSubview:self.myTitleLabel];
        [self.myTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        self.myTitleLabel.text=title;
    }
    return self;
}


-(UILabel *)myTitleLabel
{
    if (!_myTitleLabel) {
        _myTitleLabel=[UILabel new];
        _myTitleLabel.font=AdaptedFontSize(15);
        _myTitleLabel.textColor=[UIColor blueColor];
        _myTitleLabel.textAlignment=NSTextAlignmentCenter;
    }
    
    return _myTitleLabel;
}

@end
