//
//  MPDatePickerView.m
//  MobileProject
//
//  Created by wujunyang on 2017/8/7.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPDatePickerView.h"
#import "NSDate+Extension.h"
#import "NSDate+Utilities.h"
#import "NSDate+Formatter.h"


#define navigationViewHeight 44.0f
#define pickViewViewHeight 180.0f
#define buttonWidth 60.0f
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define windowColor  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]

typedef NS_ENUM(NSUInteger,VYDatePickerType)
{
    VYDatePickerDayType,
    VYDatePickerHourType,
    VYDatePickerMinuteType,
    VYDatePickerTimeRegionType
};

typedef NS_ENUM(NSUInteger,VYDateRangeType)
{
    VYDateRangeMinType,
    VYDateRangeMiddleType,
    VYDateRangeMaxType
};

@interface MPDatePickerView()

//数据源
@property(nonatomic,strong)NSMutableArray *monthAndDayMutableArray;
@property(nonatomic,strong)NSMutableArray *timeRegionMutableArray;
@property(nonatomic,strong)NSMutableArray *hourMutableArray;
@property(nonatomic,strong)NSMutableArray *minuteMutableArray;

//控件
@property(nonatomic,strong)UIPickerView *pickView;
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)UIView *navigationView;
@property(nonatomic,strong)UIButton *leftButton,*rightButton;

//初始绑定
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSDate *selectedDate;
@property(nonatomic,strong)NSDate *minimumDate;
@property(nonatomic,strong)NSDate *maximumDate;
@property(nonatomic,strong)NSDate *lastDate;

//事件block
@property(nonatomic,copy)selectDateBlock selectDateBlock;
@property(nonatomic,copy)cancelBlock cancelBlock;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation MPDatePickerView

-(instancetype)initWithTitle:(NSString *)title selectedDate:(NSDate *)selectedDate minimumDate:(NSDate *)minimumDate maximumDate:(NSDate *)maximumDate doneBlock:(selectDateBlock)doneBlock cancelBlock:(cancelBlock)cancelBlock
{
    self=[super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _title=title;
        _selectedDate=selectedDate;
        _lastDate=selectedDate;
        _minimumDate=minimumDate;
        _maximumDate=maximumDate;
        _selectDateBlock=doneBlock;
        _cancelBlock=cancelBlock;
        
        [self addTapGestureRecognizerToSelf];
        [self configPickViewData];
        [self configPickView];
        [self configSelected];
    }
    return self;
}

-(void)configPickViewData
{
    if (!self.monthAndDayMutableArray) {
        self.monthAndDayMutableArray=[[NSMutableArray alloc]init];
    }
    
    if (!self.timeRegionMutableArray) {
        self.timeRegionMutableArray=[[NSMutableArray alloc]init];
    }
    
    if (!self.hourMutableArray) {
        self.hourMutableArray=[[NSMutableArray alloc]init];
    }
    
    if (!self.minuteMutableArray) {
        self.minuteMutableArray=[[NSMutableArray alloc]init];
    }
    
    [self dayOperation];
    [self timeRegionOperation];
    [self hourOperationWithTimeRegion:[self isAMTimeRegion:self.selectedDate]?@"AM":@"PM"];
    [self minuteOperationWithTimeRegion:[self isAMTimeRegion:self.selectedDate]?@"AM":@"PM"  WithHour:[self hour12System:self.selectedDate.hour]];
}

