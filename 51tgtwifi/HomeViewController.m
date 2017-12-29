//
//  HomeViewController.m
//  51tgtwifi
//
//  Created by weiyuxiang on 2017/10/12.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "HomeViewController.h"
#import "TGTInfoSDK.h"
#import <SystemConfiguration/CaptiveNetwork.h>




//检测wifi需要的文件
#import <ifaddrs.h>
#import <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>

//间隔根据屏幕大小判断
#define Hmargin  [UIScreen mainScreen].bounds.size.width==375?3:14


@interface HomeViewController ()<UIScrollViewDelegate>

{
//wifi弹窗
    UIView *wifiView;
    
//首页轮播图
    UIScrollView  *_topSrc;
    
//设备信息背景板
    
    UIView      *_deviceBack;
    
//设备数据信息
    UILabel     *_ssid;
    UILabel     *_signalLabel;
    UILabel     *_powerLabel;
    UILabel     *_personLabel;
    UILabel     *_appVersion;
    UILabel     *_SimCounTry;
    UILabel     *_passWord;
    
    
    
//数据的名称

    UILabel     *_signalLabel2;
    UILabel     *_powerLabel2;
    UILabel     *_personLabel2;
    UILabel     *_appVersion2;
    UILabel     *_SimCounTry2;
    UILabel     *_passWord2;
    
    
    NSInteger   _textFont;
    
//    尝试连接次数
    NSInteger   _connetNum;

    
    
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textFont = 14;
    _connetNum = 0;
    
    
    
    
//    背景图片
    UIImageView *backgroud = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, XScreenWidth,XScreenHeight)];
    
    backgroud.image = [UIImage imageNamed:@"2.jpg"];
    
    [self.view addSubview:backgroud];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self createsrcoView];
    


//    初始化设备数据的视图
    [self createDeviceLabel];
    
//   子线程加载数据
    [self loadInfo];
    
    
//    dispatch_queue_t nimei = dispatch_queue_create("lalal", DISPATCH_QUEUE_CONCURRENT);
//    
//        
//    
//    
//    dispatch_async( nimei, ^{
//     
//        
//         dispatch_sync(dispatch_get_main_queue(), ^{
//             
//             
//         });
//        
//    });
    
    [self createFlow];
    
//    wifi检测提示
    [self isWifi];
    
//    从后台返回的通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuaxin) name:@"shuaxin" object:nil];
}

#pragma mark - 从后台跳转回来重新加载必要数据
-(void)shuaxin{
    [self loadInfo];
    [self isWifi];
}

#pragma mark - 检测是否连接wifi
- (BOOL) isWiFiEnabled {
    NSCountedSet * cset = [NSCountedSet new];
    struct ifaddrs *interfaces;
    if( ! getifaddrs(&interfaces) ) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next)
        {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
}

-(void)isWifi{
    if ([self isWiFiEnabled]) {
        NSLog(@"wifi已连接");
    }else
    {
        NSLog(@"wifi未连接");
        wifiView = [UIView new];
        [self.view addSubview:wifiView];
        
        [wifiView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(300, 200));
        }];
        
        wifiView.backgroundColor  = [UIColor grayColor];
        
        UILabel *tip = [UILabel new];
        [wifiView addSubview:tip];
        
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wifiView).with.offset(10);
            make.left.equalTo(wifiView).with.offset(10);
            make.right.equalTo(wifiView).with.offset(-10);
            make.bottom.equalTo(wifiView).with.offset(-100);
        }];
        
        tip.text = @"当前没有Wifi连接,是否接入途鸽Wifi？";
        tip.textColor = [UIColor blackColor];
        tip.numberOfLines = 0;
        
        
        UIButton *btn = [UIButton new];
        [wifiView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(tip.mas_bottom).with.offset(10);
            make.left.equalTo(wifiView).with.offset(10);
            make.width.mas_equalTo(@50);
            make.height.mas_equalTo(@50);
        }];
        
        btn.tag = 1001;
        [btn setTitle:@"是" forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(openWifi:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *btn2 = [UIButton new];
        [wifiView addSubview:btn2];
        
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(tip.mas_bottom).with.offset(10);
            make.right.equalTo(wifiView).with.offset(-10);
            make.width.mas_equalTo(@50);
            make.height.mas_equalTo(@50);
        }];
        
        btn2.tag = 1002;
        [btn2 setTitle:@"否" forState:UIControlStateNormal];
        
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn2 addTarget:self action:@selector(openWifi:) forControlEvents:UIControlEventTouchUpInside];
    }

}

