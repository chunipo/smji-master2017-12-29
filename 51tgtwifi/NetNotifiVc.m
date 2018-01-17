//
//  NetNotifiVc.m
//  51tgtwifi
//
//  Created by DEVCOM on 2018/1/13.
//  Copyright © 2018年 weiyuxiang. All rights reserved.
//

#import "NetNotifiVc.h"
#import "MainTabbarController.h"
#import "MainNavVc.h"
#import "YXManager.h"

@interface NetNotifiVc ()
{
    YXManager   *_manager;
    //无网络警告
    UIImageView *errorImg;
    UILabel     *lab;
    
    //有网络界面
    UILabel     *labDetai;
    UIImageView *LogoImg;
    UIView      *viewBack;
}
@end

@implementation NetNotifiVc

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [YXManager share];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
     [self HeadTitle];
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        //在block中拿到当前网络状态
        
        NSLog(@"-----当前的网络状态---%zd", status);
        if (status==0) {
            NSLog(@"-----当前无网络");
            [self disNetlabel];
            labDetai.alpha = 0;
            LogoImg.alpha = 0;
            viewBack.alpha = 0;
            [labDetai removeFromSuperview];
            [LogoImg removeFromSuperview];
            [viewBack removeFromSuperview];
        }else {
           
            [self labelUI];
            errorImg.alpha = 0;
            lab.alpha = 0;
            [errorImg removeFromSuperview];
            [lab removeFromSuperview];
            if (_manager.ScanID) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您已经绑定过设备，是否直接进入？"] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                   
                }]];
//                [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                    YXManager *manager = [YXManager share];
//                    manager.ScanID = str;
//                    manager.isScan = YES;
//                    manager.isBind = YES;
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                    //储存设备sn号
//                    [self saveSn];
//
//                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    _manager.isBind = NO;
                    _manager.isScan = YES;
                    
                    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:[[MainNavVc alloc]initWithRootViewController:[[MainTabbarController alloc]init]]];
                   
                    
                }]];
                [self presentViewController:alert animated:true completion:nil];
            }
        }
        
    }];
    
    [mgr startMonitoring];

}
#pragma mark 添加中心文字
-(void)labelUI{
    viewBack = [[UIView alloc]initWithFrame:CGRectMake(0, 20+44+X_bang, XScreenWidth, 128+20+20)];
    viewBack.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewBack];
    LogoImg = [[UIImageView alloc]initWithFrame:CGRectMake((XScreenWidth-300)/2, 20+44+X_bang+10, 300, 150)];
    LogoImg.image = [UIImage imageNamed:@"baidu-tuge.png"];
    [self.view addSubview:LogoImg];
    labDetai = [[UILabel alloc]initWithFrame:CGRectMake(20, viewBack.maxY, XScreenWidth-2*20, 400)];
    labDetai.text = @"        百度共享WiFi翻译机由百度与途鸽联合出品，是一款革新性的智能便携硬件产品。\n        它基于百度语音识别合成及神经网络翻译等人工智能技术，可以在中英、中日等互译模式中自动识别语种，实现“傻瓜式”一键翻译；与此同时，它融合途鸽全球云通信  Cloud SIM自主专利技术，自带80+国家移动数据流量，无需SIM卡，开机即可自动联网 。\n        它能满足您对跨境旅游 、商务沟通、外语学习、过节送礼的多重需求，让您的跨境旅行更精彩，全球沟通更自在。\n下面您可通过扫描百度共享WiFi翻译机二维码/条形码以此绑定/激活设备。注意事项：\n\n1.请保持您的手机网络畅通.\n2.如果需要连接设备，请记得打开您的蓝牙开关.\n3.点击右上方按钮开始扫描二维码.";
    labDetai.textAlignment = NSTextAlignmentLeft;
    labDetai.textColor = [UIColor grayColor];
    labDetai.font = [UIFont systemFontOfSize:15];
    labDetai.numberOfLines = 0;
    [self.view addSubview:labDetai];
}

#pragma mark - 创建标题栏
-(void)HeadTitle{
    UIView *_TitleView = [[UIView alloc]init];
    _TitleView.frame =CGRectMake(0, 0, XScreenWidth, 44+X_bang+20);
    
    _TitleView.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:144.0/255.0 blue:242.0/255.0 alpha:1];
    [self.view addSubview:_TitleView];
    
    UILabel *TitleText = [UILabel new];
    [_TitleView addSubview:TitleText];
    
    
    
    
    TitleText.text = @"";
    //    TitleText.text = NSLocalizedString(@"title", nil);
    
    
    TitleText.textColor = [UIColor whiteColor];
    
    [TitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.centerX.equalTo(_TitleView);
        make.centerY.mas_equalTo(_TitleView.mas_centerY).with.offset(X_bang/2.0+10);
    }];
    //TitleText.font = [UIFont systemFontOfSize:20];
    TitleText.textAlignment = 1;
    
    
    //    取消按钮
    UIButton *btn = [UIButton new];
    [_TitleView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_TitleView).offset(-15);
        
        make.centerY.equalTo(TitleText);
        
        make.size.mas_equalTo(CGSizeMake(30, 30));
        
        
    }];
   
    
    btn.tag = 101;
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    
//    [btn setTitle:@"扫描二维码" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"saomiao.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)click:(UIButton *)btn{
    //返回
    if (btn.tag==101) {
//         [[[[[UIApplication sharedApplication] delegate] window] setRootViewController:[MainNavVc alloc]initWithRootViewController:[[MainTabbarController alloc]init]]] ];
        _manager.isBind = NO;
        _manager.isScan = NO;
        [[[[UIApplication sharedApplication] delegate] window] setRootViewController:[[MainNavVc alloc]initWithRootViewController:[[MainTabbarController alloc]init]]];
    }
}


-(void)disNetlabel{
    errorImg = [[UIImageView alloc]initWithFrame:CGRectMake((XScreenWidth-128)/2, (XScreenHeight-128)/2, 128, 128)];
    errorImg.image = [UIImage imageNamed:@"netError.png"];
    [self.view addSubview:errorImg];
    
    lab = [[UILabel alloc]initWithFrame:CGRectMake((XScreenWidth-350)/2, errorImg.maxY+10, 350, 50)];
    lab.text = @"当前无可用网路,请保持网络畅通再对百度翻译机设备进行二维码扫描";
    lab.textColor = [UIColor grayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:18];
    lab.numberOfLines = 0;
    [self.view addSubview:lab];
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
