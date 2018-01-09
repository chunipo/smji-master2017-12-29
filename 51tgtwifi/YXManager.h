//
//  YXManager.h
//  51tgtwifi
//
//  Created by DEVCOM on 2017/12/20.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PackagInfoModel.h"

@interface YXManager : NSObject
+ (instancetype)share;
@property (assign, nonatomic)BOOL isBind;//判断命令是绑定设备还是不绑定
@property (assign, nonatomic)BOOL isLight;//判断是否开启闪光灯
@property (assign, nonatomic)BOOL isScan;//判断是否扫描完成
@property (assign, nonatomic)BOOL isOpenBluetooth;//判断是否开启蓝牙
@property (assign, nonatomic)BOOL isConnectInfo;//连接wifi的指令
@property (assign, nonatomic)BOOL isConnectWifi;//判断是否是接上了热点，
@property (strong, nonatomic)NSString *WIFIpwd;//外设热点密码
@property (strong, nonatomic)NSString *WIFIname;//外设热点密码

@property (strong, nonatomic)NSString *ScanID;//扫描二维码得到的
@property (strong, nonatomic)NSString *str;

@property (strong, nonatomic)NSString *password;
@property (strong, nonatomic)NSString *SSID;
@property (strong, nonatomic)NSString *appVersion;
@property (assign, nonatomic)BOOL isReload;

/* 连接到的外设 */
@property (nonatomic, strong) CBPeripheral *peripheral;

@property (strong, nonatomic)PackagInfoModel *model;
@property (strong, nonatomic)PackagInfoModel *modelTranslate;
@property (strong, nonatomic)PackagInfoModel *modelGlobal;

@end