#pragma mark - 点击时间（跳转到手机wifi设置界面）
-(void)openWifi:(UIButton *)btn{
    if (btn.tag==1001) {
        NSString *urlStr = @"App-Prefs:root=WIFI";
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]]) {
//            判断iOS版本 
            if ([[UIDevice currentDevice].systemVersion doubleValue] >=10.0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlStr] options:@{} completionHandler:nil];
            }
            else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            }
        }
        
        [wifiView removeFromSuperview];

    }
    else if (btn.tag==1002){
        [wifiView removeFromSuperview];
    }
   
}

#pragma mark - 头部轮播图
-(void)createsrcoView{
    _topSrc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, XScreenWidth, 150)];
    
    _topSrc.contentSize = CGSizeMake(XScreenWidth*2, 0) ;
    
        _topSrc.alwaysBounceVertical = NO;
    
        _topSrc.alwaysBounceHorizontal = NO;
    
        _topSrc.showsVerticalScrollIndicator = NO;
    
        _topSrc.showsHorizontalScrollIndicator = NO;
    
    _topSrc.delegate = self;
    
    for (int i=0; i<2; i++) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(XScreenWidth*i, 0, XScreenWidth, 150)];
        
        img.image = [UIImage imageNamed:@"1.jpg"];
        
        
        
        [_topSrc addSubview:img];
    }
    
    [self.view addSubview:_topSrc];

}



#pragma mark -初始化设备数据的视图
-(void)createDeviceLabel{
//    _deviceBack = [[UIView alloc]initWithFrame:CGRectMake(50, _topSrc.maxY+30, 300, 400)];
    
    _deviceBack = [UIView new];
    
    [self.view addSubview:_deviceBack];
    
    [_deviceBack mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_topSrc.mas_bottom).with.offset(30);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.bottom.equalTo(self.view).with.offset(-250);
    }];
    
    
    _deviceBack.layer.cornerRadius = 10;
    
    _deviceBack.backgroundColor = [UIColor whiteColor];
    
    
    
    //    设备号（wifi名）--
    //    UILabel *ssid = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 200)];
    
    UILabel *ssid2 = [UILabel new];
    [_deviceBack addSubview:ssid2];
    
    ssid2.text =SetLange(@"shebeissid");
    
    [ssid2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_deviceBack).with.offset(10);
        make.right.equalTo(_deviceBack).with.offset(-10);
        make.top.equalTo(_deviceBack).with.offset(10);
        make.height.mas_equalTo(@25);
        
        
    }];
    
    ssid2.numberOfLines = 0;
    ssid2.font = [UIFont systemFontOfSize:_textFont];
    
//    ssid2.textColor = [UIColor grayColor];

    

    
    
    //    密码--
//    _signalLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 200, 200)];
    
    _passWord2 = [UILabel new];
    
     [_deviceBack addSubview:_passWord2];
    
    [_passWord2 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(ssid2.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_deviceBack).with.offset(-10);
        make.left.equalTo(_deviceBack).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    
//    _passWord2.text = @"Wifi密码:";
    _passWord2.text  = SetLange(@"Wifimima");
    _passWord2.numberOfLines = 0;
    _passWord2.font = [UIFont systemFontOfSize:_textFont];
//    _passWord2.textColor = [UIColor grayColor];
    
   
    
    //    翻译语种--
    
    _SimCounTry2 = [UILabel new];
    [_deviceBack addSubview:_SimCounTry2];
                   
    [_SimCounTry2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_passWord2.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_deviceBack).with.offset(-10);
        make.left.equalTo(_deviceBack).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];

//    _SimCounTry2.text = @"翻译语种:";
     _SimCounTry2.text = SetLange(@"fanyiyuzhong");
//    _SimCounTry2.textColor = [UIColor grayColor];
    _SimCounTry2.font = [UIFont systemFontOfSize:_textFont];
   
    
    //    电量--
    
    _powerLabel2 = [UILabel new];
    [_deviceBack addSubview:_powerLabel2];
    
    [_powerLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_SimCounTry2.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_deviceBack).with.offset(-10);
        make.left.equalTo(_deviceBack).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    
    
