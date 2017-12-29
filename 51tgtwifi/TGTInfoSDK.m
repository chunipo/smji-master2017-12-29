//
//  TGTInfoSDK.m
//  TGTInfoSDK
//
//  Created by weiyuxiang on 2017/10/12.
//  Copyright (c) 2015年 TGT. All rights reserved.
//

#import "TGTInfoSDK.h"
#import "AsyncSocket.h"
#import <UIKit/UIKit.h>
#import "Get_IP_Address.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#define KeyMis  @"CMD_GET_DEVICE_INFO"

typedef void (^InfoBlock1)(NSDictionary *dic);
typedef void (^InfoBlock2)(NSDictionary *dic);
typedef void (^errorBlock)(NSString *error);

@interface TGTInfoSDK()<AsyncSocketDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate> {
    
    NSURLConnection *infoConnection;
    NSMutableData *infoLoadData;
    
    NSURLConnection *flowConnection;
    NSMutableData *flowLoadData;
}
@property (nonatomic,strong)NSDictionary *dataList;
@property (nonatomic,strong)errorBlock errorBlock;
@property (nonatomic,strong)InfoBlock2 infoBlock2;
@property (nonatomic,strong)InfoBlock1 infoBlock1;
@property (nonatomic,strong)InfoBlock infoBlock;
@property (nonatomic,retain)AsyncSocket *socket;
@property (nonatomic,retain)AsyncSocket *socket1;

@end

@implementation TGTInfoSDK

