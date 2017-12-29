//
//  BLETool.m
//  51tgtwifi
//
//  Created by 51tgt on 2017/11/9.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "BLETool.h"



@interface BLETool ()   <CBCentralManagerDelegate,CBPeripheralDelegate,BleDelegate>
@property (nonatomic ,strong) NSMutableArray *deviceArr;
//中央设备的属性，全部操作都是通过这个来
@property (nonatomic ,strong)CBCentralManager *myCentralManager;

@end


@implementation BLETool


#pragma mark - Singleton
static BLETool *bleTool = nil;

- (instancetype)init
{
    self = [super init];
    if (self) {
        //这里centralManager需要设置CBCentralManagerDelegate,CBPeripheralDelegate这两个代理
        _myCentralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:nil];
    }
    return self;
}

+ (instancetype)shareInstance
{
    //这里是通过GCD的once方法实现单例的创建，该方法在整个应用程序中只会执行一次，所以经常用作单例的创建。
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bleTool = [[self alloc] init];
    });
    
    return bleTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bleTool = [super allocWithZone:zone];
    });
    
    return bleTool;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - 懒加载
- (NSMutableArray *)deviceArr
{
    if (!_deviceArr) {
        _deviceArr = [NSMutableArray array];
    }
    
    return _deviceArr;
}










#pragma mark - action of connecting layer -连接层操作
- (void)scanDevice
{
    [self.deviceArr removeAllObjects];
    //这里的第一个参数设置为nil，就扫描所有的设备，如果只想返回特定的服务的设备，就给服务的数组
    [_myCentralManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)stopScan
{
    [_myCentralManager stopScan];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
{
    self.currentPer = peripheral;
    //请求连接到此外设
    [_myCentralManager connectPeripheral:peripheral options:nil];
}

- (void)unConnectPeripheral
{
    [self.myCentralManager cancelPeripheralConnection:self.currentPer];
}

- (NSArray *)retrieveConnectedPeripherals
{
    //这里值得注意，在ios9.0之前，可以用retrieveConnectedPeripherals这个方法来返回手机已经连接的设备，
    //但是在9.0被废弃了，现在需要特定的服务UUID才能返回特定的已连接设备。
    return [_myCentralManager retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:@""]]];
}









#pragma mark - CBCentralManagerDelegate
//检查设备蓝牙开关的状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"蓝牙已打开");
        [_myCentralManager scanForPeripheralsWithServices:nil options:nil];
    }else {
        NSLog(@"蓝牙已关闭");
    }
    
    
}

//查找到正在广播的外设
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@", peripheral.name);
    //当你发现你感兴趣的外围设备，停止扫描其他设备，以节省电能。
    if (![self.deviceArr containsObject:peripheral]) {
        [self.deviceArr addObject:peripheral];
        
        if ([self.discoverDelegate respondsToSelector:@selector(BLEDidDiscoverDeviceWithMac:)]) {
//            [self.discoverDelegate BLEDidDiscoverDeviceWithMac:];
            
        }
        
        
    }
}







@end
