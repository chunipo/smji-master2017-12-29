//
//  BluetrueVC.m
//  51tgtwifi
//
//  Created by 51tgt on 2017/11/10.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "BluetrueVC.h"
#import "BabyBluetooth.h"
#import <CoreBluetooth/CoreBluetooth.h>

BabyBluetooth *baby;


@interface BluetrueVC ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@end

@implementation BluetrueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    baby = [BabyBluetooth shareBabyBluetooth];
    
    
    
    [self babyDelegate];
    
    baby.scanForPeripherals().begin();
}

-(void)babyDelegate{


    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
    }];
    
    //过滤器
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //最常用的场景是查找某一个前缀开头的设备 most common usage is discover for peripheral that name has common prefix
        //if ([peripheralName hasPrefix:@"Pxxxx"] ) {
        //    return YES;
        //}
        //return NO;
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
        if (peripheralName.length >1) {
            return YES;
        }
        
        
        
        return NO;
    }];

    
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
