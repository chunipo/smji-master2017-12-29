//
//  HomeVc.m
//  51tgtwifi
//
//  Created by DEVCOM on 2017/12/20.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "HomeVc.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "NSStringTool.h"
#import "BLEToolsbar.h"
#import "PackagInfoModel.h"
#import "NetWork.h"
#import "YXManager.h"
#import "QRScanViewController.h"
#import "LFRoundProgressView.h"
#define Name_Device 17
#define Device_Info 15
#define Hmargin  16

#define Global_url @"http://as2.51tgt.com/wxapp/GetDeviceInfoByQrCode?device_no=TGT24170833260"

@interface HomeVc ()<UIScrollViewDelegate,CBCentralManagerDelegate,CBPeripheralDelegate>
{
    MBProgressHUD     *hud;
    YXManager    *_manager;
    UIScrollView *_scrollView;
    UIView            *_view;//第一张背景
    UIView            *_view2;//第二张
    NSString          *_total;
    //第一次进入获取的基础信息
    BOOL              _isWrite;
    NSString          *_GetInfo;//指令
    //第一次进入获取的设备信息
    BOOL              _isGet;//获取第二次的数据，也就是设备信息
    PackagInfoModel   *_deviceInfo;
    
    
    
    //设备信息
    UILabel           *_ssid;
    UILabel           *_pwd;
    UILabel           *_power;
    UILabel           *_connectNum;
    UIImageView       *_singel;
    UILabel           *_appVersion;
    
    //翻译订单信息
    UILabel           *OrderLab;
    
    //上网订单信息
    UILabel           *flowInfo;
    
    //修改密码的信息
    NSString          *_changePwd;
    //黑名单
     NSString          *_blackStr;
    //apn
    NSDictionary      *_dictApn;
    //连接附近热点
    BOOL              _isGETwifi;
    //装数据
    NSMutableData     *_dataBlue;
    
    //读取数据，进一次就够了
    BOOL              _isRequest;
    //最底部在进度条时显示的透明遮挡tabbarview
    int               _timeNum;
    
}

/* 中心管理者 */
@property (nonatomic, strong) CBCentralManager *cMgr;

/* 连接到的外设 */
@property (nonatomic, strong) CBPeripheral *peripheral;
/* 存储扫描到的外设 */
@property (nonatomic, strong) NSMutableArray *peripheralArr;

//进度条
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) LFRoundProgressView *largeProgressView;
@property (strong, nonatomic) UILabel *progressLabel;

//懒加载
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation HomeVc
/*****************************************************************************/
//1.建立一个Central Manager实例进行蓝牙管理

-(CBCentralManager *)cMgr
{
    if (!_cMgr) {
        _cMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _cMgr;
}

//只要中心管理者初始化 就会触发此代理方法 判断手机蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case 0:
            NSLog(@"CBCentralManagerStateUnknown");
            _manager.isOpenBluetooth = NO;
            break;
        case 1:
            NSLog(@"CBCentralManagerStateResetting");
            _manager.isOpenBluetooth = NO;
            break;
        case 2:
            NSLog(@"CBCentralManagerStateUnsupported");//不支持蓝牙
            _manager.isOpenBluetooth = NO;
            break;
        case 3:
            NSLog(@"CBCentralManagerStateUnauthorized");
            _manager.isOpenBluetooth = NO;
            break;
        case 4:
        {
            NSLog(@"蓝牙未开启CBCentralManagerStatePoweredOff");//蓝牙未开启
            _manager.isOpenBluetooth = NO;
        }
            break;
        case 5:
        {
            NSLog(@"蓝牙已开启CBCentralManagerStatePoweredOn");//蓝牙已开启
            
                _manager.isOpenBluetooth = YES;
                [self.cMgr scanForPeripheralsWithServices:nil // 通过某些服务筛选外设
                                                  options:nil]; // dict,条件
            

        }
            break;
        default:
            break;
    }
}
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    NSLog(@"====%@===",dict);
    
}

- (void)centralManager:(CBCentralManager *)central // 中心管理者
 didDiscoverPeripheral:(CBPeripheral *)peripheral // 外设
     advertisementData:(NSDictionary *)advertisementData // 外设携带的数据
                  RSSI:(NSNumber *)RSSI // 外设发出的蓝牙信号强度
{
    
    NSLog(@"peripheral####%@。advertisementData###%@  cmgr===%@",peripheral,advertisementData,self.cMgr);
    if (![self.peripheralArr containsObject:peripheral] ) {
         [self.peripheralArr addObject:peripheral];
    }

    if (_manager.ScanID) {
        for (CBPeripheral *per in self.peripheralArr) {
            NSLog(@"设备名字===%@",per.name);
            if ([_manager.ScanID isEqualToString:per.name]) {
                self.peripheral = per;
                _manager.peripheral = per;
                // 发现完之后就是进行连接
                [self.cMgr connectPeripheral:self.peripheral options:nil];
            }
        }
        
    }
   
}


/*如果连接成功，就会回调下面的协议方法了*/
- (void)centralManager:(CBCentralManager *)central // 中心管理者
  didConnectPeripheral:(CBPeripheral *)peripheral // 外设
{
    NSLog(@"连接成功");
    self.peripheral.delegate = self;
    [self.cMgr stopScan];
    [self.peripheral discoverServices:nil];
}

// 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@=连接失败",peripheral.name);
}

// 丢失连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@=断开连接", peripheral.name);
//    if (_manager.isReload==YES) {
//
//    }
//    else{
    CBUUID *uuid = [CBUUID UUIDWithString:@"FFF0"];
    [ self.cMgr scanForPeripheralsWithServices:@[uuid] options: nil];
//    }
}


