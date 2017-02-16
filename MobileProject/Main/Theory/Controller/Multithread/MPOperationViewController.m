//
//  MPOperationViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/16.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPOperationViewController.h"

@interface MPOperationViewController ()

@end

@implementation MPOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    //一：NSInvocationOperation子类+主队列
    [self addOperationFormInvocation];
    //二：NSInvocationOperation子类+非主队列  (新开线程中执行)
    [self addAsnysOperationFormInvocation];
    //三：使用子类- NSBlockOperation 主线程执行
    [self addOperationFormBlock];
    //四：使用子类- NSBlockOperation 子线程执行 加入非主队列
    [self addAsnysOperationFormBlock];
    //五：maxConcurrentOperationCount设置 并发或串行
    [self addMaxConcurrentOperation];
    //六：定义继承自NSOperation的子类
    [self addChildNSOperation];
    //七：操作依赖
    [self addDependency];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------------------
//理论知识：
//NSOperation是苹果提供给我们的一套多线程解决方案。实际上NSOperation是基于GCD更高一层的封装，但是比GCD更简单易用、代码可读性也更高。
//NSOperation需要配合NSOperationQueue来实现多线程。因为默认情况下，NSOperation单独使用时系统同步执行操作，并没有开辟新线程的能力，只有配合NSOperationQueue才能实现异步执行

//------------------------------------------------------------------------------------------
//步骤3
//创建任务：先将需要执行的操作封装到一个NSOperation对象中。
//创建队列：创建NSOperationQueue对象。
//将任务加入到队列中：然后将NSOperation对象添加到NSOperationQueue中。

//------------------------------------------------------------------------------------------
//创建队列
//NSOperationQueue一共有两种队列：主队列、其他队列
//主队列 NSOperationQueue *queue = [NSOperationQueue mainQueue]; 凡是添加到主队列中的任务（NSOperation），都会放到主线程中执行
//其他队列（非主队列） NSOperationQueue *queue = [[NSOperationQueue alloc] init]; 就会自动放到子线程中执行 同时包含了：串行、并发功能

//------------------------------------------------------------------------------------------
//NSOperation是个抽象类，并不能封装任务。我们只有使用它的子类来封装任务。我们有三种方式来封装任务。
//
//使用子类NSInvocationOperation
//使用子类NSBlockOperation
//定义继承自NSOperation的子类，通过实现内部相应的方法来封装任务

//------------------------------------------------------------------------------------------
//其它知识点
//- (void)cancel; NSOperation提供的方法，可取消单个操作
//- (void)cancelAllOperations; NSOperationQueue提供的方法，可以取消队列的所有操作
//- (void)setSuspended:(BOOL)b; 可设置任务的暂停和恢复，YES代表暂停队列，NO代表恢复队列
//- (BOOL)isSuspended; 判断暂停状态
//------------------------------------------------------------------------------------------


//一：NSInvocationOperation子类+主队列  (主线程中执行)
-(void)addOperationFormInvocation
{
    //NSOperationQueue *queue = [NSOperationQueue mainQueue];  //主队列 主线程  //[queue addOperation:op];进行加入动作  //不用写[op start];便可执行
    
    // 1.创建NSInvocationOperation对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(runAction) object:nil];
    
    // 2.调用start方法开始执行操作
    [op start];
}

-(void)runAction
{
    NSLog(@"当前NSInvocationOperation执行的线程为：%@", [NSThread currentThread]);
    //输出：当前NSInvocationOperation执行的线程为：<NSThread: 0x600000071940>{number = 1, name = main}
    
    //说明
//  在没有使用NSOperationQueue、单独使用NSInvocationOperation的情况下，NSInvocationOperation在主线程执行操作，并没有开启新线程。
}


//二：NSInvocationOperation子类+非主队列  (新开线程中执行)
-(void)addAsnysOperationFormInvocation
{
    // 1. 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.创建NSInvocationOperation对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(runAsnysAction) object:nil];
    
    [queue addOperation:op];
}

-(void)runAsnysAction
{
    NSLog(@"当前addAsnysOperationFormInvocation执行的线程为：%@", [NSThread currentThread]);
    //输出：当前addAsnysOperationFormInvocation执行的线程为：<NSThread: 0x600000279040>{number = 8, name = (null)}
    
    //说明
    //  创建NSOperationQueue队列，并把NSInvocationOperation加入则会新开一个线程来执行。
}