//    _powerLabel2.text = @"剩余电量:";
    _powerLabel2.text = SetLange(@"shengyudianliang");
//    _powerLabel2.textColor = [UIColor grayColor];
    _powerLabel2.font = [UIFont systemFontOfSize:_textFont];
    
    
    
    //    连接数--
    _personLabel2 = [UILabel new];
    [_deviceBack addSubview:_personLabel2];
    
    if ([((NSArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"]).firstObject isEqualToString:@"en"]) {
        [_personLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_powerLabel2.mas_bottom).with.offset(Hmargin);
            //        make.right.equalTo(_deviceBack).with.offset(-10);
            make.left.equalTo(_deviceBack).with.offset(10);
            make.height.mas_equalTo(@35);
            make.width.mas_equalTo(@130);
            
        }];
    }
    else{
    [_personLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_powerLabel2.mas_bottom).with.offset(Hmargin);
//        make.right.equalTo(_deviceBack).with.offset(-10);
        make.left.equalTo(_deviceBack).with.offset(10);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@130);
        
    }];
    }
    
//    _personLabel2.text = @"设备连接数:";
    _personLabel2.text = SetLange(@"shebeilianjieshu");
//    _personLabel2.textColor = [UIColor grayColor];
    _personLabel2.font = [UIFont systemFontOfSize:_textFont];
    _personLabel2.numberOfLines = 0;
    
    
    
    //    信号--
    
    _signalLabel2 = [UILabel new];
    [_deviceBack addSubview:_signalLabel2];
    
    
    [_signalLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_personLabel2.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_deviceBack).with.offset(-10);
        make.left.equalTo(_deviceBack).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    
//    _signalLabel2.text = @"信号强度:";
      _signalLabel2.text = SetLange(@"xinhaoqiangdu");
//    _signalLabel2.textColor = [UIColor grayColor];
    _signalLabel2.font = [UIFont systemFontOfSize:_textFont];
    
    
    
//    版本信息--
    _appVersion2 = [UILabel new];
    [_deviceBack addSubview:_appVersion2];
    
    
    [_appVersion2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_signalLabel2.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_deviceBack).with.offset(-10);
        make.left.equalTo(_deviceBack).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    
//    _appVersion2.text = @"设备版本:";
      _appVersion2.text = SetLange(@"shebeibanben");
//    _appVersion2.textColor = [UIColor grayColor];
    _appVersion2.font = [UIFont systemFontOfSize:_textFont];

    
    
//设备号
    _ssid = [UILabel new];
    [_deviceBack addSubview:_ssid];
    _ssid.numberOfLines = 0;
    _ssid.text =[NSString stringWithFormat:@"%@",[self getWiFiSSID]];
    
    [_ssid mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.left.equalTo(_deviceBack).with.offset(10);
        make.right.equalTo(_deviceBack).with.offset(-5);
        make.top.equalTo(_deviceBack).with.offset(10);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@180);
        
        
    }];
    
    [_ssid  sizeToFit];
 
    _ssid.font = [UIFont systemFontOfSize:_textFont];
    
    _ssid.textColor = [UIColor grayColor];
    
    
//    密码
    _passWord = [UILabel new];
    
    [_deviceBack addSubview:_passWord];
//    _passWord.text = @"a4234254353";
    [_passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_ssid.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_deviceBack).with.offset(-5);
//        make.left.equalTo(_deviceBack).with.offset(10);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@160);
        
    }];
    
    _passWord.numberOfLines = 0;
    _passWord.font = [UIFont systemFontOfSize:_textFont];
    _passWord.textColor = [UIColor grayColor];
    
//    翻译语种
    _SimCounTry = [UILabel new];
    [_deviceBack addSubview:_SimCounTry];
    
    [_SimCounTry mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_passWord.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_deviceBack).with.offset(-5);
//        make.left.equalTo(_deviceBack).with.offset(10);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@160);
        
    }];
    
    
    _SimCounTry.textColor = [UIColor grayColor];
    _SimCounTry.font = [UIFont systemFontOfSize:_textFont];
    
    
    
//    电量
    _powerLabel = [UILabel new];
    [_deviceBack addSubview:_powerLabel];
    
    [_powerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_SimCounTry.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_deviceBack).with.offset(-5);
//        make.left.equalTo(_deviceBack).with.offset(10);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@160);
        
    }];
    _powerLabel.textColor = [UIColor grayColor];
    _powerLabel.font = [UIFont systemFontOfSize:_textFont];
    
    
    