//一旦我们读取到外设的相关服务UUID就会回调下面的方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error;
{
    NSLog(@"发现服务###%@",[peripheral services]);
    if (_manager.isReload==YES) {//判断是否获取到数据，获取到了就停止自动扫描，因为断开后会自动重连
        
    }else{
    for (CBService *s in [peripheral services]) {
        [peripheral discoverCharacteristics:nil forService:s];
    }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    //    [self writeToLog:@"查找到对应的特征"];
    
    NSLog(@"特征值是；%@",service.characteristics);
    
    for (CBCharacteristic *chariter in service.characteristics) {
        NSLog(@"PROPETIS；%li",chariter.properties);
        if (chariter.properties==2) {
            //只读
            [peripheral setNotifyValue:YES forCharacteristic:chariter];
        }
        else if (chariter.properties==26){
            //读，写，订阅
            NSString *str = @"123abc";
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [peripheral writeValue:data forCharacteristic:chariter type:CBCharacteristicWriteWithResponse];
        }
        /**********************/
        else if (chariter.properties==18){
            //订阅
            [peripheral setNotifyValue:YES forCharacteristic:chariter];
        }
        else if (chariter.properties==8){
            //写
            NSString *str = @"abc123";
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [peripheral writeValue:data forCharacteristic:chariter type:CBCharacteristicWriteWithResponse];
        }
        /*********************/
        else if (chariter.properties==10){
            //读，写
            if ([_GetInfo isEqualToString:@"CMD_SET_WIFIANDPASSWORD"]) {//设置设备热点密码
                NSData *data = [BLEToolsbar changePasswordbySSID:_manager.SSID andPwd:_changePwd];
                [peripheral writeValue:data forCharacteristic:chariter type:CBCharacteristicWriteWithResponse];
            }
            else if ([_GetInfo isEqualToString:@"CMD_SET_BLACK_LIST"]){//设置黑名单
                NSData *data = [BLEToolsbar setheimingdan:_blackStr];
                [peripheral writeValue:data forCharacteristic:chariter type:CBCharacteristicWriteWithResponse];
            }
            else if ([_GetInfo isEqualToString:@"CMD_SET_APN"]){//设置apn
                NSData *data = [BLEToolsbar setApnby:_dictApn[@"apn"] mcc:_dictApn[@"mcc"] mmsc:_dictApn[@"mmsc"] mmsport:_dictApn[@"mmsport"] mmsproxy:_dictApn[@"mmsproxy"] mnc:_dictApn[@"mnc"] name:_dictApn[@"name"] numeric:_dictApn[@"numeric"] password:_dictApn[@"password"] port:_dictApn[@"port"] proxy:_dictApn[@"proxy"] server:_dictApn[@"server"] type:_dictApn[@"type"] user:_dictApn[@"user"]];
                [peripheral writeValue:data forCharacteristic:chariter type:CBCharacteristicWriteWithResponse];
            }else if ([_GetInfo isEqualToString:@"CMD_BT_CONNECT_TO_AP"]){//设置wifi连接
                NSData *data = [BLEToolsbar ConnectWifibySSID:_manager.WIFIname andPwd:_manager.WIFIpwd];
                [peripheral writeValue:data forCharacteristic:chariter type:CBCharacteristicWriteWithResponse];
            }else if ([_GetInfo isEqualToString:@"CMD_BT_DISCONNECT_AP"]){//设置wifi连接
                NSData *data = [BLEToolsbar DisConnectWifibySSID:_manager.WIFIname andPwd:_manager.WIFIpwd];
                [peripheral writeValue:data forCharacteristic:chariter type:CBCharacteristicWriteWithResponse];
            }
            else{
            NSString *str = _GetInfo;
           // NSString *str =@"CMD_BT_GET_CURRENT_AP";
            str = [str stringByAppendingString:END_FLAG];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
             [peripheral writeValue:data forCharacteristic:chariter type:CBCharacteristicWriteWithResponse];
            }
        }
    }
    
}

//向peripheral中写入数据后的回调函数
- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        NSLog(@"=======%@",error.userInfo);
        
    }else{
         if ([_GetInfo isEqualToString:@"CMD_BT_CONNECT_TO_AP"]){
            //防止断开连接继续读取
                 _GetInfo = @"CMD_BT_GET_CURRENT_AP";
             
                 _isGETwifi = YES;
                [self.peripheral discoverServices:nil];
             
             
        
        }else if ([_GetInfo isEqualToString:@"CMD_BT_DISCONNECT_AP"]){
            //防止断开连接继续读取
                
                _GetInfo = @"CMD_BT_GET_CURRENT_AP";
                [self.peripheral discoverServices:nil];
          
            
            
            
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeUI" object:@"NO" userInfo:nil];
        }
        NSLog(@"发送数据成功");
    }
    /* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
//        [peripheral readValueForCharacteristic:characteristic];
}

//中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    if (characteristic.isNotifying) {
    //        [peripheral readValueForCharacteristic:characteristic];
        
    } else { // Notification has stopped
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
    }
}

//获取外设发来的数据,不论是read和notify,获取数据都从这个方法中读取
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{

    if (characteristic.properties==2) {
        //读
        NSData* data = characteristic.value;
        NSString* value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"characteristic(读取到的) : %@, data : %@, value : %@", characteristic, data, value);
    }else if (characteristic.properties==18){
       //非写入模式
        if (!_isWrite) {
            //订阅
            NSData* data = characteristic.value;
            NSString* value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [_dataBlue appendData:data];
            NSLog(@"characteristic(读取到的) : %@, data : %@，value：%li", characteristic,data,value.length );
            if (value) {
            _total = [_total stringByAppendingString:value];
            }
           
            NSLog(@"total===%@",_total);
            if(_total.length){
                if ([_total hasSuffix:END_FLAG]) {
                    _total =  [_total stringByReplacingOccurrencesOfString:END_FLAG withString:@""];
                    //直接转全部数据
                    NSString* value2 = [[NSString alloc] initWithData:_dataBlue encoding:NSUTF8StringEncoding];
                    value2 =  [value2 stringByReplacingOccurrencesOfString:END_FLAG withString:@""];
                    NSLog(@"total===%@=====value2%@=====",_total,value2);
                    NSDictionary *dict = [NSStringTool dictionaryWithJsonString:value2];
                    _dataBlue = [NSMutableData dataWithCapacity:0];
                    //解析成字典成功
                    if (dict) {
                        NSString * key = dict[@"key"];
                        NSString *value = dict[@"value"];
                        // 设置value
                        value = [value stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                        NSData * JSONData = [value dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary * responseJSONDict = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
                        // 设置新字典
                        //NSDictionary * newDic = [NSDictionary dictionaryWithObject:responseJSONDict forKey:key];
                        
                        [_deviceInfo setValuesForKeysWithDictionary:responseJSONDict];
                        [_manager.model setValuesForKeysWithDictionary:responseJSONDict];
                        _manager.password = _deviceInfo.password;
                        _manager.SSID = _deviceInfo.ssid;
                        _manager.appVersion = _deviceInfo.AppVersion;
                        if (![_manager.appVersion isEqualToString:@""]&&_manager.appVersion) {
                            if (!_isRequest) {
                                [self createUI];
                                _manager.isReload = YES;
                                [self.cMgr stopScan];
                            }
                            
                        }
                        
                        _total = @"";
                       // _GetInfo = @"";
                        
//                        if (!_isGet) {
//                            //获取完之后写入第二次数据
//                            _GetInfo = GET_DEVICE_INFO;
//                            _total = @"";
//                             [self.peripheral discoverServices:nil];
//                            _isGet = YES;
//                        }
//                        //解析成字典失败
//                        else{
//                            _total = @"";
//                        }
                    }
                }
            }
        }else{//写入模式
            NSData* data = characteristic.value;
            NSString* value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"characteristic(读取到的) : %@, data : %@，value：%li", characteristic,data,value.length );
            if (!_total) {
                
            }else{
            _total = [_total stringByAppendingString:value];
            }
            NSLog(@"total===%@",_total);
            if(_total.length){
                if ([_total hasSuffix:END_FLAG]) {
                    _total =  [_total stringByReplacingOccurrencesOfString:END_FLAG withString:@""];
                   NSLog(@"total转成json前===%@",_total);
                    NSDictionary *dict = [NSStringTool dictionaryWithJsonString:_total];
                    NSLog(@"total===%@=====",dict);
                    
                    //设置密码
                    if ([_GetInfo isEqualToString:@"CMD_SET_WIFIANDPASSWORD"]) {
                        //防止断开连接继续读取
                        _GetInfo = @"";
                        _manager.isReload = YES;
                        if ([dict[@"value"] isEqualToString:@"true"]) {
//                            UIAlertController *alertOne = [UIAlertController alertControllerWithTitle:@"修改密码成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
//                            [self presentViewController:alertOne animated:YES completion:nil];
//
//                            UIAlertAction *certain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//                            
//                            [alertOne addAction:certain];
                            
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"closeChangePWD_suc" object:nil];
                        }else{
//                            UIAlertController *alertOne = [UIAlertController alertControllerWithTitle:@"修改密码失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
//                            [self presentViewController:alertOne animated:YES completion:nil];
//
//                            UIAlertAction *certain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//
//                            [alertOne addAction:certain];
                             [[NSNotificationCenter defaultCenter]postNotificationName:@"closeChangePWD_fai" object:nil];
                        }
                    }
                    //设置黑名单
                    else if ([_GetInfo isEqualToString:@"CMD_SET_BLACK_LIST"]){
                        //防止断开连接继续读取
                        _GetInfo = @"";
                        _manager.isReload = YES;
                        if ([dict[@"value"] isEqualToString:@"true"]) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"closeChangePWD_suc" object:nil];
                        }else{
//                            UIAlertController *alertOne = [UIAlertController alertControllerWithTitle:@"添加黑名单失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
//                            [self presentViewController:alertOne animated:YES completion:nil];
//
//                            UIAlertAction *certain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//
//                            [alertOne addAction:certain];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"closeChangePWD_fai" object:nil];
                        }
                        
                    }
                    else if ([_GetInfo isEqualToString:@"CMD_SET_APN"]){
                        //防止断开连接继续读取
                        _GetInfo = @"";
                        _manager.isReload = YES;
                        if ([dict[@"value"] isEqualToString:@"true"]) {
//                            UIAlertController *alertOne = [UIAlertController alertControllerWithTitle:@"设置APN成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
//                            [self presentViewController:alertOne animated:YES completion:nil];
//
//                            UIAlertAction *certain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//
//                            [alertOne addAction:certain];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"closeChangePWD_suc" object:nil];
                        }else{
//                            UIAlertController *alertOne = [UIAlertController alertControllerWithTitle:@"设置APN失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
//                            [self presentViewController:alertOne animated:YES completion:nil];
//
//                            UIAlertAction *certain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//
//                            [alertOne addAction:certain];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"closeChangePWD_fai" object:nil];
                        }
                        
                    }
                    else if ([_GetInfo isEqualToString:@"CMD_BT_GET_CURRENT_AP"]){
                        //防止断开连接继续读取
                        _GetInfo = @"";
                        _manager.isReload = YES;
                        NSString *str = dict[@"value"];
                        if(_manager.isConnectInfo){
                        str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                        str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        str = [str stringByRemovingPercentEncoding];
                        if ([str isEqualToString:_manager.WIFIname]) {
                            _manager.isConnectWifi = YES;
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"closePWD_suc" object:nil];
                        }else{
                            _manager.isConnectWifi = NO;
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"closePWD_fai" object:nil];
                        }
                    }
                        else{
                            if ([str isEqualToString:@"<unknown ssid>"]) {
                                _manager.isConnectWifi = NO;
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"disconnectWIFI_suc" object:nil];
                            }else{
                                _manager.isConnectWifi = YES;
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"disconnectWIFI_fai" object:nil];
                            }
                        }
                    }
                    _total = @"";
                }
            }
        }
        
    }else if (characteristic.properties==10){

    }
    
}

-(void)createCmgr{
    
    self.cMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
}


/******************************************************************************/

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   

}
#pragma mark viewDidload
- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [YXManager share];
    
    NSLog(@"%@",_manager);
    _timeNum = 0;
    _total = @"";
    _isWrite = NO;
    _deviceInfo = [[PackagInfoModel alloc]init];
    _dataBlue = [NSMutableData dataWithBytes:nil length:0];
    self.peripheralArr = [NSMutableArray arrayWithCapacity:0];
    _dictApn = [[NSDictionary alloc]init];
    if (_manager.isReload) {
        
        [self setBackgroudImage];
        [self addScrView];
        [self showDeviceInfo];
        [self GetDeviceInfo];
        [self RequestandGetGlobalUI];
    }else{
    // Do any additional setup after loading the view
    _GetInfo = GET_DEVICE_INFO;
    //调用二维码扫描
    [self openScanView];
//    [self.cMgr scanForPeripheralsWithServices:nil options:nil];
    [self setBackgroudImage];
    [self addScrView];
    [self showDeviceInfo];
    //判断是否扫描是为了防止创建两个中心设备
        if (_manager.isScan) {
            
            [self.cMgr scanForPeripheralsWithServices:nil options:nil];
            [self showSchdu];
        }
//    [self showDeviceInfo];
//    //网络请求，应该放到蓝牙连接里面
//    [self RequestandGetGlobalUI];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePWD:) name:@"changePwd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heimindan:) name:@"heimingdan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAPN:) name:@"setAPN" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setWIFI:) name:@"setWIFI" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWIFI:) name:@"closeWIFI" object:nil];
      
    NSLog(@"Thread:======%@",[NSThread currentThread]);
    //添加定时器防止视图控制器你被销毁
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:50000.0 target:self selector:@selector(action) userInfo:nil repeats:YES];
    }


}