//三：使用子类- NSBlockOperation 主线程执行
-(void)addOperationFormBlock
{
    //NSOperationQueue *queue = [NSOperationQueue mainQueue];  //主队列 主线程  //[queue addOperation:op];进行加入动作  //不用写[op start];便可执行
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        // 在主线程
        NSLog(@"NSBlockOperation当前的线程：%@", [NSThread currentThread]);
        //输出：NSBlockOperation当前的线程：<NSThread: 0x60800007ecc0>{number = 1, name = main}
    }];
    
    // 添加额外的任务(部分在子线程执行)
    [op addExecutionBlock:^{
        NSLog(@"NSBlockOperation当前的线程2------%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"NSBlockOperation当前的线程3------%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"NSBlockOperation当前的线程4------%@", [NSThread currentThread]);
    }];
    
    [op start];
    
    
    //输出
//    NSBlockOperation当前的线程：<NSThread: 0x600000261800>{number = 1, name = main}
//    NSBlockOperation当前的线程2------<NSThread: 0x600000261800>{number = 1, name = main}
//    NSBlockOperation当前的线程3------<NSThread: 0x600000479100>{number = 5, name = (null)}
//    NSBlockOperation当前的线程4------<NSThread: 0x600000261800>{number = 1, name = main}
}


//四：使用子类- NSBlockOperation 子线程执行 加入非主队列
-(void)addAsnysOperationFormBlock
{
    // 1. 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        // 在子线程
        NSLog(@"addAsnysOperationFormBlock当前的线程：%@", [NSThread currentThread]);
    }];
    
    // 添加额外的任务（部分在新的子线程运行）
    [op addExecutionBlock:^{
        NSLog(@"addAsnysOperationFormBlock当前的线程2------%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"addAsnysOperationFormBlock当前的线程3------%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"addAsnysOperationFormBlock当前的线程4------%@", [NSThread currentThread]);
    }];
    
    [queue addOperation:op];
    
    
    //输出：
//    addAsnysOperationFormBlock当前的线程：<NSThread: 0x608000668400>{number = 9, name = (null)}
//    addAsnysOperationFormBlock当前的线程2------<NSThread: 0x608000668400>{number = 9, name = (null)}
//    addAsnysOperationFormBlock当前的线程3------<NSThread: 0x608000668400>{number = 9, name = (null)}
//    addAsnysOperationFormBlock当前的线程4------<NSThread: 0x600000463000>{number = 10, name = (null)}
}


//五：maxConcurrentOperationCount设置 并发或串行
-(void)addMaxConcurrentOperation
{
    // 1. 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //并发操作的最大值：你可以设定NSOperationQueue可以并发运行的最大操作数。NSOperationQueue会选择去运行任何数量的并发操作，但是不会超过最大值
    queue.maxConcurrentOperationCount=10;
    //修改成它的默认值
    //queue.MaxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        // 在子线程
        NSLog(@"addMaxConcurrentOperation当前的线程：%@", [NSThread currentThread]);
    }];
    
    // 添加额外的任务（部分在新的子线程运行）
    [op addExecutionBlock:^{
        NSLog(@"addMaxConcurrentOperation当前的线程2------%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"addMaxConcurrentOperation当前的线程3------%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"addMaxConcurrentOperation当前的线程4------%@", [NSThread currentThread]);
    }];
    
    [queue addOperation:op];
    
    
//    addMaxConcurrentOperation当前的线程：<NSThread: 0x600000460ac0>{number = 8, name = (null)}
//    addMaxConcurrentOperation当前的线程2------<NSThread: 0x600000460ac0>{number = 8, name = (null)}
//    addMaxConcurrentOperation当前的线程3------<NSThread: 0x600000460ac0>{number = 8, name = (null)}
//    addMaxConcurrentOperation当前的线程4------<NSThread: 0x60800026fc80>{number = 5, name = (null)}

    //说明：
//    maxConcurrentOperationCount默认情况下为-1，表示不进行限制，默认为并发执行。
//    当maxConcurrentOperationCount为1时，进行串行执行。
//    当maxConcurrentOperationCount大于1时，进行并发执行，当然这个值不应超过系统限制，即使自己设置一个很大的值，系统也会自动调整
}


//六：定义继承自NSOperation的子类
-(void)addChildNSOperation
{
    // 1. 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    MPOperation *op = [[MPOperation alloc] init];
    
    [queue addOperation:op];
    
//    输出
//    MPOperation当前的线程-----<NSThread: 0x6080002768c0>{number = 11, name = (null)}
//    MPOperation当前的线程-----<NSThread: 0x6080002768c0>{number = 11, name = (null)}
}


//七：操作依赖
-(void)addDependency
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"addDependency1当前线程%@", [NSThread  currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"addDependency2当前线程%@", [NSThread  currentThread]);
    }];
    
    [op1 addDependency:op2];    // 让op1 依赖于 op2，则先执行op2，在执行op1
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    
    
    //输出
//    addDependency2当前线程<NSThread: 0x60000027c200>{number = 12, name = (null)}
//    addDependency1当前线程<NSThread: 0x608000262900>{number = 9, name = (null)}
}
@end
