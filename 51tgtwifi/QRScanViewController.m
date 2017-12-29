//
//  QRScanViewController.m
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/12/29.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "QRScanViewController.h"
#import "ScanView.h"
#import "YXManager.h"

@interface QRScanViewController ()<TGTScanQRCodeDelegate>
@property (nonatomic,retain) ScanView *scanView;
@end

@implementation QRScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        //无权限
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机访问权限已关闭" message:@"为方便使用，请前往设置中找到\"途鸽WiFi\"APP,并选择允许访问" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:^(BOOL success) {}];
        }]];
        [self presentViewController:alert animated:true completion:nil];
        return;
    } else {
        [self.view addSubview:self.scanView];
    }
//    NavBarView *navView = [[NavBarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
//    [self.view addSubview:navView];
//    [navView initWithTitleName:@"扫描二维码"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [_scanView stopScanQrCode];
}
#pragma mark - TGTScanQRCodeDelegate
- (void)getResponse:(NSString *)qrCodeString {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"扫描到设备名：%@", qrCodeString] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_scanView startScanQrCode];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"绑定设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.delegate getQrCodeResponse:qrCodeString];
            YXManager *manager = [YXManager share];
            manager.ScanID = qrCodeString;
            manager.isScan = YES;
           [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - 加载属性
- (ScanView *)scanView {
    if (!_scanView) {
        _scanView = [[ScanView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight)];
        _scanView.delegate = self;
    }
    return _scanView;
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