-(void)action{
    NSLog(@"11111111111111");
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
   
//
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
   
}

#pragma mark 二维码扫描
-(void)openScanView{
    if (!_manager.ScanID) {
        QRScanViewController *VC = [[QRScanViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
   
}

-(void)changePWD:(NSNotification*)notic{
    _changePwd = notic.object;
    _GetInfo = @"CMD_SET_WIFIANDPASSWORD";
    _isWrite = YES;
    _manager.isReload = NO;
    [self.peripheral discoverServices:nil];
    
}

-(void)heimindan:(NSNotification*)notic{
    _blackStr = notic.object;
    _GetInfo = @"CMD_SET_BLACK_LIST";
    _isWrite = YES;
    _manager.isReload = NO;
    [self.peripheral discoverServices:nil];
    
}

-(void)setAPN:(NSNotification*)notic{
    _dictApn = notic.userInfo;
    _GetInfo = @"CMD_SET_APN";
    _isWrite = YES;
    _manager.isReload = NO;
    [self.peripheral discoverServices:nil];
    
}

-(void)setWIFI:(NSNotification*)notic{
    _dictApn = notic.userInfo;
    _GetInfo = @"CMD_BT_CONNECT_TO_AP";
    _isWrite = YES;
    _manager.isReload = NO;
    [self.peripheral discoverServices:nil];
    
    
}

-(void)closeWIFI:(NSNotification*)notic{
    
    
    _dictApn = notic.userInfo;
    _GetInfo = @"CMD_BT_DISCONNECT_AP";
    _isWrite = YES;
    _manager.isReload = NO;
    [self.peripheral discoverServices:nil];
    
    
    
}


#pragma mark - 设置背景图片
-(void)setBackgroudImage{
    
    UIImageView *backgroud = [[UIImageView alloc]init];
    backgroud.frame = CGRectMake(0, 0, XScreenWidth,XScreenHeight);
    
    backgroud.image = [UIImage imageNamed:@"ic_bg.jpg"];
    
    [self.view addSubview:backgroud];
}

-(void)addScrView{
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(0,900*11/8);
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    //隐藏垂直方向滑动条
    _scrollView.showsVerticalScrollIndicator = NO;
}

#pragma mark 设备信息前缀
-(void)showDeviceInfo{
   
//    UIView *_view = [UIView new];
//    [_scrollView addSubview:_view];
//    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_scrollView).with.offset(20);
//        make.right.equalTo(_scrollView).with.offset(-20);
//        make.top.equalTo(_scrollView).with.offset(20+60+X_bang);
//        make.height.mas_equalTo(@250);
//    }];
//    _view.layer.cornerRadius = 10;
//    _view.backgroundColor = [UIColor whiteColor];
    
    //距离左右边margin
    CGFloat kMagin = 20.0;
    //宽度
    CGFloat kWidth = XScreenWidth - 2*kMagin;
    _view = [[UIView alloc]initWithFrame:CGRectMake(kMagin, 20+60+X_bang, kWidth, 250)];
    _view.layer.cornerRadius = 10;
    _view.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_view];
    
    //设备ssid
    UILabel *name_ssid = [UILabel new];
    [_view addSubview:name_ssid];
//    name_ssid.text =SetLange(@"shebeissid");
    name_ssid.text = @"设备SSID:";
    [name_ssid mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_view).with.offset(10);
        make.right.equalTo(_view).with.offset(-10);
        make.top.equalTo(_view).with.offset(10);
        make.height.mas_equalTo(@25);
        
        
    }];
    name_ssid.numberOfLines = 0;
    name_ssid.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //wifi密码
    UILabel *name_passWord = [UILabel new];
    
    [_view addSubview:name_passWord];
    
    [name_passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_ssid.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view).with.offset(-10);
        make.left.equalTo(_view).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    //name_passWord.text  = SetLange(@"Wifimima");
    name_passWord.text  = @"WIFI密码:";
    name_passWord.numberOfLines = 0;
    name_passWord.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //剩余电量
    UILabel *name_leftPower = [UILabel new];
    
    [_view addSubview:name_leftPower];
    
    [name_leftPower mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_passWord.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view).with.offset(-10);
        make.left.equalTo(_view).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    //name_leftPower.text  = SetLange(@"shengyudianliang");
    name_leftPower.text  = @"剩余电量:";
    name_leftPower.numberOfLines = 0;
    name_leftPower.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //设备连接数
    UILabel *name_deviceConnectNum = [UILabel new];
    
    [_view addSubview:name_deviceConnectNum];
    
    [name_deviceConnectNum mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_leftPower.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view).with.offset(-10);
        make.left.equalTo(_view).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    //name_deviceConnectNum.text  = SetLange(@"shebeilianjieshu");
    name_deviceConnectNum.text  = @"设备连接数:";
    name_deviceConnectNum.numberOfLines = 0;
    name_deviceConnectNum.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //信号强度
    UILabel *name_signStrong = [UILabel new];
    
    [_view addSubview:name_signStrong];
    
    [name_signStrong mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_deviceConnectNum.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view).with.offset(-10);
        make.left.equalTo(_view).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
   // name_signStrong.text  = SetLange(@"xinhaoqiangdu");
    name_signStrong.text  = @"信号强度:";
    name_signStrong.numberOfLines = 0;
    name_signStrong.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //设备版本
    UILabel *name_deviceVersion = [UILabel new];
    
    [_view addSubview:name_deviceVersion];
    
    [name_deviceVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_signStrong.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view).with.offset(-10);
        make.left.equalTo(_view).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
   // name_deviceVersion.text  = SetLange(@"shebeibanben");
    name_deviceVersion.text  = @"设备版本:";
    name_deviceVersion.numberOfLines = 0;
    name_deviceVersion.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    /*************************翻译订单信息*************************************/
//    UIView *_view2 = [UIView new];
//    [self.view addSubview:_view2];
//    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).with.offset(20);
//        make.right.equalTo(self.view).with.offset(-20);
//        make.top.equalTo(_view.mas_bottom).with.offset(30);
//        make.height.mas_equalTo(@400);
//    }];
    _view2 = [[UIView alloc]initWithFrame:CGRectMake(kMagin, _view.maxY+30, kWidth, 530)];
    _view2.layer.cornerRadius = 10;
    _view2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_view2];
    //860
    CGFloat k = _view2.maxY;
    //s隐藏
    _view2.alpha = 0;
    _view.alpha = 0;
    //翻译订单
    OrderLab = [UILabel new];
    [_view2 addSubview:OrderLab];
   // OrderLab.text =SetLange(@"fanyidingdan");
    //OrderLab.text =
    [OrderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_view2).with.offset(10);
        make.right.equalTo(_view2).with.offset(-10);
        make.top.equalTo(_view2).with.offset(20);
        make.height.mas_equalTo(@25);
        
        
    }];
    OrderLab.numberOfLines = 0;
    OrderLab.font = [UIFont boldSystemFontOfSize:Name_Device+2];
    
    //总流量
    UILabel *name_totalFlow = [UILabel new];
    
    [_view2 addSubview:name_totalFlow];
    
    [name_totalFlow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(OrderLab.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view2).with.offset(-10);
        make.left.equalTo(_view2).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    //name_totalFlow.text  = SetLange(@"zongliuliang");
    name_totalFlow.text  = @"总流量:";
    name_totalFlow.numberOfLines = 0;
    name_totalFlow.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //剩余流量
    UILabel *name_leftFlow = [UILabel new];
    
    [_view2 addSubview:name_leftFlow];
    
    [name_leftFlow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_totalFlow.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view2).with.offset(-10);
        make.left.equalTo(_view2).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    //name_leftFlow.text  = SetLange(@"shengyuliuliag");
    name_leftFlow.text  = @"剩余流量:";
    name_leftFlow.numberOfLines = 0;
    name_leftFlow.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //使用国家
    UILabel *name_useContry = [UILabel new];
    
    [_view2 addSubview:name_useContry];
    
    [name_useContry mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_leftFlow.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view2).with.offset(-10);
        make.left.equalTo(_view2).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
   // name_useContry.text  = SetLange(@"shiyongguojia");
    name_useContry.text  = @"使用国家:";
    name_useContry.numberOfLines = 0;
    name_useContry.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //开始时间
    UILabel *name_starTime = [UILabel new];
    
    [_view2 addSubview:name_starTime];
    
    [name_starTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_useContry.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view2).with.offset(-10);
        make.left.equalTo(_view2).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
   // name_starTime.text  = SetLange(@"kaishishjian");
    name_starTime.text  = @"开始时间:";
    name_starTime.numberOfLines = 0;
    name_starTime.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //结束时间
    UILabel *name_endTime = [UILabel new];
    
    [_view2 addSubview:name_endTime];
    
    [name_endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_starTime.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view2).with.offset(-10);
        make.left.equalTo(_view2).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    //name_endTime.text  = SetLange(@"jieshushijian");
    name_endTime.text  = @"结束时间:";
    name_endTime.numberOfLines = 0;
    name_endTime.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    
    //***************************通用流量信息*********************************************//
    flowInfo = [UILabel new];
    [_view2 addSubview:flowInfo];
   // flowInfo.text =SetLange(@"fanyidingdan");
    [flowInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_view2).with.offset(10);
        make.right.equalTo(_view2).with.offset(-10);
        make.top.equalTo(name_endTime.mas_bottom).with.offset(30);
        make.height.mas_equalTo(@25);
        
        
    }];
    flowInfo.numberOfLines = 0;
    flowInfo.font = [UIFont boldSystemFontOfSize:Name_Device+2];
    
    //总流量
    UILabel *name_GlobaltotalFlow = [UILabel new];
    
    [_view2 addSubview:name_GlobaltotalFlow];
    
    [name_GlobaltotalFlow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(flowInfo.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view2).with.offset(-10);
        make.left.equalTo(_view2).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    //name_GlobaltotalFlow.text  = SetLange(@"zongliuliang");
    name_GlobaltotalFlow.text  = @"总流量:";
    name_GlobaltotalFlow.numberOfLines = 0;
    name_GlobaltotalFlow.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //剩余流量
    UILabel *name_GlobaleftFlow = [UILabel new];
    
    [_view2 addSubview:name_GlobaleftFlow];
    
    [name_GlobaleftFlow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_GlobaltotalFlow.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view2).with.offset(-10);
        make.left.equalTo(_view2).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    //name_GlobaleftFlow.text  = SetLange(@"shengyuliuliag");
    name_GlobaleftFlow.text  = @"剩余流量:";
    name_GlobaleftFlow.numberOfLines = 0;
    name_GlobaleftFlow.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    
    //使用国家
    UILabel *name_GlobaluseCountry = [UILabel new];
    
    [_view2 addSubview:name_GlobaluseCountry];
    
    [name_GlobaluseCountry mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_GlobaleftFlow.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view2).with.offset(-10);
        make.left.equalTo(_view2).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    //name_GlobaluseCountry.text  = SetLange(@"shiyongguojia");
    name_GlobaluseCountry.text  = @"使用国家:";
    name_GlobaluseCountry.numberOfLines = 0;
    name_GlobaluseCountry.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //开始时间
    UILabel *name_Globalstartime = [UILabel new];
    
    [_view2 addSubview:name_Globalstartime];
    
    [name_Globalstartime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_GlobaluseCountry.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view2).with.offset(-10);
        make.left.equalTo(_view2).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
   // name_Globalstartime.text  = SetLange(@"kaishishjian");
    name_Globalstartime.text  = @"开始时间:";
    name_Globalstartime.numberOfLines = 0;
    name_Globalstartime.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //结束时间
    UILabel *name_Globalendtime = [UILabel new];
    
    [_view2 addSubview:name_Globalendtime];
    
    [name_Globalendtime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_Globalstartime.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(_view2).with.offset(-10);
        make.left.equalTo(_view2).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
   // name_Globalendtime.text  = SetLange(@"jieshushijian");
    name_Globalendtime.text  = @"结束时间:";
    name_Globalendtime.numberOfLines = 0;
    name_Globalendtime.font = [UIFont boldSystemFontOfSize:Name_Device];

}

#pragma mark 获取设备信息并赋值
-(void)GetDeviceInfo{
    
    //设备ssid
    _ssid = [UILabel new];
    [_view addSubview:_ssid];
    _ssid.text =_manager.model.ssid;
    [_ssid mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //make.left.equalTo(_view).with.offset(10);
        make.right.equalTo(_view).with.offset(-10);
        make.top.equalTo(_view).with.offset(10);
        make.height.mas_equalTo(@25);
        //make.width.mas_equalTo(@);
        
    }];
    _ssid.numberOfLines = 0;
    _ssid.font = [UIFont boldSystemFontOfSize:Device_Info];
    
    
    //wifi密码
    _pwd = [UILabel new];
    [_view addSubview:_pwd];
    _pwd.text =_manager.model.password;
    [_pwd mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_view.frame.size.width/2);
        // make.right.equalTo(_view).with.offset(-80);
        make.top.equalTo(_ssid.mas_bottom).with.offset(16);
        make.height.mas_equalTo(@25);
        //make.width.mas_equalTo(@);
        
    }];
    _pwd.numberOfLines = 0;
    _pwd.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //剩余电量
    _power = [UILabel new];
    [_view addSubview:_power];
    _power.text =_manager.model.Power;
    [_power mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_view.frame.size.width/2);
        // make.right.equalTo(_view).with.offset(-80);
        make.top.equalTo(_pwd.mas_bottom).with.offset(16);
        make.height.mas_equalTo(@25);
        //make.width.mas_equalTo(@);
        
    }];
    _power.numberOfLines = 0;
    _power.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //设备连接数
    _connectNum = [UILabel new];
    [_view addSubview:_connectNum];
    _connectNum.text =_manager.model.CurrConnections;
    [_connectNum mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_view.frame.size.width/2);
        // make.right.equalTo(_view).with.offset(-80);
        make.top.equalTo(_power.mas_bottom).with.offset(16);
        make.height.mas_equalTo(@25);
        //make.width.mas_equalTo(@);
        
    }];
    _connectNum.numberOfLines = 0;
    _connectNum.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //信号强度
    _singel = [UIImageView new];
    [_view addSubview:_singel];
    //_singel.text =_manager.model.Signal2;
    [_singel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_view.frame.size.width/2);
        // make.right.equalTo(_view).with.offset(-80);
        make.top.equalTo(_connectNum.mas_bottom).with.offset(16);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@25);
        
    }];
    NSInteger i = [_manager.model.Signal2 integerValue];
    if (i>=-85) {
        _singel.image = [UIImage imageNamed:@"wifi_signal_5"];
    }else if (i>=-95&&i<-85){
        _singel.image = [UIImage imageNamed:@"wifi_signal_4"];
    }else if (i>=-105&&i<-95){
        _singel.image = [UIImage imageNamed:@"wifi_signal_3"];
    }else if (i>=-115&&i<-105){
        _singel.image = [UIImage imageNamed:@"wifi_signal_2"];
    }else if (i<-115){
        _singel.image = [UIImage imageNamed:@"wifi_signal_1"];
    }
