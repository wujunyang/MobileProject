//
//  MPBasicAlgorithmViewController.m
//  MobileProject
//
//  Created by wujunyang on 2018/11/29.
//  Copyright © 2018 wujunyang. All rights reserved.
//

#import "MPBasicAlgorithmViewController.h"

@interface MPBasicAlgorithmViewController ()

@property(nonatomic,strong)NSMutableArray *tmpArray;

@end

@implementation MPBasicAlgorithmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //降序跟升序
    [self descendingOrder];
    [self ascendingOrder];
    
    //递归
    _tmpArray=[[NSMutableArray alloc]init];
    NSArray *testArray = @[@"2",@3,@[@"re",@"fd"],@[@"rr",@"ll",@[@[@8,@"fd"],@"jj"]]];
    NSMutableArray *resultArray = [self outputArray:testArray];
    NSLog(@"递归：%@",resultArray);
    
    //字符反转
    [self stringInversion];
}


#pragma mark -- 数组降序
//注意事项：
//1：实现思路
 //a，每一趟比较都比较数组中两个相邻元素的大小
 //b，如果i元素小于i-1元素，就调换两个元素的位置
 //c，重复n-1趟的比较
//2：这边要用NSMutableArray的类型进行
//3：因为这边是nsnumber类型所以要转换一下进行比较 [array[j] integerValue]<[array[j+1] integerValue] 若直接array[j]跟array[j+1]比较会错误
//
-(void)descendingOrder
{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:@[@23,@3,@15,@17,@44,@34,@21]];
    
    for (int i=0; i<array.count-1; i++) {
        for (int j=0; j<array.count-1-i; j++) {
            if ([array[j] integerValue]<[array[j+1] integerValue]) {
                NSNumber *tmp=array[j];
                array[j]=array[j+1];
                array[j+1]=tmp;
            }
        }
    }
    
    NSLog(@"数组降序开始");
    NSLog(@"当前值:%@",array);
    NSLog(@"数组降序结束");
}


#pragma mark -- 升序 参考上面做法
-(void)ascendingOrder
{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:@[@23,@3,@15,@17,@44,@34,@21]];
    
    for (int i=0; i<array.count-1; i++) {
        for (int j=0; j<array.count-1-i; j++) {
            if ([array[j] integerValue]>[array[j+1] integerValue]) {
                NSNumber *tmp=array[j];
                array[j]=array[j+1];
                array[j+1]=tmp;
            }
        }
    }
    
    NSLog(@"数组升序开始");
    NSLog(@"当前值:%@",array);
    NSLog(@"数组升序结束");
}

#pragma mark -- 递归
// 注意事项
// 1：用于存储的中间数要是一个成员变量，不能直接在递归方法里定义如下面的tmpArray，在使用时必须要初始化
// 2：符合某种类型的条件就接着调用该方法进行遍历
//
-(NSMutableArray *)outputArray:(NSArray *)mutArray
{
    for (int i = 0;i< mutArray.count ; i++) {
        if ([mutArray[i] isKindOfClass:[NSArray class]]) {
            [self outputArray:mutArray[i]];
        }else{
            [_tmpArray addObject:mutArray[i]];
        }
    }
    return _tmpArray;
}

#pragma mark -- 字符串反转

-(void)stringInversion
{
    //字符反转
    NSString *name=@"wujun";
    NSMutableString *reverseString = [NSMutableString string];
    for (NSInteger i = name.length -1 ; i >= 0; i--) {
        unichar c = [name characterAtIndex:i];
        NSString *s = [NSString stringWithCharacters:&c length:1];
        [reverseString appendString:s];
    }
    NSLog(@"当前的值%@",reverseString);
    
    //单词反转
    NSString *text=@"hellow wujun";
    NSArray *strArray = [text componentsSeparatedByString:@" "];
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSInteger i = strArray.count - 1;i >= 0; i--) {
        [mArray addObject:strArray[i]];
    }
    NSLog(@"当前的值%@",[mArray componentsJoinedByString:@" "]);
}


@end
