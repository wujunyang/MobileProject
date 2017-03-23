//
//  MPThreadViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/16.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPThreadViewController.h"

@interface MPThreadViewController ()
@property(strong,nonatomic)NSThread *myThread;
//要运用atomic 线程安全
@property(strong,atomic)NSMutableArray *myThreadList;
@end

@implementation MPThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addThreadAction];
    
    //[self addMutableThread];
    
    [self ExitThread];
    
    [self addArrayThtead];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//一：简单创建一个多线程
-(void)addThreadAction
{
    NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(runAction) object:nil];
    thread.name=@"thread-wujy";
    [thread start];
    
    //另外的创建方式
    //1：创建线程后自动启动线程 [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
    //2：隐式创建并启动线程 [self performSelectorInBackground:@selector(run) withObject:nil];
}

-(void)runAction
{
    //阻塞（暂停）10秒后执行再下面内容
    [NSThread sleepForTimeInterval:10]; //单位是秒
    
    NSLog(@"当前线程为：%@",[NSThread currentThread]);
    //输出：当前线程为：<NSThread: 0x6080002699c0>{number = 9, name = thread-wujy}
    NSLog(@"当前线程%@主线程",[NSThread isMainThread]?@"是":@"不是");
    //当前线程不是主线程
    NSLog(@"当前主线程为：%@",[NSThread mainThread]);
    //当前主线程为：<NSThread: 0x608000077ec0>{number = 1, name = (null)}
}

//***注意：当调用[thread start];后，系统把线程对象放入可调度线程池中，线程对象进入就绪状态，如果没有其它再运行就可以马上执行，如果有其它再跑则要等待，所以启动线程它并不一定会马上执行；***



//二：测试增加一定数量对CPU的影响
-(void)addMutableThread
{
    //CPU 160%左右  内存150MB左右 平时80MB  这样写在主线程上创建100000多条thread导致卡住
    //    for (int num=0; num<100000; num++) {
    //        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(runMutableAction) object:nil];
    //        thread.name=[NSString stringWithFormat:@"thread-%d",num];
    //        [thread start];
    //    }
    
    
    //把创建子线程的操作放在一个子线程中进行 不影响主线程
    NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(runMutableThreadAction) object:nil];
    thread.name=[NSString stringWithFormat:@"thread-mutable"];
    [thread start];
}

-(void)runMutableThreadAction
{
    for (int num=0; num<100000; num++) {
        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(runMutableAction) object:nil];
        thread.name=[NSString stringWithFormat:@"thread-%d",num];
        [thread start];
    }
}

-(void)runMutableAction
{
    NSLog(@"当前线程为：%@",[NSThread currentThread]);
}


//三：强制退出线程
-(void)ExitThread
{
    if (!self.myThread) {
        self.myThread=[[NSThread alloc]initWithTarget:self selector:@selector(runExitAction) object:nil];
        self.myThread.name=@"thread-exit";
    }
    [self.myThread start];
}

-(void)runExitAction
{
    //阻塞（暂停）10秒后执行再下面内容
    [NSThread sleepForTimeInterval:10]; //单位是秒
    
    //结合下面的cancel运用 进行强制退出线程的操作
    if ([[NSThread currentThread] isCancelled]) {
        NSLog(@"当前thread-exit被exit动作了");
        [NSThread exit];
    }
    
    NSLog(@"当前thread-exit线程为：%@",[NSThread currentThread]);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //结合VC生命周期 viewWillDisappear退出页面时就把线程标识为cancel
    if (self.myThread && ![self.myThread isCancelled]) {
        NSLog(@"当前thread-exit线程被cancel");
        [self.myThread cancel];
        NSLog(@"当前thread-exit线程被cancel的状态 %@",[self.myThread isCancelled]?@"被标识为Cancel":@"没有被标识");
        //cancel 只是一个标识 最下退出强制终止线程的操作是exit 如果单写cancel 线程还是会继续执行
    }
    
    
    //结合VC生命周期 viewWillDisappear退出页面时就把线程标识为cancel 使用Thread一定要在退出前进行退出，否则会有闪存泄露的问题
    for (int i=0; i<self.myThreadList.count; i++){
        NSThread *thread=self.myThreadList[i];
        if (![thread isCancelled]) {
            NSLog(@"当前thread-exit线程被cancel");
            [thread cancel];
            //cancel 只是一个标识 最下退出强制终止线程的操作是exit 如果单写cancel 线程还是会继续执行
        }}
    
    
    //这页会报内存问题，是因为上面还有一些Thread没有进行退出操作
}


//四：用一个数组存储多条线程
-(void)addArrayThtead
{
    if (!self.myThreadList) {
        self.myThreadList=[[NSMutableArray alloc]init];
    }
    
    [self.myThreadList removeAllObjects];
    
    
    for(int i=0; i<10;i++)
    {
        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadAction:) object:[NSNumber numberWithInt:i]];
        thread.name=[NSString stringWithFormat:@"myThread%i",i];
        
        [self.myThreadList addObject:thread];
    }
    
    for (int i=0; i<self.myThreadList.count; i++) {
        NSThread *thread=self.myThreadList[i];
        [thread start];
    }
}

-(void)loadAction:(NSNumber *)index
{
    NSThread *thread=[NSThread currentThread];
    NSLog(@"loadAction是在线程%@中执行",thread.name);
    
    //回主线程去执行  有些UI相应 必须在主线程中更新
    [self performSelectorOnMainThread:@selector(updateImage) withObject:nil waitUntilDone:YES];
}

-(void)updateImage
{
    NSLog(@"执行完成了");
    NSLog(@"执行方法updateImage是在%@线程中",[NSThread isMainThread]?@"主":@"子");
    //输出：执行方法updateImage是在主线程中
}

@end
