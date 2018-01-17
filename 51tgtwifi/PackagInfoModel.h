//
//  PackagInfoModel.h
//  51tgtwifi
//
//  Created by DEVCOM on 2017/12/22.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackagInfoModel : NSObject

/**************翻译套餐信息****************/
@property(nonatomic,strong)NSNumber *totalFlow;//总流量
@property(nonatomic,strong)NSString *surplusFlow;//剩余流量
@property(nonatomic,strong)NSString *countryName;//使用国家
@property(nonatomic,strong)NSString *startTime;//开始时间
@property(nonatomic,strong)NSString *endTime;//结束时间
@property(nonatomic,strong)NSNumber *product_type;//翻译套餐为104
@property(nonatomic,strong)NSNumber *flow_status;//2是表示该套餐正在使用

/**************设备信息****************/
@property(nonatomic,strong)NSString *ssid;//设备ssid
@property(nonatomic,strong)NSString *password;//密码
@property(nonatomic,strong)NSString *Power;//剩余电量
@property(nonatomic,strong)NSString *CurrConnections;//wifi连接数
@property(nonatomic,strong)NSString *Signal2;//信号强度
@property(nonatomic,strong)NSString *AppVersion;//设备版本

/**************上网套餐信息****************/
@property(nonatomic,strong)NSString *product_name;//产品名称
@property(nonatomic,strong)NSString *flow_count;//总流量
@property(nonatomic,strong)NSString *left_flow_count;//剩余流量
@property(nonatomic,strong)NSString *effective_countries;//使用国家
@property(nonatomic,strong)NSString *start_time;//开始时间
@property(nonatomic,strong)NSString *end_time;//结束时间

/**************设备信息****************/
//Apn1 = "Apn [nameu003d, apnu003d, mccu003d, mncu003d, numericu003d]";
//Apn2 = "name:CT,mcc:460,mnc:11,apn:ctlte,type:default,dun,supl";
//AppM1Version = "1.0.1220";
//AppToVersion = "T4_V2.1.15";
//AppVersion = "T4_V2.1.15";
//CurrConnections = 0;
//CurrSim = 2;
//DataState0 = 2;
//DataState1 = 2;
//IPAddress = "10.20.27.225";
//NetworkTypeName0 = HSPA;
//NetworkTypeName1 = LTE;
//Power = "100%";
//Signal1 = "-91";
//Signal2 = "-77";
//SimCountryIso0 = "\U4e2d\U56fd";
//SimCountryIso1 = "\U4e2d\U56fd";
//SimState0 = 5;
//SimState1 = 5;
//SpeedLoad = "";
//SpeedUp = "";
//ToVersion = "";
//Version = "userdebug W17.49.1N01";
//VersionM1 = "";
//bluetoothMac = "40:45:DA:51:94:55";
//cellLocationGemini0 = "[30543,-1,-1]";
//cellLocationGemini1 = "[30543,-1,-1]";
//countryCode = "";
//countryName = "";
//currentTimeDevice = 1513907262805;
//cycleUsedTraffic = "";
//dayFlow = "";
//dayUseMaxValue = 500;
//dayUsedTraffic = "0.0";
//deviceType = 0;
//endTime = 1522339200;
//getFallInfoDate = "";
//grandFlow = "28.2";
//iccid0 = 89314404000416273093;
//iccid1 = 89860460021004101439;
//imei0 = 864675030124790;
//imei1 = 864675030124808;
//imsi0 = 204046861709303;
//imsi1 = 460111118103199;
//lastUpdateTime = "";
//leaveSzie1 = "";
//leaveSzie2 = "";
//monUsedTraffic = "";
//msisdn0 = "";
//msisdn1 = "";
//packType = "";
//packageLevel = S14;
//packageName = "Global(day pass)";
//packageType = "";
//password = 8ea98033;
//plmn = 46011;
//rankNumber = "";
//roamingState = 0;
//security = "WPA2_PSK";
//ssid = "*TUGE24170833239 \U767e\U5ea6\U7ffb\U8bd1\U673a";
//startTime = 1511971200;
//surplusFlow = 99999999;
//tCountryNumber = "";
//tEndTime = 1522339200;
//tStartTime = 1511971200;
//tcInfo = "Global(day pass)";
//threeHoursFlow = "";
//totalFlow = 99999999;
//totalTraffic = "";


/**************套餐信息****************/
//countryCode = "";
//countryName = "";
//dayFlow = "0.0";
//dayUseMaxValue = 500;
//endTime = 1522339200;
//grandFlow = "28.2";
//lastUpdateTime = "";
//packageLevel = S14;
//packageName = "Global(day pass)";
//packageType = "";
//startTime = 1511971200;
//surplusFlow = 99999999;
//threeHoursFlow = "0.0";
//totalFlow = 99999999;

@end
