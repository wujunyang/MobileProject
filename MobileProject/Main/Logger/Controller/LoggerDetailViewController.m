//
//  LoggerDetailViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/1/27.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "LoggerDetailViewController.h"

@interface LoggerDetailViewController ()<MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) NSString *logText;
@property (nonatomic, strong) NSString *logDate;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation LoggerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.textView.editable = NO;
    self.textView.text = self.logText;
    [self.view addSubview:self.textView];
    
    //设置右边
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,70,30)];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"邮件" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(sendMailMessage)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id)initWithLog:(NSString *)logText forDateString:(NSString *)logDate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _logText = logText;
        _logDate = logDate;
        self.title = logDate;
    }
    return self;
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            [MBProgressHUD showSuccess:@"发送邮件成功" ToView:self.view];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            [MBProgressHUD showError:@"发送邮件失败" ToView:self.view];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 自定义代码

-(void)sendMailMessage
{
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        mc.mailComposeDelegate = self;
        [mc setSubject:@"关于错误日志内容"];
        [mc setToRecipients:[NSArray arrayWithObjects:kMail_cc_ToRecipients_Address, nil]];
        //设置cc
        //[mc setCcRecipients:[NSArray arrayWithObject:@"xxxxx@163.com"]];
        //设置bcc
        //[mc setBccRecipients:[NSArray arrayWithObject:@"xxxxx@gmail.com"]];
        //纯文本 如果是带html 可以把isHtml打开
        [mc setMessageBody:_logText isHTML:YES];
        
        //如果有附件
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"blood_orange"
        //                                                     ofType:@"png"];
        //NSData *data = [NSData dataWithContentsOfFile:path];
        //[mc addAttachmentData:data mimeType:@"image/png" fileName:@"blood_orange"];
        
        //在模拟器IOS9都会闪退
        [self presentViewController:mc animated:YES completion:nil];
    }
    else
    {
        // 在设备还没有添加邮件账户的时候mailViewController为空，下面的present view controller会导致程序崩溃，这里要作出判断
        [MBProgressHUD showMessage:@"设备还没有添加邮件账户,请先增加" ToView:self.view RemainTime:3];
    }

}



@end