//    _singel.numberOfLines = 0;
//    _singel.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //设备版本
    _appVersion = [UILabel new];
    [_view addSubview:_appVersion];
    _appVersion.text =_manager.model.AppVersion;
    [_appVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_view.frame.size.width/2);
       // make.right.equalTo(_view).with.offset(-80);
        make.top.equalTo(_singel.mas_bottom).with.offset(15);
        make.height.mas_equalTo(@25);
        //make.width.mas_equalTo(@);
        
    }];
    _appVersion.numberOfLines = 0;
    _appVersion.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    
//    if(_deviceInfo.AppVersion){
        _view.alpha = 1.0;
        _view2.alpha = 1.0;
    
        _manager.isReload = YES;
//    }
    
}

#pragma mark 调用全部视图
-(void)createUI{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //返回主线程 拿到数据
//        [self RequestandGetGlobalUI];
//       
//        dispatch_async(dispatch_get_main_queue(), ^{
//             [self showDeviceInfo];
//            [self GetTranslateUI:_manager.modelTranslate];
//            [self GetTranslateUI:_manager.modelGlobal];
//            [self GetDeviceInfo];
//            _manager.isReload = YES;
//        });
//    });
//    [self showDeviceInfo];
//    //网络请求，应该放到蓝牙连接里面
    if (!_isRequest) {
         [self RequestandGetGlobalUI];
    }
   
//    [self GetDeviceInfo];
//    _manager.isReload = YES;
}