-(void)configPickView
{
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, navigationViewHeight+pickViewViewHeight)];
    [self addSubview:self.backgroundView];
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, navigationViewHeight)];
    _navigationView.backgroundColor = [UIColor blackColor];
    [self.backgroundView addSubview:_navigationView];
    
    UILabel *titleLabel=[UILabel new];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=SYSTEMFONT(14);
    titleLabel.text=self.title;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [_navigationView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    UITapGestureRecognizer *tapNavigationView = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    [_navigationView addGestureRecognizer:tapNavigationView];
    
    self.leftButton=[UIButton buttonWithType:UIButtonTypeSystem];
    self.leftButton.titleLabel.font=SYSTEMFONT(14);
    [self.leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:HEXCOLOR(0xFFCC05) forState:UIControlStateNormal];
    [self.leftButton setTitleColor:HEXCOLOR(0xFFCC05) forState:UIControlStateHighlighted];
    self.leftButton.tag = 1000;
    [self.leftButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(buttonWidth, navigationViewHeight));
    }];
    
    
    self.rightButton=[UIButton buttonWithType:UIButtonTypeSystem];
    self.rightButton.titleLabel.font=SYSTEMFONT(14);
    [self.rightButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:HEXCOLOR(0xFFCC05) forState:UIControlStateNormal];
    [self.rightButton setTitleColor:HEXCOLOR(0xFFCC05) forState:UIControlStateHighlighted];
    self.rightButton.tag = 1001;
    [self.rightButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(buttonWidth, navigationViewHeight));
    }];
    
    
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, navigationViewHeight, kScreenWidth, pickViewViewHeight)];
    _pickView.backgroundColor = [UIColor whiteColor];
    _pickView.dataSource = self;
    _pickView.delegate =self;
    [self.backgroundView addSubview:_pickView];
    
    [self showBottomView];
}

-(void)configSelected
{
    for (NSInteger dayItemIndex=0; dayItemIndex<self.monthAndDayMutableArray.count; dayItemIndex++) {
        if ([self isDate:self.selectedDate sameDayAsDate:self.monthAndDayMutableArray[dayItemIndex] withExistHour:NO withExistMinute:NO]) {
            [self.pickView selectRow:dayItemIndex inComponent:VYDatePickerDayType animated:NO];
            break;
        }
    }
    
    for (NSInteger timeRegionIndex=0; timeRegionIndex<self.timeRegionMutableArray.count; timeRegionIndex++) {
        if ([self.timeRegionMutableArray[timeRegionIndex] isEqualToString:[self isAMTimeRegion:self.selectedDate]?@"AM":@"PM"]) {
            [self.pickView selectRow:timeRegionIndex inComponent:VYDatePickerTimeRegionType animated:NO];
            break;
        }
    }
    
    for (NSInteger hourIndex=0; hourIndex<self.hourMutableArray.count; hourIndex++) {
        NSInteger hourValue=[self hour12System:self.selectedDate.hour];
        if(0==hourValue)
        {
            hourValue=12;
        }
        if (hourValue==[self.hourMutableArray[hourIndex] integerValue]) {
            [self.pickView selectRow:hourIndex inComponent:VYDatePickerHourType animated:NO];
            break;
        }
    }
    
    for (NSInteger minuteIndex=0; minuteIndex<self.hourMutableArray.count; minuteIndex++) {
        NSInteger minuteValue=self.selectedDate.minute;
        if ([self isDate:self.selectedDate sameDayAsDate:self.maximumDate withExistHour:NO withExistMinute:YES]&&(minuteValue>=[self.minuteMutableArray[minuteIndex] integerValue])) {
            [self.pickView selectRow:minuteIndex inComponent:VYDatePickerMinuteType animated:NO];
            break;
        }
        
        if (minuteValue<=[self.minuteMutableArray[minuteIndex] integerValue]) {
            [self.pickView selectRow:minuteIndex inComponent:VYDatePickerMinuteType animated:NO];
            break;
        }
    }
    
    if([self isDate:self.selectedDate sameDayAsDate:self.minimumDate withExistHour:NO withExistMinute:YES])
    {
        self.rightButton.enabled=NO;
        [self.rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else
    {
        self.rightButton.enabled=YES;
        [self.rightButton setTitleColor:HEXCOLOR(0xFFCC05) forState:UIControlStateNormal];
    }
}

#pragma mark 视图处理事件

-(void)addTapGestureRecognizerToSelf
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBottomView)];
    [self addGestureRecognizer:tap];
}

