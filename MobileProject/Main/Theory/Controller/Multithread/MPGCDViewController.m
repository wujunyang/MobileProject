//
//  MPGCDViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/16.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPGCDViewController.h"

@interface MPGCDViewController ()

@end

@implementation MPGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //一：并发队列 + 同步执行
    [self syncConcurrent];
    //二：并发队列 + 异步执行
    [self asyncConcurrent];
    //三：串行队列 + 同步执行
    [self syncSerial];
    //四：串行队列 + 异步执行
    [self asyncSerial];
    //五：主队列 + 同步执行 直接闪退
    //[self syncMain];
    //六：主队列 + 异步执行
    [self asyncMain];
    //七：全局队列+ 异步执行
    [self asyncGloba];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------------------
//理论知识
//同步执行（sync）：只能在当前线程中执行任务，不具备开启新线程的能力
//异步执行（async）：可以在新的线程中执行任务，具备开启新线程的能力
//------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------
//并发队列（Concurrent Dispatch Queue）：可以让多个任务并发（同时）执行（自动开启多个线程同时执行任务）,并发功能只有在异步（dispatch_async）函数下才有效
//串行队列（Serial Dispatch Queue）：让任务一个接着一个地执行（一个任务执行完毕后，再执行下一个任务）
//------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------
//// 串行队列的创建方法
//dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
//// 并发队列的创建方法
//dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
////创建全局并发队列
//dispatch_get_global_queue来创建全局并发队列


//dispatch_queue_t queue = dispatch_get_main_queue() 程序一启动，主线程就已经存在，主队列也同时就存在了，所以主队列不需要创建，只需要获取

//------------------------------------------------------------------------------------------
//六种类型：
//并发队列 + 同步执行
//并发队列 + 异步执行
//串行队列 + 同步执行
//串行队列 + 异步执行
//主队列 + 同步执行
//主队列 + 异步执行
//------------------------------------------------------------------------------------------


//一：并发队列 + 同步执行 (不会开启新线程，执行完一个任务，再执行下一个任务，并发队列只有结合异步执行才有效果)
- (void) syncConcurrent
{
    NSLog(@"syncConcurrent---begin");
    
    dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncConcurrent---end");
    
    //输出内容：
//    syncConcurrent---begin
//    1------<NSThread: 0x60000007a080>{number = 1, name = main}
//    1------<NSThread: 0x60000007a080>{number = 1, name = main}
//    2------<NSThread: 0x60000007a080>{number = 1, name = main}
//    2------<NSThread: 0x60000007a080>{number = 1, name = main}
//    3------<NSThread: 0x60000007a080>{number = 1, name = main}
//    3------<NSThread: 0x60000007a080>{number = 1, name = main}
//    syncConcurrent---end
    
//    说明
//    从并发队列 + 同步执行中可以看到，所有任务都是在主线程中执行的。由于只有一个线程，所以任务只能一个一个执行
//    所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间，这说明任务是添加到队列中马上执行的
}


//二：并发队列 + 异步执行(可同时开启多线程，任务交替执行)
- (void) asyncConcurrent
{
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue= dispatch_queue_create("test.asyncqueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncConcurrent---end");
    
    
    //输出内容：
//    asyncConcurrent---begin
//    asyncConcurrent---end
//    3------<NSThread: 0x608000474fc0>{number = 9, name = (null)}
//    3------<NSThread: 0x608000474fc0>{number = 9, name = (null)}
//    1------<NSThread: 0x60000007f780>{number = 10, name = (null)}
//    1------<NSThread: 0x60000007f780>{number = 10, name = (null)}
//    2------<NSThread: 0x600000460000>{number = 5, name = (null)}
//    2------<NSThread: 0x600000460000>{number = 5, name = (null)}
    
//    说明
//    在并发队列 + 异步执行中可以看出，除了主线程，又开启了3个线程，并且任务是交替着同时执行的。
//    所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始异步执行
}