//    连接数
    _personLabel = [UILabel new];
    [_deviceBack addSubview:_personLabel];
    
    [_personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_powerLabel.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_deviceBack).with.offset(-5);
//        make.left.equalTo(_deviceBack).with.offset(10);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@160);
        
    }];
    
    _personLabel.textColor = [UIColor grayColor];
    _personLabel.font = [UIFont systemFontOfSize:_textFont];
    
    
//    信号
    _signalLabel = [UILabel new];
    [_deviceBack addSubview:_signalLabel];
    
    
    [_signalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_personLabel.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_deviceBack).with.offset(-5);
//        make.left.equalTo(_deviceBack).with.offset(10);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@160);
        
    }];
    
    _signalLabel.textColor = [UIColor grayColor];
    _signalLabel.font = [UIFont systemFontOfSize:_textFont];
    
    
//    版本
    _appVersion = [UILabel new];
    [_deviceBack addSubview:_appVersion];
    
    
    [_appVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_signalLabel.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_deviceBack).with.offset(-5);
//        make.left.equalTo(_deviceBack).with.offset(10);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@160);
        
    }];
    
    _appVersion.textColor = [UIColor grayColor];
    _appVersion.font = [UIFont systemFontOfSize:_textFont];




}




-(NSString *)getWiFiSSID{
    
    NSString *wifiSSID;
    
    CFArrayRef array = CNCopySupportedInterfaces();
    
    if (array!=nil) {
        CFDictionaryRef dic = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(array, 0));
        
        if (dic !=nil) {
            NSDictionary *myDic = (NSDictionary *)CFBridgingRelease(dic);
            wifiSSID = [myDic valueForKey:@"SSID"];
        }
    }
    
    
    
    return wifiSSID;
}

#pragma mark -加载设备数据