-(void)showBottomView
{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.backgroundView.frame;
        frame.origin.y = kScreenHeight-navigationViewHeight-pickViewViewHeight;
        self.backgroundView.frame = frame;
        self.backgroundColor = windowColor;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hiddenBottomView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.backgroundView.frame;
        frame.origin.y = kScreenHeight;
        self.backgroundView.frame = frame;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

-(void)tapButton:(UIButton*)button
{
    if (button.tag == 1001) {
        //返回事件
        if (self.selectDateBlock) {
            self.selectDateBlock([self getResultDate]);
        }
    }
    else
    {
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
    [self hiddenBottomView];
}

#pragma mark 选择处理事件

-(BOOL)isDate:(NSDate*)date1 sameDayAsDate:(NSDate*)date2 withExistHour:(BOOL)existHour  withExistMinute:(BOOL)existMinute{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unitFlags =NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    if (existHour) {
        unitFlags=NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay| NSCalendarUnitHour;
    }
    
    if (existMinute) {
        unitFlags=NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay| NSCalendarUnitHour |NSCalendarUnitMinute;
    }
    
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    if (existHour) {
        return [comp1 day]   == [comp2 day] &&
        [comp1 month] == [comp2 month] &&
        [comp1 year]  == [comp2 year] &&[comp1 hour]==[comp2 hour];
    }
    
    if (existMinute) {
        return [comp1 day]   == [comp2 day] &&
        [comp1 month] == [comp2 month] &&
        [comp1 year]  == [comp2 year] &&[comp1 hour]==[comp2 hour] &&[comp1 minute]==[comp2 minute];
    }
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = @"ccc d MMM";
    }
    return _dateFormatter;
}


//获取两个日期之间的天数  起始日期  终止日期 总天数
- (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents    *comp = [calendar components:NSCalendarUnitDay
                                            fromDate:fromDate
                                              toDate:toDate
                                             options:NSCalendarWrapComponents];
    return comp.day+2;
}


#pragma mark 时间处理逻辑

//日期处理
-(void)dayOperation
{
    [self.monthAndDayMutableArray removeAllObjects];
    NSInteger dayCount=[self numberOfDaysWithFromDate:self.minimumDate toDate:self.maximumDate];
    for (NSInteger i=0; i<dayCount; i++) {
        [self.monthAndDayMutableArray addObject:(i==dayCount-1)?self.maximumDate:[self.minimumDate dateByAddingDays:i]];
    }
}

//上下午处理
-(void)timeRegionOperation
{
    NSArray *timeRegion=@[@"AM",@"PM"];
    self.timeRegionMutableArray=timeRegion.mutableCopy;
    
    BOOL isMinDate=[self isDate:self.selectedDate sameDayAsDate:self.minimumDate withExistHour:NO withExistMinute:NO];
    BOOL isManDate=[self isDate:self.selectedDate sameDayAsDate:self.maximumDate withExistHour:NO withExistMinute:NO];
    
    if (!isMinDate&&!isManDate) {
        return;
    }
    
    [self.timeRegionMutableArray removeAllObjects];
    
    if (isMinDate) {
        self.timeRegionMutableArray=[self isPMTimeRegion:self.minimumDate]?@[@"PM"].mutableCopy:timeRegion.mutableCopy;
    }
    else
    {
        self.timeRegionMutableArray=[self isAMTimeRegion:self.maximumDate]?@[@"AM"].mutableCopy:timeRegion.mutableCopy;
    }
}

//小时处理
-(void)hourOperationWithTimeRegion:(NSString *)timeRegion
{
    NSArray *hourArray=@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12];
    self.hourMutableArray=hourArray.mutableCopy;
    
    BOOL isMinDate=[self isDate:self.selectedDate sameDayAsDate:self.minimumDate withExistHour:NO withExistMinute:NO];
    BOOL isManDate=[self isDate:self.selectedDate sameDayAsDate:self.maximumDate withExistHour:NO withExistMinute:NO];
    
    if (!isMinDate&&!isManDate) {
        return;
    }
    
    NSInteger hour=0;
    
    if(isMinDate)
    {
        hour=[self hour12System:self.minimumDate.hour];
        BOOL isAMTimeRegion=[self isAMTimeRegion:self.minimumDate]&&[timeRegion isEqualToString:@"AM"];
        BOOL isPMTimeRegion=[self isPMTimeRegion:self.minimumDate];
        if (isAMTimeRegion||isPMTimeRegion) {
            [self.hourMutableArray removeAllObjects];
            
            NSInteger endHour=((isAMTimeRegion&&hour!=0)||(isPMTimeRegion&&hour!=12))?11:12;
            while (hour<=endHour) {
                if(hour!=0)
                {
                    [self.hourMutableArray addObject:@(hour)];
                }
                hour++;
            }
        }
    }
    else
    {
        hour=[self hour12System:self.maximumDate.hour];
        
        if ([self isPMTimeRegion:self.maximumDate]&&[timeRegion isEqualToString:@"AM"]) {
            return;
        }
        
        BOOL isPMTimeRegion=[self isPMTimeRegion:self.maximumDate]&&[timeRegion isEqualToString:@"PM"];
        if (isPMTimeRegion||[self isAMTimeRegion:self.maximumDate]) {
            [self.hourMutableArray removeAllObjects];
            
            if (hour==0) {
                [self.hourMutableArray addObject:@12];
            }
            
            while (hour>=1) {
                [self.hourMutableArray addObject:@(hour)];
                hour--;
            }
            
            if (self.maximumDate.hour<12&&[timeRegion isEqualToString:@"AM"]) {
                [self.hourMutableArray addObject:@12];
            }
            
            //倒序处理
            NSEnumerator *enumerator = [self.hourMutableArray reverseObjectEnumerator];
            self.hourMutableArray =[[NSMutableArray alloc]initWithArray: [enumerator allObjects]];
        }
    }
}