#pragma mark 网络请求获取全球套餐
-(void)RequestandGetGlobalUI{
    _isRequest = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [NetWork sendGetNetWorkWithUrl:Global_url parameters:nil hudView:self.view successBlock:^(id data) {
       // NSLog(@"data==%@==",data);
        NSArray *arr = data[@"device_order"];
        NSDictionary *dictTranslate = arr[0];
        PackagInfoModel *modelTranslate = [[PackagInfoModel alloc]init];
        [modelTranslate setValuesForKeysWithDictionary:dictTranslate];
        [_manager.modelTranslate setValuesForKeysWithDictionary:dictTranslate];
//        [self GetTranslateUI:_manager.modelTranslate];
        
        NSDictionary *dictGlobal = arr[1];
        PackagInfoModel *modelGlobal = [[PackagInfoModel alloc]init];
        [modelGlobal setValuesForKeysWithDictionary:dictGlobal];
        [_manager.modelGlobal setValuesForKeysWithDictionary:dictGlobal];
        _manager.isReload = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideSchdu];
//            [UIView animateWithDuration:1.0 animations:^{
                [self GetDeviceInfo];
                [self GetTranslateUI:_manager.modelTranslate];
                [self GetGlobalUI:_manager.modelGlobal];
//            }];
        
        
        
        });
    } failureBlock:^(NSString *error) {
        NSLog(@"获取数据失败%@",error);
        
    }];
});
    
    
}

