//
//  BLETool.h
//  51tgtwifi
//
//  Created by 51tgt on 2017/11/9.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//设置代理
@protocol BleDelegate <NSObject>

@required
-(void)BLEDidDiscoverDeviceWithMac:(CBPeripheral *)peripheral;

@end


@interface BLETool : NSObject

+ (instancetype)shareInstance;

//可保存当前连接的设备，根据需要放在.h或者.m文件中
@property (nonatomic ,strong) CBPeripheral *currentPer;

#pragma mark - action of connecting layer -连接层操作
//扫描设备
- (void)scanDevice;

//停止扫描
- (void)stopScan;

//连接设备
- (void)connectDevice:(CBPeripheral *)peripheral;

//断开设备连接
- (void)unConnectDevice;

//重连设备
- (void)reConnectDevice:(BOOL)isConnect;

//检索已连接的外接设备
- (NSArray *)retrieveConnectedPeripherals;


@property(nonatomic,weak)id<BleDelegate> discoverDelegate;


@end