//分钟处理
-(void)minuteOperationWithTimeRegion:(NSString *)timeRegion WithHour:(NSInteger)hour
{
    NSArray *minuteArray=@[@0,@5,@10,@15,@20,@25,@30,@35,@40,@45,@50,@55];
    self.minuteMutableArray=minuteArray.mutableCopy;
    
    BOOL isMinDate=[self isDate:self.selectedDate sameDayAsDate:self.minimumDate withExistHour:NO withExistMinute:NO];
    BOOL isManDate=[self isDate:self.selectedDate sameDayAsDate:self.maximumDate withExistHour:NO withExistMinute:NO];
    
    
    if (!isMinDate&&!isManDate) {
        return;
    }
    
    NSInteger minute=0;
    if (isMinDate) {
        minute=self.minimumDate.minute;
        NSInteger minHour=[self hour12System:self.minimumDate.hour];
        
        
        if ([self isAMTimeRegion:self.minimumDate]) {
            if ([timeRegion isEqualToString:@"PM"]) {
                return;
            }
            
            if (hour!=minHour&&minHour!=0) {
                return;
            }
            
            if (hour>minHour&&hour!=12) {
                return;
            }
            
        }
        else
        {
            if (hour!=minHour) {
                return;
            }
        }
        
        
        [self.minuteMutableArray removeAllObjects];
        for (NSNumber *item in minuteArray) {
            if (minute<=[item integerValue]) {
                [self.minuteMutableArray addObject:item];
            }
        }
    }
    else
    {
        minute=self.maximumDate.minute;
        NSInteger maxHour=[self hour12System:self.maximumDate.hour];
        if (maxHour!=hour) {
            return;
        }
        
        [self.minuteMutableArray removeAllObjects];
        for (NSNumber *item in minuteArray) {
            if(minute>=[item integerValue])
            {
                [self.minuteMutableArray addObject:item];
            }
        }
    }
}

#pragma mark 时间处理

-(NSInteger)hour12System:(NSInteger)hour
{
    return hour>12?hour-12:hour;
}

-(BOOL)isAMTimeRegion:(NSDate *)date
{
    return date.hour<12;
}

-(BOOL)isPMTimeRegion:(NSDate *)date
{
    return date.hour>=12;
}