#pragma mark 创建翻译订单内容界面
-(void)GetTranslateUI:(PackagInfoModel*)model{
    
    //*******************翻译订单**************************//
    OrderLab.text = [model.product_name stringByRemovingPercentEncoding];
    //总流量
    UILabel *_totalFlow_trans = [UILabel new];
    
    [_view2 addSubview:_totalFlow_trans];
    
    [_totalFlow_trans mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(OrderLab.mas_bottom).with.offset(Hmargin);
        //make.right.equalTo(_view2).with.offset(-10);
        make.left.mas_equalTo(_view2.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
    }];
    _totalFlow_trans.text  =[NSString stringWithFormat:@"%@M", model.flow_count];
    _totalFlow_trans.numberOfLines = 0;
    _totalFlow_trans.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //剩余流量
    UILabel *_leftFlow_trans = [UILabel new];
    
    [_view2 addSubview:_leftFlow_trans];
    
    [_leftFlow_trans mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_totalFlow_trans.mas_bottom).with.offset(Hmargin);
        //make.right.equalTo(_view2).with.offset(-10);
        make.left.mas_equalTo(_view2.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
    }];
    
    _leftFlow_trans.text  = [NSString stringWithFormat:@"%@M",model.left_flow_count];
    _leftFlow_trans.numberOfLines = 0;
    _leftFlow_trans.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //使用国家
    UILabel *_useConutry_trans = [UILabel new];
    
    [_view2 addSubview:_useConutry_trans];
    
    [_useConutry_trans mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_leftFlow_trans.mas_bottom).with.offset(Hmargin);
        //make.right.equalTo(_view2).with.offset(-10);
        make.left.mas_equalTo(_view2.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
    }];
    _useConutry_trans.text  =model.effective_countries;
    _useConutry_trans.numberOfLines = 0;
    _useConutry_trans.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //开始时间
    UILabel *_starTime_trans = [UILabel new];
    
    [_view2 addSubview:_starTime_trans];
    
    [_starTime_trans mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_useConutry_trans.mas_bottom).with.offset(Hmargin);
        //make.right.equalTo(_view2).with.offset(-10);
        make.left.mas_equalTo(_view2.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
    }];
    _starTime_trans.text  =model.start_time;
    _starTime_trans.numberOfLines = 0;
    _starTime_trans.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //结束时间
    UILabel *_endTime_trans = [UILabel new];
    
    [_view2 addSubview:_endTime_trans];
    
    [_endTime_trans mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_starTime_trans.mas_bottom).with.offset(Hmargin);
        //make.right.equalTo(_view2).with.offset(-10);
        make.left.mas_equalTo(_view2.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
    }];
    _endTime_trans.text  =model.end_time;
    _endTime_trans.numberOfLines = 0;
    _endTime_trans.font = [UIFont boldSystemFontOfSize:Name_Device];
    
}

