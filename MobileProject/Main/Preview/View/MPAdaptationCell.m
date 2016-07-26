//
//  MPAdaptationCell.m
//  MobileProject
//
//  Created by wujunyang on 16/7/26.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MPAdaptationCell.h"

@interface MPAdaptationCell()
@property(strong,nonatomic)UILabel *myDateLabel,*myTextLabel;
@end

static const CGFloat KTopSpace=10;
static const CGFloat KLeftSpace=15;
static const CGFloat KTextLabelFontSize=13;

@implementation MPAdaptationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self LayoutLayoutCell];
    }
    return self;
}

-(void)LayoutLayoutCell
{
    if (!self.myDateLabel) {
        self.myDateLabel=[[UILabel alloc]init];
        self.myDateLabel.font=AdaptedFontSize(13);
        self.myDateLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:self.myDateLabel];
        [self.myDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(AdaptedHeight(KTopSpace));
            make.left.mas_equalTo(KLeftSpace);
            make.right.mas_equalTo(-KLeftSpace);
            make.height.mas_equalTo(AdaptedHeight(15));
        }];
    }
    
    if (!self.myTextLabel) {
        self.myTextLabel=[[UILabel alloc]init];
        self.myTextLabel.font=AdaptedFontSize(KTextLabelFontSize);
        self.myTextLabel.textColor=[UIColor grayColor];
        self.myTextLabel.numberOfLines=0;
        [self.myTextLabel sizeToFit];
        [self.contentView addSubview:self.myTextLabel];
        [self.myTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.myDateLabel.bottom).offset(AdaptedHeight(KTopSpace));
            make.left.mas_equalTo(KLeftSpace);
            make.right.mas_equalTo(-KLeftSpace);
        }];

    }
}


-(void)configCellWithText:(NSString *)text dateText:(NSString *)dateText
{
    self.myDateLabel.text=dateText;
    
    self.myTextLabel.attributedText = [MPAdaptationCell cellTextAttributed:text];
}


+(CGFloat)cellHegith:(NSString *)text
{
    CGFloat result=3*AdaptedHeight(10)+AdaptedHeight(15);
    if (text.length>0) {
        result=result+[[self cellTextAttributed:text] boundingRectWithSize:CGSizeMake(Main_Screen_Width-2*KLeftSpace, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    }
    return result;
}


+(NSAttributedString *)cellTextAttributed:(NSString *)text
{
    //富文本设置文字行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 4;
    
    NSDictionary *attributes = @{ NSFontAttributeName:AdaptedFontSize(KTextLabelFontSize), NSParagraphStyleAttributeName:paragraphStyle};
    return [[NSAttributedString alloc]initWithString:text attributes:attributes];
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
