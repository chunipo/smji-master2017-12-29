//
//  TGTInfoSDK.h
//  TGTInfoSDK
//
//  Created by weiyuxiang on 2017/10/12.
//  Copyright (c) 2015年 TGT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^InfoBlock)(id tgtInfo);
typedef void (^ErrorBlock)(id error);

@interface TGTInfoSDK : NSObject

/**
 *  此方法用于获取途鸽设备信息
 *  ssid         当前连接途鸽设备的SSID
 *  tgtInfo      用于回调途鸽设备信息，id类型返回
 */
- (void )initTGTWiFiWithSSID:(NSString *)ssid returnTGTInfo:(InfoBlock)tgtInfo error:(ErrorBlock)errorInfo;

/**
 *  此方法用于获取途鸽设备流量使用
 *  ssid         当前连接途鸽设备的SSID
 *  tgtInfo      用于回调途鸽设备流量使用情况，id类型返回
 */
- (void )initTGTWiFiWithSSID:(NSString *)ssid returnTGTFlow:(InfoBlock)tgtFlow error:(ErrorBlock)errorFlow;

/**
 *  此方法可获取当前连接的WiFi SSID
 */
- (NSString *)getWiFiSSID;

@end