- (void )initTGTWiFiWithSSID:(NSString *)ssid returnTGTFlow:(InfoBlock)tgtFlow error:(ErrorBlock)errorFlow {
    
    if ([ssid hasPrefix:@"TGT01"] || [ssid hasPrefix:@"tgt01"] ) {
        
        if (ssid.length == 14 || ssid.length == 15) {
            
            [self sendRequest1:ssid];
            self.infoBlock2  = ^(NSDictionary *dic){
                
                tgtFlow(dic);
            };
            self.errorBlock  = ^(NSString *error){
                
                errorFlow(error);
            };
            
        } else {
            
        }
        
    } else {
        
        // socket 通信
        _socket1 = [[AsyncSocket alloc] initWithDelegate:self];
        [_socket1 setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        NSError *error;
        NSString *ipStr = [Get_IP_Address getIPAddress:YES];
        NSArray *ipArr = [ipStr componentsSeparatedByString:@"."];
        NSString *ip_host = [NSString stringWithFormat:@"%@.%@.%@.1",ipArr[0],ipArr[1],ipArr[2]];
        [_socket1  connectToHost:ip_host
                          onPort:51848
                     withTimeout:-1
                           error:&error ];
        
        NSString *inputMsgStr = KeyMis;
        NSString * content = [inputMsgStr stringByAppendingString:@"\r\n"];
        NSData *data1 = [content dataUsingEncoding:NSISOLatin1StringEncoding];
        [_socket1 writeData: data1 withTimeout: -1 tag: 0];
        
        self.infoBlock2  = ^(NSDictionary *dic){
            
            tgtFlow(dic);
        };
        self.errorBlock  = ^(NSString *error){
            
            errorFlow(error);
        };
    }
}

- (void)initTGTWiFiWithSSID:(NSString *)ssid returnTGTInfo:(InfoBlock)tgtInfo error:(ErrorBlock)errorInfo {
    
    if ([ssid hasPrefix:@"TGT01"] || [ssid hasPrefix:@"tgt01"] ) {
        
        if (ssid.length == 14 || ssid.length == 15) {
            
            [self sendRequest];
            self.infoBlock1  = ^(NSDictionary *dic){
                
                tgtInfo(dic);
            };
            self.errorBlock  = ^(NSString *error){
                
                errorInfo(error);
            };
        } else {
            
        }
        
    } else {
        
        // socket 通信
        _socket = [[AsyncSocket alloc] initWithDelegate:self];
        [_socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        NSError *error;
        NSString *ipStr = [Get_IP_Address getIPAddress:YES];
        NSArray *ipArr = [ipStr componentsSeparatedByString:@"."];
        NSString *ip_host = [NSString stringWithFormat:@"%@.%@.%@.1",ipArr[0],ipArr[1],ipArr[2]];
        [_socket  connectToHost:ip_host
                         onPort:51848
                    withTimeout:8
                          error:&error ];
        
//      请求指令
        NSString *inputMsgStr = @"getDeviceInfo";
//
        NSString *content = [inputMsgStr stringByAppendingString:@"\r\n"];
        NSData *data1 = [content dataUsingEncoding:NSISOLatin1StringEncoding];
        [_socket writeData: data1 withTimeout: -1 tag: 0];
        
        
        
        self.infoBlock1  = ^(NSDictionary *dic){
            
            tgtInfo(dic);
        };
        self.errorBlock  = ^(NSString *error){
            
            errorInfo(error);
        };
    }
}



#pragma mark -    -----  T1 获取设备信息  -----

-(void)sendRequest1:(NSString *)str {
    
    if (!flowLoadData) {
        flowLoadData = [NSMutableData data];
    }
    NSString *url = [NSString stringWithFormat:@"http://api.51tgt.com/api/getDevicePackageInfo/sn/%@/key/e720090407a55c4ca61018337273de39/channelcode/CN-A-31-731970068",str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = 10;
    flowConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)sendRequest {
    
    if (!infoLoadData) {
        infoLoadData = [NSMutableData data];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.43.1:8080/login/tgtJson"]];
    request.timeoutInterval = 10;
    infoConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == infoConnection) {
        infoLoadData.length = 0;
    } else {
        flowLoadData.length = 0;
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == infoConnection) {
        [infoLoadData appendData:data];
    } else {
        [flowLoadData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == infoConnection) {
        
        NSString *result;
        @synchronized(result) {
            
            result = [[NSString alloc] initWithData:infoLoadData  encoding:NSUTF8StringEncoding];
            //去除末尾的</html>
            NSString *resut1 = [result stringByReplacingOccurrencesOfString:@"</html>" withString:@""];
            NSData *data = [resut1 dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
            self.infoBlock1(jsonDic);
        }
    } else {
        
        NSString *result = [[NSString alloc] initWithData:flowLoadData  encoding:NSUTF8StringEncoding];
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArr = (NSArray *)jsonDic[@"data"];
        if (dataArr.count == 0) {
            self.errorBlock(@"当前设备无流量套餐");
        } else {
            NSDictionary *dic = (NSDictionary *)dataArr[0];
            self.infoBlock2(dic);
        }
    }
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    NSLog(@"连接失败，请检查网络连接");
    if (connection == flowConnection) {
        self.errorBlock(@"获取套餐信息失败");
    } if (connection == infoConnection) {
        self.errorBlock(@"获取设备信息失败");
    }
}

#pragma mark -    -----  T2 获取设置信息  -----
//开启监听

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    
    [sock readDataWithTimeout:-1 tag:0];
    NSString *inputMsgStr = KeyMis;
    NSString *content = [inputMsgStr stringByAppendingString:@"\r\n"];
    NSData *data1 = [content dataUsingEncoding:NSISOLatin1StringEncoding];
    [_socket writeData: data1 withTimeout: -1 tag: 0];

}
//连接成功，打开监听数据读取，如果不监听那么无法读取数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [sock readDataWithTimeout:-1 tag:0];
    
    NSData *data1 = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
    self.dataList = jsonDic;
    if (jsonDic.count != 0) {
        
        if (sock == _socket) {
        
            self.infoBlock1(jsonDic);
        } else {
            
            self.infoBlock2(jsonDic);
        }
    }
    
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock{
  NSLog(@"连接断开#########");
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"连接将要断开###%@###%@###",err,self.dataList);
    if (self.dataList.count == 0) {
        self.errorBlock(@"获取信息失败");
    }
}

#pragma mark - 获取当前WiFi的SSID
- (NSString *)getWiFiSSID {
    
    NSString *wifiSSID;
    CFArrayRef array = CNCopySupportedInterfaces();
    
    if (array != nil) {
        
        CFDictionaryRef dic = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(array, 0));
        if (dic != nil) {
            
            NSDictionary *myDic = (NSDictionary *)CFBridgingRelease(dic);
            wifiSSID = [myDic valueForKey:@"SSID"];
        }
    }
    return wifiSSID;
}

@end