//三：串行队列 + 同步执行（不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务）
- (void) syncSerial
{
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("test.syncSerial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncSerial---end");
    
    
    //输出内容
//    syncSerial---begin
//    1------<NSThread: 0x608000260580>{number = 1, name = main}
//    1------<NSThread: 0x608000260580>{number = 1, name = main}
//    2------<NSThread: 0x608000260580>{number = 1, name = main}
//    2------<NSThread: 0x608000260580>{number = 1, name = main}
//    3------<NSThread: 0x608000260580>{number = 1, name = main}
//    3------<NSThread: 0x608000260580>{number = 1, name = main}
//    syncSerial---end
    
//    说明
//    所有任务都是在主线程中执行的，并没有开启新的线程。而且由于串行队列，所以按顺序一个一个执行
//    所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间，这说明任务是添加到队列中马上执行的
}


//四：串行队列 + 异步执行(会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务)
- (void) asyncSerial
{
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("test.asyncSerial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncSerial---end");
    
    
    //输出的内容
//    asyncSerial---begin
//    asyncSerial---end
//    1------<NSThread: 0x608000663900>{number = 4, name = (null)}
//    1------<NSThread: 0x608000663900>{number = 4, name = (null)}
//    2------<NSThread: 0x608000663900>{number = 4, name = (null)}
//    2------<NSThread: 0x608000663900>{number = 4, name = (null)}
//    3------<NSThread: 0x608000663900>{number = 4, name = (null)}
//    3------<NSThread: 0x608000663900>{number = 4, name = (null)}
    
//    说明
//    开启了一条新线程，但是任务还是串行，所以任务是一个一个执行
//    所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始同步执行
}

//五. 主队列 + 同步执行  (互等卡住不可行(在主线程中调用),直接闪退)
- (void)syncMain
{
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncMain---end");
    
//    说明
//    我们把任务放到了主队列中，也就是放到了主线程的队列中。而同步执行有个特点，就是对于任务是立马执行的。那么当我们把第一个任务放进主队列中，它就会立马执行。但是主线程现在正在处理syncMain方法，所以任务需要等syncMain执行完才能执行。而syncMain执行到第一个任务的时候，又要等第一个任务执行完才能往下执行第二个和第三个任务。
//    
//    那么，现在的情况就是syncMain方法和第一个任务都在等对方执行完毕。这样大家互相等待，所以就卡住了，所以我们的任务执行不了
}


//六：主队列 + 异步执行 (只在主线程中执行任务，执行完一个任务，再执行下一个任务)
- (void)asyncMain
{
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncMain---end");
    
    //输出的内容
//    asyncMain---begin
//    asyncMain---end
//    1------<NSThread: 0x7fb623d015e0>{number = 1, name = main}
//    1------<NSThread: 0x7fb623d015e0>{number = 1, name = main}
//    2------<NSThread: 0x7fb623d015e0>{number = 1, name = main}
//    2------<NSThread: 0x7fb623d015e0>{number = 1, name = main}
//    3------<NSThread: 0x7fb623d015e0>{number = 1, name = main}
//    3------<NSThread: 0x7fb623d015e0>{number = 1, name = main}
    
//    说明
//    发现所有任务都在主线程中，虽然是异步执行，具备开启线程的能力，但因为是主队列，所以所有任务都在主线程中，并且一个接一个执行
//    所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始同步执行
}


//七：全局队列+ 异步执行
-(void)asyncGloba
{
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    // 2. 异步执行
    for (int i = 0; i < 10; ++i) {
        dispatch_async(q, ^{
            NSLog(@"asyncGloba：%@ %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"come here");
    
    //输出内容：
//    come here
//    asyncGloba：<NSThread: 0x608000464600>{number = 5, name = (null)} 0
//    asyncGloba：<NSThread: 0x608000464600>{number = 5, name = (null)} 3
//    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 1
//    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 5
//    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 6
//    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 7
//    asyncGloba：<NSThread: 0x60800047e100>{number = 19, name = (null)} 2
//    asyncGloba：<NSThread: 0x608000464600>{number = 5, name = (null)} 4
//    asyncGloba：<NSThread: 0x60800047e100>{number = 19, name = (null)} 9
//    asyncGloba：<NSThread: 0x60000027d480>{number = 18, name = (null)} 8
//    说明：come here 说明是异步执行，没有马上执行，并且有开子线程执行
}

@end
