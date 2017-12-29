//
//  BLEToolsbar.h
//  51tgtwifi
//
//  Created by DEVCOM on 2017/12/21.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEToolsbar : NSObject

//修改密码
+(NSData *)changePasswordbySSID:(NSString *)ssidStr andPwd:(NSString *)pwdStr;

//设置apn
+(NSData*)setApnby:(NSString*)apnStr mcc:(NSString*)mccStr mmsc:(NSString*)mmscStr mmsport:(NSString*)mmsportStr mmsproxy:(NSString*)mmsproxyStr mnc:(NSString*)mncStr name:(NSString*)nameStr numeric:(NSString*)numericStr password:(NSString*)passwordStr port:(NSString *)portStr proxy:(NSString*)proxyStr server:(NSString*)serverStr type:(NSString*)typeStr user:(NSString*)userStr;
//设置黑名单
+(NSData *)setheimingdan:(NSString *)blackStr;
//设置wifi连接
+(NSData *)ConnectWifibySSID:(NSString *)ssidStr andPwd:(NSString *)pwdStr;
+(NSData *)DisConnectWifibySSID:(NSString *)ssidStr andPwd:(NSString *)pwdStr;
@end
