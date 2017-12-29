//
//  BLEToolsbar.m
//  51tgtwifi
//
//  Created by DEVCOM on 2017/12/21.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "BLEToolsbar.h"
#import "NSStringTool.h"

@implementation BLEToolsbar

+(NSData *)changePasswordbySSID:(NSString *)ssidStr andPwd:(NSString *)pwdStr{
    NSDictionary *KEY = [NSDictionary dictionaryWithObject:@"CMD_SET_WIFIANDPASSWORD" forKey:@"key"];
    NSDictionary *SSID = [NSDictionary dictionaryWithObject:ssidStr forKey:@"SSID"];
    NSDictionary *PSW = [NSDictionary dictionaryWithObject:pwdStr forKey:@"PWD"];
    NSArray *arr2 = @[SSID,PSW];
    NSDictionary *VALUE = [NSDictionary dictionaryWithObject:arr2 forKey:@"value"];
    NSArray *arr = @[KEY,VALUE];
    NSString *str = [NSStringTool arrayToJSONString:arr];
    
    str = [str stringByReplacingOccurrencesOfString:@"[" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"},{" withString:@","];
    
    /***/
    //NSString *str = @"CMD_GET_DEVICE_INFO";
    NSLog(@"===%@===",str);
    str = [str stringByAppendingString:END_FLAG];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    return data;
}

+(NSData*)setApnby:(NSString*)apnStr mcc:(NSString*)mccStr mmsc:(NSString*)mmscStr mmsport:(NSString*)mmsportStr mmsproxy:(NSString*)mmsproxyStr mnc:(NSString*)mncStr name:(NSString*)nameStr numeric:(NSString*)numericStr password:(NSString*)passwordStr port:(NSString *)portStr proxy:(NSString*)proxyStr server:(NSString*)serverStr type:(NSString*)typeStr user:(NSString*)userStr{
    NSDictionary *KEY = [NSDictionary dictionaryWithObject:@"CMD_SET_APN" forKey:@"key"];
    NSDictionary *apn = [NSDictionary dictionaryWithObject:apnStr forKey:@"apn"];
    NSDictionary *mcc = [NSDictionary dictionaryWithObject:mccStr forKey:@"mcc"];
    NSDictionary *mmsc = [NSDictionary dictionaryWithObject:mmscStr forKey:@"mmsc"];
    NSDictionary *mmsport = [NSDictionary dictionaryWithObject:mmsportStr forKey:@"mmsport"];
    NSDictionary *mmsproxy = [NSDictionary dictionaryWithObject:mmsproxyStr forKey:@"mmsproxy"];
    NSDictionary *mnc = [NSDictionary dictionaryWithObject: mncStr forKey:@"mnc"];
    NSDictionary *name = [NSDictionary dictionaryWithObject:nameStr forKey:@"name"];
    NSDictionary *numeric = [NSDictionary dictionaryWithObject:numericStr forKey:@"numeric"];
    NSDictionary *password = [NSDictionary dictionaryWithObject:passwordStr forKey:@"password"];
    NSDictionary *port = [NSDictionary dictionaryWithObject:portStr forKey:@"port"];
    NSDictionary *proxy = [NSDictionary dictionaryWithObject:proxyStr forKey:@"proxy"];
    NSDictionary *server = [NSDictionary dictionaryWithObject:serverStr forKey:@"server"];
    NSDictionary *type = [NSDictionary dictionaryWithObject:typeStr forKey:@"type"];
    NSDictionary *user = [NSDictionary dictionaryWithObject:userStr forKey:@"user"];
    NSArray *arrValue = @[apn,mcc,mmsc,mmsport,mmsproxy,mnc,name,numeric,password,port,proxy,server,type,user];
    NSDictionary *VALUE = [NSDictionary dictionaryWithObject:arrValue forKey:@"value"];
    NSArray *arrALL = @[KEY,VALUE];
    NSString *str = [NSStringTool arrayToJSONString:arrALL];
    NSLog(@"===%@===",str);
    /**因为服务端解析的json不接收数组类型，所以得去掉~~**/
    str = [str stringByReplacingOccurrencesOfString:@"[" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"},{" withString:@","];
    NSLog(@"===%@===",str);
    str = [str stringByAppendingString:END_FLAG];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];

    return data;
}


+(NSData *)setheimingdan:(NSString *)blackStr {
    NSDictionary *KEY = [NSDictionary dictionaryWithObject:@"CMD_SET_BLACK_LIST" forKey:@"key"];
//    NSDictionary *SSID = [NSDictionary dictionaryWithObject:ssidStr forKey:@"SSID"];
//    NSDictionary *PSW = [NSDictionary dictionaryWithObject:pwdStr forKey:@"PWD"];
//    NSArray *arr2 = @[SSID,PSW];
    NSDictionary *VALUE = [NSDictionary dictionaryWithObject:blackStr forKey:@"value"];
    NSArray *arr = @[KEY,VALUE];
    NSString *str = [NSStringTool arrayToJSONString:arr];
    
    str = [str stringByReplacingOccurrencesOfString:@"[" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"},{" withString:@","];
    
    /***/
    //NSString *str = @"CMD_GET_DEVICE_INFO";
    NSLog(@"===%@===",str);
    str = [str stringByAppendingString:END_FLAG];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    return data;
}

+(NSData *)ConnectWifibySSID:(NSString *)ssidStr andPwd:(NSString *)pwdStr{
    NSDictionary *KEY = [NSDictionary dictionaryWithObject:@"CMD_BT_CONNECT_TO_AP" forKey:@"key"];
    NSDictionary *SSID = [NSDictionary dictionaryWithObject:ssidStr forKey:@"ssid"];
    NSDictionary *PSW = [NSDictionary dictionaryWithObject:pwdStr forKey:@"pwd"];
    NSArray *arr2 = @[SSID,PSW];
    NSDictionary *VALUE = [NSDictionary dictionaryWithObject:arr2 forKey:@"value"];
    NSArray *arr = @[KEY,VALUE];
    NSString *str = [NSStringTool arrayToJSONString:arr];
    
    str = [str stringByReplacingOccurrencesOfString:@"[" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"},{" withString:@","];
    
    /***/
    //NSString *str = @"CMD_GET_DEVICE_INFO";
    NSLog(@"===%@===",str);
    str = [str stringByAppendingString:END_FLAG];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    return data;
}

+(NSData *)DisConnectWifibySSID:(NSString *)ssidStr andPwd:(NSString *)pwdStr{
    NSDictionary *KEY = [NSDictionary dictionaryWithObject:@"CMD_BT_DISCONNECT_AP" forKey:@"key"];
    NSDictionary *SSID = [NSDictionary dictionaryWithObject:ssidStr forKey:@"ssid"];
    NSDictionary *PSW = [NSDictionary dictionaryWithObject:pwdStr forKey:@"pwd"];
    NSArray *arr2 = @[SSID,PSW];
    NSDictionary *VALUE = [NSDictionary dictionaryWithObject:arr2 forKey:@"value"];
    NSArray *arr = @[KEY,VALUE];
    NSString *str = [NSStringTool arrayToJSONString:arr];
    
    str = [str stringByReplacingOccurrencesOfString:@"[" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"},{" withString:@","];
    
    /***/
    //NSString *str = @"CMD_GET_DEVICE_INFO";
    NSLog(@"===%@===",str);
    str = [str stringByAppendingString:END_FLAG];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    return data;
}

@end