//判断时间天所处的类型
-(VYDateRangeType)getDateRangeType:(NSDate *)date
{
    BOOL isMinDate=[self isDate:date sameDayAsDate:self.minimumDate withExistHour:NO withExistMinute:NO];
    BOOL isManDate=[self isDate:date sameDayAsDate:self.maximumDate withExistHour:NO withExistMinute:NO];
    
    
    if (!isMinDate&&!isManDate) {
        return VYDateRangeMiddleType;
    }
    
    if (isMinDate) {
        return VYDateRangeMinType;
    }
    
    return VYDateRangeMaxType;
}

-(BOOL)isHourUpDateSource
{
    BOOL isSelectedMinDate=[self isDate:self.selectedDate sameDayAsDate:self.minimumDate withExistHour:NO withExistMinute:NO];
    BOOL isSelectedMaxDate=[self isDate:self.selectedDate sameDayAsDate:self.maximumDate  withExistHour:NO withExistMinute:NO];
    
    BOOL isLastMinDate=[self isDate:self.lastDate sameDayAsDate:self.minimumDate withExistHour:NO withExistMinute:NO];
    BOOL isLastMaxDate=[self isDate:self.lastDate sameDayAsDate:self.maximumDate withExistHour:NO withExistMinute:NO];
    
    if (isSelectedMinDate||isSelectedMaxDate||isLastMinDate||isLastMaxDate) {
        return YES;
    }
    
    return NO;
}

-(BOOL)isMinuteUpDateSource
{
    BOOL isSelectedMinDate=[self isDate:[self getResultDate] sameDayAsDate:self.minimumDate withExistHour:YES withExistMinute:NO];
    BOOL isSelectedMaxDate=[self isDate:[self getResultDate] sameDayAsDate:self.maximumDate  withExistHour:YES withExistMinute:NO];
    
    BOOL isLastMinDate=[self isDate:self.lastDate sameDayAsDate:self.minimumDate withExistHour:YES withExistMinute:NO];
    BOOL isLastMaxDate=[self isDate:self.lastDate sameDayAsDate:self.maximumDate withExistHour:YES withExistMinute:NO];
    
    if (isSelectedMinDate||isSelectedMaxDate||isLastMinDate||isLastMaxDate) {
        return YES;
    }
    
    return NO;
}



-(NSDate *)getResultDate
{
    NSDate *currentDate=[self.monthAndDayMutableArray objectAtIndex:[self.pickView selectedRowInComponent:VYDatePickerDayType]];
    NSString *currentTimeRegion=[self.timeRegionMutableArray objectAtIndex:[self.pickView selectedRowInComponent:VYDatePickerTimeRegionType]];
    NSInteger currentHour=[[self.hourMutableArray objectAtIndex:[self.pickView selectedRowInComponent:VYDatePickerHourType]] integerValue];
    NSInteger currentMinute=[[self.minuteMutableArray objectAtIndex:[self.pickView selectedRowInComponent:VYDatePickerMinuteType]] integerValue];
    
    if ([currentTimeRegion isEqualToString:@"AM"]&&currentHour==12) {
        currentHour=0;
    }
    
    if([currentTimeRegion isEqualToString:@"PM"]&&currentHour<12)
    {
        currentHour+=12;
    }
    
    NSDate *resultDate=[[NSCalendar currentCalendar] dateBySettingHour:currentHour minute:currentMinute second:0 ofDate:currentDate options:0];
    return resultDate;
}

