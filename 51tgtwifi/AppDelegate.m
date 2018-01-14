//
//  AppDelegate.m
//  51tgtwifi
//
//  Created by weiyuxiang on 2017/10/12.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabbarController.h"
#import "MainNavVc.h"
#import "QRScanViewController.h"
#import "YXManager.h"
#import "NetNotifiVc.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
/****    判断机子语言     ****/
//    NSArray *langArr1 = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
//    NSString *language1 = langArr1.firstObject;
//    for (NSString *str  in langArr1) {
//        NSLog(@"模拟器语言=：%@",str);
//    }
//    NSLog(@"模拟器语言第一个=##%@##",language1);
//    //
//    if ([language1 containsString:@"zh-Hans-"]||[language1 containsString:@"zh-Hans"]) {
//        NSArray *lans = @[@"zh-Hans"];
//        [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
//    }else if ([language1 containsString:@"zh-Hant-"]||[language1 containsString:@"zh-Hant"]){
//        NSArray *lans = @[@"zh-Hant"];
//        [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
//    }else if ([language1 containsString:@"en-"]||[language1 containsString:@"en"]){
//        NSArray *lans = @[@"en"];
//        [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
//    }else if ([language1 containsString:@"ja-"]||[language1 containsString:@"ja"]){
//        NSArray *lans = @[@"ja"];
//        [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
//    }else {
//        NSArray *lans = @[@"en"];
//        [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
//    }
    
    
//    paypal支付
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction :PPEnvironmentProduction,PayPalEnvironmentSandbox : PPEnvironmentSandbox}];
    

    //判断是否登陆过设备，有就不用扫描
    YXManager *manager = [YXManager share];
//    manager.MutArr = [NSMutableArray arrayWithCapacity:0];
//    //创建
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    // 读取账户
//    NSString * ScanID;
//    NSMutableArray *_arr = [NSMutableArray arrayWithCapacity:0];
//    NSMutableArray *mutableCopyArr = [NSMutableArray arrayWithCapacity:0];
//    if ([userDefaults objectForKey:@"DeviceSN"]) {
//        mutableCopyArr = [userDefaults objectForKey:@"DeviceSN"];
//        _arr = [ mutableCopyArr mutableCopy];
//        manager.MutArr = _arr;
//        NSLog(@"===设备号%@==DeviceSN%@",_arr,[userDefaults objectForKey:@"DeviceSN"]);
//        ScanID  = _arr.lastObject;
//        manager.isScan = YES;
//        manager.ScanID = ScanID;
//    }else{
//        NSLog(@"==没有历史记录==");
//    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceStr = @"";
    if (![userDefaults objectForKey:@"Device"]) {
       
    }else
    {
        deviceStr = [userDefaults objectForKey:@"Device"];
        NSArray  *array = [deviceStr componentsSeparatedByString:@"*"];
        manager.isScan = YES;
        manager.ScanID = array[array.count-2];
    }

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.window makeKeyWindow];
    NetNotifiVc *netVc = [[NetNotifiVc alloc]init];
    self.window.rootViewController = netVc;
//    self.window.rootViewController = [[MainNavVc alloc]initWithRootViewController:[[MainTabbarController alloc]init]];
    
   // self.window.rootViewController = [[MainNavVc alloc]initWithRootViewController:[[QRScanViewController alloc]init]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"111111111");
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"222222");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"333333");
         [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxin" object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"444444");
    NSArray *langArr1 = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *language1 = langArr1.firstObject;
    for (NSString *str  in langArr1) {
        NSLog(@"模拟器语言=：%@",str);
    }
    
    NSLog(@"模拟器语言第一个=##%@##",language1);

}


#pragma mark 处理 Widget 相关事件
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSString* prefix = @"wpfWidgetTest://action=";
    NSString *urlString = [url absoluteString];
    
    if ([urlString rangeOfString:prefix].location != NSNotFound) {
        NSString *action = [urlString substringFromIndex:prefix.length];
        if ([action isEqualToString:@"richScan"]) {
            // 进入到扫一扫页面
             self.window.rootViewController = [[MainNavVc alloc]initWithRootViewController:[[MainTabbarController alloc]init]];
        } else if ([action isEqualToString:@"web"]) {
            // 进入到 web 活动页
//            [self.rootVC transferToWebVCWithUrlString:@"webTest"];
            
        }
    }
    return  YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