#pragma mark 创建上网流量内容的界面
-(void)GetGlobalUI:(PackagInfoModel*)model{
    
    flowInfo.text = [model.product_name stringByRemovingPercentEncoding];
    //总流量
    UILabel *_GlobaltotalFlow = [UILabel new];
    
    [_view2 addSubview:_GlobaltotalFlow];
    
    [_GlobaltotalFlow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(flowInfo.mas_bottom).with.offset(Hmargin);
       // make.right.equalTo(_view2).with.offset(-10);
        make.left.mas_equalTo(_view2.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
    }];
    _GlobaltotalFlow.text  = [NSString stringWithFormat:@"%@M",model.flow_count];
    _GlobaltotalFlow.numberOfLines = 0;
    _GlobaltotalFlow.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //剩余流量
    UILabel *_GloballeftFlow = [UILabel new];
    
    [_view2 addSubview:_GloballeftFlow];
    
    [_GloballeftFlow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_GlobaltotalFlow.mas_bottom).with.offset(Hmargin);
        // make.right.equalTo(_view2).with.offset(-10);
        make.left.mas_equalTo(_view2.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
    }];
    _GloballeftFlow.text  =  [NSString stringWithFormat:@"%@M",model.left_flow_count];
    _GloballeftFlow.numberOfLines = 0;
    _GloballeftFlow.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //使用国家
    UILabel *_Globaleffective_countries = [UILabel new];
    
    [_view2 addSubview:_Globaleffective_countries];
    
    [_Globaleffective_countries mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_GloballeftFlow.mas_bottom).with.offset(Hmargin);
         make.right.equalTo(_view2).with.offset(-10);
        make.left.mas_equalTo(_view2.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
        
    }];
    _Globaleffective_countries.text  = [model.effective_countries stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _Globaleffective_countries.numberOfLines = 0;
    _Globaleffective_countries.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //开始时间
    UILabel *_GlobalstarTime = [UILabel new];
    
    [_view2 addSubview:_GlobalstarTime];
    
    [_GlobalstarTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_Globaleffective_countries.mas_bottom).with.offset(Hmargin);
        // make.right.equalTo(_view2).with.offset(-10);
        make.left.mas_equalTo(_view2.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
    }];
    _GlobalstarTime.text  = model.start_time;
    _GlobalstarTime.numberOfLines = 0;
    _GlobalstarTime.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //结束时间
    UILabel *_GlobalendTime = [UILabel new];
    
    [_view2 addSubview:_GlobalendTime];
    
    [_GlobalendTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_GlobalstarTime.mas_bottom).with.offset(Hmargin);
        // make.right.equalTo(_view2).with.offset(-10);
        make.left.mas_equalTo(_view2.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
    }];
    _GlobalendTime.text  =model.end_time;
    _GlobalendTime.numberOfLines = 0;
    _GlobalendTime.font = [UIFont boldSystemFontOfSize:Name_Device];
    
}


