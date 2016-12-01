//
//  MPMasonryView.m
//  MobileProject
//
//  Created by wujunyang on 2016/11/11.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPMasonryView.h"

@interface MPMasonryView()
@property(nonatomic,strong)UIView *myView;
@end


@implementation MPMasonryView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor blueColor];
        
        if (!self.myView) {
            self.myView =[UIView new];
            self.myView.backgroundColor=[UIColor redColor];
            [self addSubview:self.myView];
        }
    }
    return self;
}


-(void)setLeftWidth:(CGFloat)leftWidth
{
    _leftWidth=leftWidth;
    
    [self setNeedsUpdateConstraints];
}

-(void)setRightWidth:(CGFloat)rightWidth
{
    _rightWidth=rightWidth;
    
    [self setNeedsUpdateConstraints];
}

//setNeedsUpdateConstraints 要结合[super updateConstraints]用不然会报错
//***** [super updateConstraints]的运用
- (void)updateConstraints
{
    if (self.leftWidth>100) {
        [self.myView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(5);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
    }
    
    if (self.rightWidth>100) {
        [self.myView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-5);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(30);
        }];
    }
    
    [super updateConstraints];
}

@end