-(BOOL)isCorrectRangeWithTimeRegion:(NSString *)timeRegion
{
    NSDate *currentDate=[self.monthAndDayMutableArray objectAtIndex:[self.pickView selectedRowInComponent:VYDatePickerDayType]];
    NSInteger currentHour=[[self.hourMutableArray objectAtIndex:[self.pickView selectedRowInComponent:VYDatePickerHourType]] integerValue];
    NSInteger currentMinute=[[self.minuteMutableArray objectAtIndex:[self.pickView selectedRowInComponent:VYDatePickerMinuteType]] integerValue];
    
    if ([timeRegion isEqualToString:@"AM"]&&currentHour==12) {
        currentHour=0;
    }
    
    if([timeRegion isEqualToString:@"PM"]&&currentHour<12)
    {
        currentHour+=12;
    }
    
    NSDate *resultDate=[[NSCalendar currentCalendar] dateBySettingHour:currentHour minute:currentMinute second:0 ofDate:currentDate options:0];
    
    if([resultDate isEarlierThanDate:self.maximumDate]&&[resultDate isLaterThanDate:self.minimumDate]){
        return YES;
    }
    
    return NO;
}

-(void)correnctTimeRegionSelectedIndex:(NSString *)timeRegion
{
    for (NSInteger timeRegionIndex=0; timeRegionIndex<self.timeRegionMutableArray.count; timeRegionIndex++) {
        if ([self.timeRegionMutableArray[timeRegionIndex] isEqualToString:timeRegion]) {
            [self.pickView selectRow:timeRegionIndex inComponent:VYDatePickerTimeRegionType animated:NO];
            break;
        }
    }
}

-(void)correctHourSelectedIndex:(NSInteger)hourValue
{
    for (NSInteger hourIndex=0; hourIndex<self.hourMutableArray.count; hourIndex++) {
        if(0==hourValue)
        {
            hourValue=12;
        }
        if (hourValue==[self.hourMutableArray[hourIndex] integerValue]) {
            [self.pickView selectRow:hourIndex inComponent:VYDatePickerHourType animated:NO];
            break;
        }
    }
}

-(void)conrrectMinuteSelectedIndex:(NSInteger)MinuteValue
{
    for(NSInteger minuteIndex=0;minuteIndex<self.minuteMutableArray.count;minuteIndex++)
    {
        if (MinuteValue==[self.minuteMutableArray[minuteIndex] integerValue]) {
            [self.pickView selectRow:minuteIndex inComponent:VYDatePickerMinuteType animated:NO];
            break;
        }
    }
}

