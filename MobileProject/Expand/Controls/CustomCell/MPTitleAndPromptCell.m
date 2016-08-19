//
//  MPTitleAndPromptCell.m
//  MobileProject
//
//  Created by wujunyang on 16/8/19.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPTitleAndPromptCell.h"

@interface MPTitleAndPromptCell()
@property(strong,nonatomic)UILabel *keyLabel,*valueLabel;
@property(strong,nonatomic)UIView *lineView;
@end

static const CGFloat spaceWith=15;

@implementation MPTitleAndPromptCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置背影色
        self.backgroundColor=[UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        
        if (self.keyLabel==nil) {
            self.keyLabel=[[UILabel alloc]init];
            self.keyLabel.font=CHINESE_SYSTEM(14);
            self.keyLabel.textColor=COLOR_WORD_GRAY_1;
            [self.contentView addSubview:self.keyLabel];
            [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.left).with.offset(spaceWith);
                make.centerY.mas_equalTo(self.contentView).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(80, 15));
            }];
        }
        
        if (self.valueLabel==nil) {
            self.valueLabel=[[UILabel alloc]init];
            self.valueLabel.textAlignment=NSTextAlignmentRight;
            self.valueLabel.font=CHINESE_SYSTEM(14);
            self.valueLabel.textColor=COLOR_WORD_GRAY_2;
            [self.contentView addSubview:self.valueLabel];
            [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView).with.offset(0);
                make.right.mas_equalTo(self.right).with.offset(-2*spaceWith);
                make.size.mas_equalTo(CGSizeMake(Main_Screen_Width-80-2*spaceWith, 18));
            }];
        }
        
        if (self.lineView==nil) {
            self.lineView = [[UIView alloc] init];
            self.lineView.hidden=YES;
            self.lineView.backgroundColor=COLOR_UNDER_LINE;
            [self.contentView addSubview:self.lineView];
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.left).with.offset(spaceWith);
                make.right.mas_equalTo(self.right).with.offset(0);
                make.top.mas_equalTo(self.bottom).with.offset(-0.5);
                make.height.mas_equalTo(@0.5);
            }];
        }
    }
    return self;
}


-(void)setCellDataKey:(NSString *)curkey curValue:(NSString *)curvalue blankValue:(NSString *)blankvalue isShowLine:(BOOL)showLine cellType:(MPTitleAndPromptCellType)cellType
{
    self.keyLabel.text=curkey;
    self.lineView.hidden=!showLine;
    if ([curvalue length]==0) {
        self.valueLabel.text=blankvalue;
        self.valueLabel.textColor=COLOR_WORD_GRAY_2;
    }
    else
    {
        self.valueLabel.text=curvalue;
        self.valueLabel.textColor=COLOR_WORD_BLACK;
    }
    switch (cellType) {
        case MPTitleAndPromptCellTypeInput: {
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        }
        case MPTitleAndPromptCellTypeSelect: {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