#pragma mark - 显示进度条

-(void)showSchdu{
//    hud =   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
//
//    hud.color = [UIColor grayColor];
//
//    [hud showAnimated:YES];
    
    
    
    //2.annular & LineCapStyle
    self.view.backgroundColor = [UIColor blueColor];
    self.largeProgressView = [[LFRoundProgressView alloc]initWithFrame:CGRectMake(XScreenWidth/2-75,XScreenHeight/2-75, 150, 150)];
    self.progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(XScreenWidth/2-200, self.largeProgressView.maxY+20, 400, 60)];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.largeProgressView.annularLineCapStyle = kCGLineCapRound;
    self.largeProgressView.annularLineWith = 4.f;
    self.largeProgressView.percentLabelFont = [UIFont boldSystemFontOfSize:14];
    self.largeProgressView.percentLabelTextColor = [[UIColor alloc] initWithWhite:0.2f alpha:.8f];
    self.largeProgressView.progressTintColor = [UIColor colorWithRed:53.0/255.0 green:144.0/255.0 blue:242.0/255.0 alpha:1];
    self.largeProgressView.backgroundTintColor = [UIColor grayColor];
    
    [self.view addSubview:self.progressLabel];
    [self.view addSubview:self.largeProgressView];
    
    
    
    [self startAnimation];
}
- (void)startAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                                  target:self
                                                selector:@selector(progressChange)
                                                userInfo:nil
                                                 repeats:YES];
    
}



- (void)progressChange
{
    NSArray *progressViews = @[
                               self.largeProgressView
                               ];
    for (LFRoundProgressView *progressView in progressViews) {
        CGFloat progress = ![self.timer isValid] ? 10 / 10.0f : progressView.progress + 0.01f;
        progressView.progress = progress;
        
        
        if (progressView.progress >= 1.0f && [self.timer isValid]) {
            progressView.progress = 0.f;
        }
        
        self.progressLabel.text = [NSString stringWithFormat:@"绑定设备中，请保持蓝牙状态打开..."];
    }
    
//    _timeNum +=1;
//    if (_timeNum/5==8) {
//        _isRequest = NO;
//        _manager.isReload = NO;
//    }
//    NSLog(@"时间==%i",_timeNum);
    
}


-(void)hideSchdu{
//    [hud hideAnimated:YES];
    [self.timer invalidate];
     self.timer = nil;
   
    [self.largeProgressView removeFromSuperview];
    [self.progressLabel removeFromSuperview];
}

/*********************懒加载*******************************/
-(UIScrollView *)scrollView{
    if (!_scrollView) {
         _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, XScreenWidth,900)];
    }
    return _scrollView;
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