#pragma mark UIPicker Detegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == VYDatePickerDayType) {
        return self.monthAndDayMutableArray.count;
    } else if (component == VYDatePickerTimeRegionType) {
        return self.timeRegionMutableArray.count;
    } else if(component ==VYDatePickerHourType){
        return self.hourMutableArray.count;
    }
    else {
        return self.minuteMutableArray.count;
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lable=[[UILabel alloc]init];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.font=SYSTEMFONT(20);
    if (component == VYDatePickerDayType) {
        NSDate *curDate=[self.monthAndDayMutableArray objectAtIndex:row];
        if ([self isDate:curDate sameDayAsDate:[NSDate date] withExistHour:NO withExistMinute:NO]) {
            lable.text=@"Today";
        }
        else{
            lable.text=[self.dateFormatter stringFromDate:curDate];
        }
    } else if (component == VYDatePickerTimeRegionType) {
        lable.text=[self.timeRegionMutableArray objectAtIndex:row];
    }else if(component ==VYDatePickerHourType)
    {
        lable.text=[NSString stringWithFormat:@"%02ld",[[self.hourMutableArray objectAtIndex:row] integerValue]];
    } else {
        lable.text=[NSString stringWithFormat:@"%02ld",[[self.minuteMutableArray objectAtIndex:row] integerValue]];
    }
    return lable;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat pickViewWidth = 70;
    if (component==VYDatePickerDayType) {
        pickViewWidth=150;
    }
    return pickViewWidth;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == VYDatePickerDayType) {
        self.selectedDate=[self.monthAndDayMutableArray objectAtIndex:row];
        
        NSString *currentTimeRegion=[self.timeRegionMutableArray objectAtIndex:[self.pickView selectedRowInComponent:VYDatePickerTimeRegionType]];
        
        NSInteger currentHour=[[self.hourMutableArray objectAtIndex:[self.pickView selectedRowInComponent:VYDatePickerHourType]] integerValue];
        
        NSInteger currentMinute=[[self.minuteMutableArray objectAtIndex:[self.pickView selectedRowInComponent:VYDatePickerMinuteType]] integerValue];
        
        if ([self getDateRangeType:self.lastDate]!=[self getDateRangeType:[self getResultDate]]) {
            [self timeRegionOperation];
            [pickerView reloadComponent:VYDatePickerTimeRegionType];
            
            [self correnctTimeRegionSelectedIndex:currentTimeRegion];
            if (![self.timeRegionMutableArray containsObject:currentTimeRegion]) {
                [self hourOperationWithTimeRegion:self.timeRegionMutableArray[0]];
                [self minuteOperationWithTimeRegion:self.timeRegionMutableArray[0] WithHour:[self hour12System:[self.hourMutableArray[0] integerValue]]];
                
                [pickerView reloadComponent:VYDatePickerHourType];
                [pickerView reloadComponent:VYDatePickerMinuteType];
                
                if (![self isCorrectRangeWithTimeRegion:self.timeRegionMutableArray[0]]) {
                    [pickerView selectRow:0 inComponent:VYDatePickerHourType animated:YES];
                    [pickerView selectRow:0 inComponent:VYDatePickerMinuteType animated:YES];
                }
                else
                {
                    [self correctHourSelectedIndex:currentHour];
                    [self conrrectMinuteSelectedIndex:currentMinute];
                }
            }
            else
            {
                [self hourOperationWithTimeRegion:currentTimeRegion];
                [self minuteOperationWithTimeRegion:currentTimeRegion WithHour:[self hour12System:[self.hourMutableArray[0] integerValue]]];
                
                [pickerView reloadComponent:VYDatePickerHourType];
                [pickerView reloadComponent:VYDatePickerMinuteType];
                
                if (![self isCorrectRangeWithTimeRegion:currentTimeRegion]) {
                    [pickerView selectRow:0 inComponent:VYDatePickerHourType animated:YES];
                    [pickerView selectRow:0 inComponent:VYDatePickerMinuteType animated:YES];
                }
                else
                {
                    [self correctHourSelectedIndex:currentHour];
                    [self conrrectMinuteSelectedIndex:currentMinute];
                }
            }
            
        }
    }
    else if (component==VYDatePickerTimeRegionType){
        NSString *timeRegion=[self.timeRegionMutableArray objectAtIndex:row];
        
        if ([self isHourUpDateSource]) {
            [self hourOperationWithTimeRegion:timeRegion];
            [self minuteOperationWithTimeRegion:timeRegion WithHour:[self.hourMutableArray[0] integerValue]];
            
            [pickerView reloadComponent:VYDatePickerHourType];
            [pickerView reloadComponent:VYDatePickerMinuteType];
            
            [pickerView selectRow:0 inComponent:VYDatePickerHourType animated:YES];
            [pickerView selectRow:0 inComponent:VYDatePickerMinuteType animated:YES];
        }
        
    }
    else if(component==VYDatePickerHourType){
        NSString *currentTimeRegion=[self.timeRegionMutableArray objectAtIndex:[self.pickView selectedRowInComponent:VYDatePickerTimeRegionType]];
        NSNumber *hourNum=[self.hourMutableArray objectAtIndex:row];
        
        if ([self isMinuteUpDateSource]) {
            [self minuteOperationWithTimeRegion:currentTimeRegion WithHour:[hourNum integerValue]];
            
            [pickerView reloadComponent:VYDatePickerMinuteType];
            [pickerView selectRow:0 inComponent:VYDatePickerMinuteType animated:YES];
        }
    }
    
    self.lastDate=[self getResultDate];
    
    if ([self.lastDate isLaterThanDate:self.maximumDate]||[self.lastDate isEarlierThanDate:self.minimumDate]) {
        self.rightButton.enabled=NO;
        [self.rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@" Please check it is correct" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        self.rightButton.enabled=YES;
        [self.rightButton setTitleColor:HEXCOLOR(0xFFCC05) forState:UIControlStateNormal];
    }
}

@end
