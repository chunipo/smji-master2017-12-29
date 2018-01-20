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

@property (assign, nonatomic)BOOL isActiveSuc;//判断是否激活成功设备
@property (assign, nonatomic)BOOL isActive;//判断设备是否已经激活
@property (assign, nonatomic)BOOL isBind;//判断命令是连接设备还是不连接
@property (assign, nonatomic)BOOL isLight;//判断是否开启闪光灯
@property (assign, nonatomic)BOOL isScan;//判断是否扫描完成
@property (assign, nonatomic)BOOL isStarAcan;//判断是否正在扫描
@property (assign, nonatomic)BOOL isOpenBluetooth;//判断是否开启蓝牙
@property (assign, nonatomic)BOOL isConnectInfo;//连接wifi的指令
@property (assign, nonatomic)BOOL isConnectWifi;//判断是否是接上了热点，
@property (strong, nonatomic)NSString *WIFIpwd;//外设热点密码
@property (strong, nonatomic)NSString *WIFIname;//外设热点密码

@property (strong, nonatomic)NSString *LanguageStr;//国家语言
@property (strong, nonatomic)NSString *ScanID;//扫描二维码得到的

@property (nonatomic, strong)NSString *OrderName;//订单名称
@property (nonatomic, strong)NSString *Product_id;//订单id
@property (nonatomic, strong)NSString *OrderPrice;//订单价格
@property (nonatomic, strong)NSString *out_order_no;//支付成返回给服务器


@property (strong, nonatomic)NSString *str;

@property (strong, nonatomic)NSString *password;
@property (strong, nonatomic)NSString *SSID;
@property (strong, nonatomic)NSString *appVersion;
@property (assign, nonatomic)BOOL isReload;

/* 连接到的外设 */
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (strong, nonatomic)NSString *sn;
@property (strong, nonatomic)PackagInfoModel *model;
@property (strong, nonatomic)PackagInfoModel *modelTranslate;
@property (strong, nonatomic)PackagInfoModel *modelGlobal;

@end
