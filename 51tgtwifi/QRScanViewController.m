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

@interface QRScanViewController ()<TGTScanQRCodeDelegate,BaseViewButtonDelegete,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    MBProgressHUD        *hud;
}
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
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(XScreenWidth-70, 30+X_bang, 70, 40)];
    [btn setTitle:@"相 册" forState:UIControlStateNormal];
    [btn setShowsTouchWhenHighlighted:YES];
    // [btn setTintColor:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    btn.backgroundColor = CLEARCOLOR;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(readerImage) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark 点击从相册获取图片
- (void)readerImage{
dispatch_async(dispatch_get_global_queue(0, 0), ^{
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
dispatch_async(dispatch_get_main_queue(), ^{
    photoPicker.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:photoPicker animated:YES completion:NULL];
    [self.scanView stopScanQrCode];
         });
     });
}
//不选图片，从相册直接退出
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.scanView startScanQrCode];
    }];
}
//从相册选出图片后
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:^{
        //code is here ...
        [self.scanView startScanQrCode];
        
    }];
    
    UIImage *srcImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *img = [self yasuo:srcImage];
    NSString *result = [self scQRReaderForImage:img];//调用上面讲过的方法对图片中的二维码进行处理
    NSLog(@"==%@==",result);

}

-(UIImage *)yasuo:(UIImage *)theImage{
    UIImage* bigImage = theImage;
    float actualHeight = bigImage.size.height;
    float actualWidth = bigImage.size.width;
    float newWidth =0;
    float newHeight =0;
    if(actualWidth > actualHeight) {
        //宽图
        newHeight =256.0f;
        newWidth = actualWidth / actualHeight * newHeight;
    }
    else
    {
        //长图
        newWidth =256.0f;
        newHeight = actualHeight / actualWidth * newWidth;
    }
    CGRect rect =CGRectMake(0.0,0.0, newWidth, newHeight);
    UIGraphicsBeginImageContext(rect.size);
    [bigImage drawInRect:rect];// scales image to rect
    theImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //RETURN
    return theImage;
    

}

- (NSString *)scQRReaderForImage:(UIImage *)image{
    NSData *data = UIImagePNGRepresentation(image);
    CIImage *ciimage = [CIImage imageWithData:data];
    if (ciimage) {
        CIDetector *qrDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:[CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer:@(YES)}] options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
        NSArray *resultArr = [qrDetector featuresInImage:ciimage];
        if (resultArr.count >0) {
            CIFeature *feature = resultArr[0];
            CIQRCodeFeature *qrFeature = (CIQRCodeFeature *)feature;
            NSString *result = qrFeature.messageString;
            
            return result;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [_scanView stopScanQrCode];
}
#pragma mark 手电筒的代理
- (void)buttonBeTouched:(UIButton *)sender view:(UILabel *)label{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (!sender.selected) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                sender.selected = YES;
                label.text = @"轻触关闭";
                [YXManager share].isLight = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                sender.selected = NO;
                label.text = @"轻触照亮";
                [YXManager share].isLight = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

#pragma mark - TGTScanQRCodeDelegate
- (void)getResponse:(NSString *)qrCodeString {
    if ([self isActivationDevice:qrCodeString]) {//激活过
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"扫描到设备：%@", qrCodeString] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"重新扫描" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [_scanView startScanQrCode];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"绑定设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.delegate getQrCodeResponse:qrCodeString];
            YXManager *manager = [YXManager share];
            manager.ScanID = qrCodeString;
            manager.isScan = YES;
            manager.isBind = YES;
            [self.navigationController popViewControllerAnimated:YES];
            //储存设备sn号
            [[NSUserDefaults standardUserDefaults ]setObject:manager.ScanID forKey:@"DeviceSN"];
            //必须
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"不绑定设备，直接进入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            YXManager *manager = [YXManager share];
            manager.isBind = NO;
            manager.isScan = YES;
            manager.ScanID = qrCodeString;
            [self.navigationController popViewControllerAnimated:YES];
            //储存设备sn号
            [[NSUserDefaults standardUserDefaults ]setObject:manager.ScanID forKey:@"DeviceSN"];
            //必须
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }else{//激活设备
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否激活设备?"] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [_scanView startScanQrCode];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self activationDevice];
        }]];
        [self presentViewController:alert animated:true completion:nil];
        
    }
    
    
}

#pragma mark 判断设备是否已激活
-(BOOL)isActivationDevice:(NSString *)str{
    
    
    return YES;
}

#pragma mark 激活设备
-(void)activationDevice{
    
    
}

#pragma mark - 加载属性
- (ScanView *)scanView {
    if (!_scanView) {
        _scanView = [[ScanView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight)];
        _scanView.delegate = self;
        _scanView.Opendelegate = self;
    }
    return _scanView;
}

#pragma mark - 显示进度条

-(void)showSchdu{
    hud =   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    
    hud.color = [UIColor grayColor];
    
    [hud showAnimated:YES];
}

-(void)hideSchdu{
    [hud hideAnimated:YES];
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
