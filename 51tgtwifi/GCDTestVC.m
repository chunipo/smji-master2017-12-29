//
//  GCDTestVC.m
//  51tgtwifi
//
//  Created by 51tgt on 2017/11/13.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "GCDTestVC.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

#define KeyMis  @"getDeviceInfo"

@interface GCDTestVC ()<GCDAsyncSocketDelegate>


@property (nonatomic,strong)GCDAsyncSocket *socket;

// 计时器
@property (nonatomic, strong) NSTimer *connectTimer;

@end

@implementation GCDTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    BOOL isSuc = [self.socket connectToHost:@"192.168.43.1" onPort:51848 error:nil];
    
    
    NSString *inputMsgStr = KeyMis;
    NSString * content = [inputMsgStr stringByAppendingString:@"\r\n"];
    NSData *data1 = [content dataUsingEncoding:NSISOLatin1StringEncoding];
    [self.socket writeData: data1 withTimeout: -1 tag: 0];
}

- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(UInt16)port{
    
    NSLog(@"---------连接成功---------");
    
    NSString *inputMsgStr = KeyMis;
    NSString * content = [inputMsgStr stringByAppendingString:@"\r\n"];
    NSData *data1 = [content dataUsingEncoding:NSISOLatin1StringEncoding];
    [self.socket writeData: data1 withTimeout: -1 tag: 0];

    // 连接成功开启定时器
    [self addTimer];
    [self.socket readDataWithTimeout:- 1 tag:0];
//    [self.socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:10 maxLength:50000 tag:0];

    
    

}


- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err{

    NSLog(@"---------连接失败---------%@",err);

    NSString *inputMsgStr = KeyMis;
    NSString * content = [inputMsgStr stringByAppendingString:@"\r\n"];
    NSData *data1 = [content dataUsingEncoding:NSISOLatin1StringEncoding];
    [self.socket writeData: data1 withTimeout: -1 tag: 0];

}


- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag{
     [self.socket readDataWithTimeout:- 1 tag:0];
    NSString *inputMsgStr = KeyMis;
    NSString * content = [inputMsgStr stringByAppendingString:@"\r\n"];
    NSData *data1 = [content dataUsingEncoding:NSISOLatin1StringEncoding];
    [self.socket writeData: data1 withTimeout: -1 tag: 0];

    
    
}

- (void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag{

NSLog(@"---------获取数据---------");
    
    
}

// 添加定时器
- (void)addTimer
{
    // 长连接定时器
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    // 把定时器添加到当前运行循环,并且调为通用模式
    [[NSRunLoop currentRunLoop] addTimer:self.connectTimer forMode:NSRunLoopCommonModes];
}

// 心跳连接
- (void)longConnectToSocket
{
    // 发送固定格式的数据,指令@"longConnect"
    NSString *inputMsgStr = KeyMis;
    NSString * content = [inputMsgStr stringByAppendingString:@"\r\n"];
    NSData *data1 = [content dataUsingEncoding:NSISOLatin1StringEncoding];
    [self.socket writeData: data1 withTimeout: -1 tag: 0];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