-(void)loadInfo{
    TGTInfoSDK *tgtInfo = [[TGTInfoSDK alloc]init];
    
    //    获取当前设备
    NSString *ssid = [tgtInfo getWiFiSSID];
    
    _ssid.text = [NSString stringWithFormat:@"%@",ssid];
    [tgtInfo initTGTWiFiWithSSID:ssid returnTGTFlow:^(id tgtInfo) {
        NSLog(@"信息======%@",tgtInfo);
        
        
        
        
        NSDictionary *infoDic = (NSDictionary *)tgtInfo;
        self.infoList = infoDic;
        
        NSString *iccid1 = [NSString stringWithFormat:@"%@",infoDic[@"iccid1"]];
        NSString *iccid0 = [NSString stringWithFormat:@"%@",infoDic[@"iccid0"]];
        
        
        if (([iccid1 isEqualToString:@""]||[iccid1 isEqualToString:@"(null)"]||[iccid1 isEqualToString:@"<null>"])&&([iccid0 isEqualToString:@""]||[iccid0 isEqualToString:@"(null)"]||[iccid0 isEqualToString:@"<null>"])) {
            _signalLabel.text = @"无";
        }else {
            NSString *currSim = [NSString stringWithFormat:@"%@",infoDic[@"CurrSim"]];
            //            CurrSim==1
            if ([currSim isEqualToString:@"1"]) {
                NSString *signal = [NSString stringWithFormat:@"%@",infoDic[@"Signal1"]];
                if ([signal isEqualToString:@""]||[signal isEqualToString:@"(null)"]||[signal isEqualToString:@"<null>"]) {
                    signal = @"无";
                    _signalLabel.text = signal;
                    
                }else{
                    if ([signal integerValue]<=-103) {
                        _signalLabel.text = @"信号强度 : 弱";
                        //                        _signalLabel.text = signal;
                        _signalLabel.text = [NSString stringWithFormat:@"%@",signal];
                        
                    }else if ([signal integerValue] > -103 && [signal integerValue] <=-89){
                        _signalLabel.text = @"信号强度 : 中";
                        //                        _signalLabel.text = signal;
                        _signalLabel.text = [NSString stringWithFormat:@"%@",signal];
                        
                    }else if ([signal integerValue] >-89){
                        _signalLabel.text = @"信号强度 : 强";
                        //                        _signalLabel.text = signal;
                        _signalLabel.text = [NSString stringWithFormat:@"%@",signal];
                        
                    }
                    
                }
            }else if ([currSim isEqualToString:@"unknow"]){
                _signalLabel.text = @"无";
                
                
            }
            else{
                
                NSString *signal = [NSString stringWithFormat:@"%@",infoDic[@"Signal2"]];
                if ([signal isEqualToString:@""]||[signal isEqualToString:@"(null)"]||[signal isEqualToString:@"<null>"]) {
                    signal = @"无";
                    _signalLabel.text = signal;
                    
                }else{
                    if ([signal integerValue]<=-103) {
                        _signalLabel.text = @"信号强度 : 弱";
                        _signalLabel.text = [NSString stringWithFormat:@"%@",signal];
                        //                        _signalLabel.text = signal;
                        
                    }else if ([signal integerValue] > -103 && [signal integerValue] <=-89){
                        _signalLabel.text = @"信号强度 : 中";
                        _signalLabel.text = [NSString stringWithFormat:@"%@",signal];
                        
                    }else if ([signal integerValue] >-89){
                        _signalLabel.text = @"信号强度 : 强";
                        _signalLabel.text = [NSString stringWithFormat:@" %@",signal];
                        
                    }
                    
                }
                
                
            }
            
        }
        
        
        //        更新电量
        NSString *power = [NSString stringWithFormat:@"%@",infoDic[@"Power"]];
        if ([power isEqualToString:@""]||[power isEqualToString:@"(null)"]|| [power isEqualToString:@"<null>"]) {
            power = @"未知";
            _powerLabel.text = power;
            
        }else{
            _powerLabel.text = [NSString stringWithFormat:@"%@",power];
            double length = [[power componentsSeparatedByString:@"%"].firstObject doubleValue];
            
            
        }
        
        NSString *currConnections = [NSString stringWithFormat:@"%@",infoDic[@"CurrConnections"]];
        _personLabel.text = [NSString stringWithFormat:@"%@",currConnections];
        
        NSString *appVersion = [NSString stringWithFormat:@"%@",infoDic[@"AppVersion"]];
        _appVersion.text = [NSString stringWithFormat:@"%@",appVersion];
        
        
        NSString *simC0 = [NSString stringWithFormat:@"%@",infoDic[@"SimCountryIso0"]];
        
        simC0 = [simC0 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        simC0 = [simC0 substringToIndex:1];
        
        NSString *simC1 = [NSString stringWithFormat:@"%@",infoDic[@"SimCountryIso1"]];
        
        simC1 = [simC1 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        simC1 = [simC1 substringToIndex:1];
        
        NSLog(@"第二次获取信息======%@",infoDic[@"password"]);
//        for (NSString *s in [infoDic allValues]) {
//            NSLog(@"key: %@", s);
//        }
        
        _SimCounTry.text = [NSString stringWithFormat:@""];
        if (infoDic[@"password"]) {
            _passWord.text= [NSString stringWithFormat:@"%@",infoDic[@"password"]];
        }else{
            _passWord.text = @"获取WIfi密码失败";
        }
        
        
    } error:^(id error) {
        NSLog(@"错误======重新加载");
        if (_connetNum==20) {
            _connetNum=0;
        }else{
            [self loadInfo];
        
            _connetNum = _connetNum+1;;
        }
    }];
    
    
    
}

#pragma mark -流量购买部分
-(void)createFlow{
    UIView *_flowView = [UIView new];
    [self.view addSubview:_flowView];
    
    [_flowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.top.equalTo(_deviceBack.mas_bottom).with.offset(10);
        make.bottom.equalTo(self.view).with.offset(-110);
    }];
    
    _flowView.layer.cornerRadius = 10;
    _flowView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *_flow = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 30)];
    _flow.text = @"流量信息";
    [_flowView addSubview:_flow];
    
    
    UIButton *_buyFlow = [UIButton new];
    [_flowView addSubview:_buyFlow];
    
    [_buyFlow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_flowView).with.offset(10);
        make.right.equalTo(_flowView).with.offset(-10);
        make.bottom.equalTo(_flowView).with.offset(-10);
        make.height.mas_equalTo(@50);
    }];
    
    _buyFlow.backgroundColor = [UIColor grayColor];
    _buyFlow.layer.cornerRadius = 5;
   
    [_buyFlow setTitle:@"购买流量" forState:UIControlStateNormal];
    
    [_buyFlow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
