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
#import "NetWork.h"
#import "HistoryViewController.h"


@interface QRScanViewController ()<TGTScanQRCodeDelegate,BaseViewButtonDelegete,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    MBProgressHUD        *hud;
    YXManager            *_manager;
    BOOL                 *_isActiveSuc;
}
@property (nonatomic,retain) ScanView *scanView;
@end


@implementation QRScanViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (!_manager.isStarAcan) {
        [self.scanView startScanQrCode];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [YXManager share];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        //无权限
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机访问权限已关闭" message:@"为方便使用，请前往设置中找到\"途鸽WiFi\"APP,并选择允许访问" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:setCountry(@"quxiao") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
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
    //相册
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(XScreenWidth-90, 30+X_bang, 90, 40)];
    [btn setTitle:setCountry(@"xiangce") forState:UIControlStateNormal];
    [btn setShowsTouchWhenHighlighted:YES];
    // [btn setTintColor:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    btn.backgroundColor = CLEARCOLOR;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(readerImage) forControlEvents:UIControlEventTouchUpInside];
    
    //历史设备
    UIButton *btnHis = [[UIButton alloc]initWithFrame:CGRectMake((XScreenWidth-35)/2, XScreenHeight-49-20-35, 35, 35)];
    if (isIPHONE5) {
        btnHis.frame  = CGRectMake((XScreenWidth-35)/2, XScreenHeight-20-35-15, 35, 35);
    }
    [btnHis setImage:[UIImage imageNamed:@"history.png"] forState:UIControlStateNormal];
    [self.view addSubview:btnHis];
    UILabel *labHis = [[UILabel alloc]initWithFrame:CGRectMake((XScreenWidth-200)/2, btnHis.maxY+10, 200, 30)];
    labHis.textAlignment = NSTextAlignmentCenter;
    labHis.text = setCountry(@"wodelishishebei");
    //labHis.text = @"我的历史设备";
    labHis.textColor = [UIColor whiteColor];
    labHis.backgroundColor = CLEARCOLOR;
    labHis.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:labHis];
    [btnHis addTarget:self action:@selector(openHistory) forControlEvents:UIControlEventTouchUpInside];
    
    
}
#pragma mark 历史记录
-(void)openHistory{
    HistoryViewController *his = [[HistoryViewController alloc]init];
    [self.navigationController pushViewController:his animated:YES];
    [self.scanView stopScanQrCode];
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
        //[self.scanView startScanQrCode];
    }];
}
//从相册选出图片后
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:^{
        //code is here ...
        //[self.scanView startScanQrCode];
        
    }];
    
    UIImage *srcImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *img = [self yasuo:srcImage];
    //从图片中解析出来的
    NSString *str = [self scQRReaderForImage:img];//调用上面讲过的方法对图片中的二维码进行处理
    NSLog(@"==%@==",str);
    //解析
    str = [str stringByReplacingOccurrencesOfString:@"sn=" withString:@"***"];
    NSString *strTest = @"";
    strTest = @"***";
    str = [str stringByReplacingOccurrencesOfString:@"&wmac" withString:@"###"];
    NSRange star = [str rangeOfString:@"***"];//匹配得到的下标
    NSRange end = [str rangeOfString:@"###"];//匹配得到的下标
    NSLog(@"===str==%@",str);
    //str = [str substringWithRange:NSMakeRange(star.location+3,14)];//截取范围内的字符串
    if ([str rangeOfString:strTest].location!= NSNotFound) {
        str = [str substringWithRange:NSMakeRange(star.location+3,14)];
         [_scanView stopScanQrCode];
        [self isActivationDevice:str];
    }else{
        str = @"";
        [self setFai];
        [_scanView startScanQrCode];
    }
    
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
            if (!sender.selected) {//开着灯
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                sender.selected = YES;
                //label.text = @"轻触关闭";
                label.text = setCountry(@"qingchuguanbi");
                [YXManager share].isLight = YES;
            } else {//没开灯
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                sender.selected = NO;
                //label.text = @"轻触照亮";
                label.text = setCountry(@"qingchuzhaoliang");
                [YXManager share].isLight = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

#pragma mark - TGTScanQRCodeDelegate
- (void)getResponse:(NSString *)qrCodeString {
    if ([qrCodeString isEqualToString:@""]) {
        [self setFai];
        [_scanView startScanQrCode];
    }else{
    [_scanView stopScanQrCode];
    [self isActivationDevice:qrCodeString];
    }
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"扫描到设备：%@", qrCodeString] preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"重新扫描" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [_scanView startScanQrCode];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"连接设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        YXManager *manager = [YXManager share];
//        manager.ScanID = qrCodeString;
//        manager.isScan = YES;
//        manager.isBind = YES;
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        //储存设备sn号
//        [self saveSn];
//
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"不连接设备，直接进入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        YXManager *manager = [YXManager share];
//        manager.isBind = NO;
//        manager.isScan = YES;
//        manager.ScanID = qrCodeString;
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        //储存设备sn号
//        [self saveSn];
//
//    }]];
//    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark 判断设备是否已激活
-(BOOL)isActivationDevice:(NSString *)str{
    [self showSchdu];
    NSString *Actstr = [NSString stringWithFormat:isActiveUrl,PicHead,str];
    [NetWork sendGetNetWorkWithUrl:Actstr parameters:nil hudView:self.view successBlock:^(id data) {
        [self hideSchdu];
        NSNumber *is_active ;
        if (data[@"data"][@"device"][@"is_active"]) {
             is_active = data[@"data"][@"device"][@"is_active"];
        }
        NSLog(@"====%@===%li",data[@"data"][@"device"][@"is_active"],(long)[is_active integerValue]);
        if (!data[@"data"]) {
            _manager.isActive = NO;
        }else if ([is_active integerValue] ==0){//未激活
            _manager.isActive = NO;
        }else if ([is_active integerValue] ==1){//已激活
            _manager.isActive = YES;
        }else{
            
        }
        
        if (_manager.isActive) {//激活过
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"扫描到设备：%@", str] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:setCountry(@"chongxinsaomiao") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {//重新扫描
                [_scanView startScanQrCode];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:setCountry(@"lianjieshebei") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {//连接设备
                
                YXManager *manager = [YXManager share];
                manager.ScanID = str;
                manager.isScan = YES;
                manager.isBind = YES;
                [self.navigationController popToRootViewControllerAnimated:YES];
                //储存设备sn号
                [self saveSn];
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:setCountry(@"bulianjieshebei") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {//不连接设备，直接进入
                YXManager *manager = [YXManager share];
                manager.isBind = NO;
                manager.isScan = YES;
                manager.ScanID = str;
                [self.navigationController popToRootViewControllerAnimated:YES];
                //储存设备sn号
                [self saveSn];
                
            }]];
            [self presentViewController:alert animated:true completion:nil];
        }else{//激活设备
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:setCountry(@"tishi") message:[NSString stringWithFormat:setCountry(@"shebeiweijihuo")] preferredStyle:UIAlertControllerStyleAlert];
            //取消
            [alert addAction:[UIAlertAction actionWithTitle:setCountry(@"quxiao") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (!_manager.isStarAcan) {
                    [_scanView startScanQrCode];
                }
                
            }]];
            //确定
            [alert addAction:[UIAlertAction actionWithTitle:setCountry(@"queding") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self activationDevice:str];
            }]];
            [self presentViewController:alert animated:true completion:nil];
            
        }
        
    } failureBlock:^(NSString *error) {
        [self hideSchdu];
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:setCountry(@"cuowu") message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:setCountry(@"haode") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_scanView startScanQrCode];
        }]];
         [self presentViewController:alert animated:true completion:nil];
    }];
    
    return _manager.isActive;
}

#pragma mark 激活设备
-(void)activationDevice:(NSString *)strSN{
    [self showSchdu];
    NSString *str = [NSString stringWithFormat:ActiveDeviceUrl,PicHead,strSN];
    [NetWork sendGetNetWorkWithUrl:str parameters:nil hudView:self.view successBlock:^(id data) {
        [self hideSchdu];
        NSNumber *is_active ;
        if (data[@"data"][@"active"]) {
            is_active = data[@"data"][@"active"];
        }
        if (!data[@"data"]) {
            _manager.isActiveSuc = NO;
        }else if ([is_active integerValue] ==0){//激活失败
            _manager.isActiveSuc = NO;
        }else if([is_active integerValue] ==1){//激活成功
            _manager.isActiveSuc = YES;
        }else{
            
        }
        
        if (_manager.isActiveSuc) {//激活成功
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"激活成功!" message:@"您的共享wifi翻译机已经激活成功，现在可以开机使用了。\n免费的翻译流量从激活之日起三年有效。\n如果您需要使用wifi共享流量，请到商城中购买。各种流量包可供选择，优惠多多!!" preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"绑定设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                YXManager *manager = [YXManager share];
//                manager.ScanID = strSN;
//                manager.isScan = YES;
//                manager.isBind = YES;
//                [self.navigationController popToRootViewControllerAnimated:YES];
//                //储存设备sn号
//                [[NSUserDefaults standardUserDefaults ]setObject:manager.ScanID forKey:@"DeviceSN"];
//                //必须
//                [[NSUserDefaults standardUserDefaults]synchronize];
//
//            }]];
            [alert addAction:[UIAlertAction actionWithTitle:setCountry(@"haode") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                YXManager *manager = [YXManager share];
                manager.isBind = NO;
                manager.isScan = YES;
                manager.ScanID = strSN;
                [self.navigationController popToRootViewControllerAnimated:YES];
                //储存设备sn号
                [self saveSn];
                
            }]];
            [self presentViewController:alert animated:true completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:setCountry(@"jihuoshibai")] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:setCountry(@"queding") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [_scanView startScanQrCode];

            }]];
            [self presentViewController:alert animated:true completion:nil];
        }
        
    } failureBlock:^(NSString *error) {
        [self hideSchdu];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:setCountry(@"cuowu") message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:setCountry(@"haode") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_scanView startScanQrCode];
        }]];
         [self presentViewController:alert animated:true completion:nil];
    }];
    
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
    
    hud.color = GrayColorself;
    
    [hud showAnimated:YES];
}

-(void)hideSchdu{
    [hud hideAnimated:YES];
}

#pragma mark 存储SN
-(void)saveSn{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceStr = @"";
    NSString *strMut  = @"";
    if (![userDefaults objectForKey:@"Device"]) {
        deviceStr = [NSString stringWithFormat:@"%@*",_manager.ScanID];
        [[NSUserDefaults standardUserDefaults ]setObject:deviceStr forKey:@"Device"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else{
        deviceStr = [userDefaults objectForKey:@"Device"];
//        strMut = [deviceStr mutableCopy];
        NSLog(@"===strmut%@",deviceStr);
        if ([deviceStr containsString:_manager.ScanID]) {
            
        }else{
            strMut = [deviceStr stringByAppendingString:[NSString stringWithFormat:@"%@*",_manager.ScanID]];
            [userDefaults removeObjectForKey:@"Device"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults ]setObject:strMut forKey:@"Device"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSLog(@"===strmut%@",[userDefaults objectForKey:@"Device"]);
        }
        
//        [[NSUserDefaults standardUserDefaults ]setObject:strMut forKey:@"DeviceSN"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    //        //必须
    //        [[NSUserDefaults standardUserDefaults]synchronize];
//    BOOL isSimple=YES;
//    NSString *scanID = _manager.ScanID;
//    NSString *strr = [scanID mutableCopy];
//    //把之前拿出来，看看以前有木有
//    //创建
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        // 读取账户
//    NSMutableArray *deviceArr = [NSMutableArray arrayWithCapacity:0];
//     NSMutableArray *mutableCopyArr = [NSMutableArray arrayWithCapacity:0];
//    if (![userDefaults objectForKey:@"DeviceSN"]) {
//       // mutableCopyArr = [deviceArr mutableCopy];
//        NSArray *arr = [NSArray arrayWithObject:strr];
//       // [mutableCopyArr addObject: scanID];
//        [[NSUserDefaults standardUserDefaults ]setObject:arr forKey:@"DeviceSN"];
//        //必须
//        [[NSUserDefaults standardUserDefaults]synchronize];
//
//    }else{
//        deviceArr = [userDefaults objectForKey:@"DeviceSN"];
//        mutableCopyArr = [deviceArr mutableCopy];
//        for (NSString *str in mutableCopyArr) {
//            if ([str isEqualToString:strr]) {
//                isSimple = YES;
//                NSLog(@"==碰到一样的，跳出来==");
//                break;
//            }else{
//                NSLog(@"==碰到不一样的==");
//                isSimple = NO;
//            }
//        }
//        if (isSimple==NO) {//没有重复的
//            NSLog(@"==新的设备号==");
//            [mutableCopyArr addObject:strr];
//        }else{
//            NSLog(@"==旧的设备号==");
//        }
//        [[NSUserDefaults standardUserDefaults ]setObject:mutableCopyArr forKey:@"DeviceSN"];
//        //必须
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }

}

#pragma mark -修改成功/失败弹窗
-(void)setFai{
    CGSize contentSize = [self textConstraintSize:@"错误的二维码"];
    UIView *_hudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160,20 +50 + contentSize.height)];
    _hudView.layer.cornerRadius = 6.0f;
    _hudView.backgroundColor = [UIColor grayColor];
    _hudView.alpha = 1;
    [self.view addSubview:_hudView];
    UILabel *activityIndicatorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    activityIndicatorLabel.textAlignment = NSTextAlignmentCenter;
    [activityIndicatorLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [activityIndicatorLabel setNumberOfLines:0];
    [activityIndicatorLabel setFont:[UIFont systemFontOfSize:13]];
    activityIndicatorLabel.backgroundColor = [UIColor clearColor];
    activityIndicatorLabel.textColor = [UIColor whiteColor];
    [_hudView addSubview:activityIndicatorLabel];
    activityIndicatorLabel.frame = CGRectMake(5.0f,60.0f ,150.0f, contentSize.height);
    
    _hudView.center = CGPointMake(XScreenWidth/2, XScreenHeight/2 - 50);
    
    activityIndicatorLabel.text = @"错误的二维码";
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fasle.png"] highlightedImage:nil];
    img.frame = CGRectMake(55.0f, 10.0f, 50.0f, 50.0f);
    [_hudView addSubview:img];
    int64_t delayInSeconds = 1.5;      // 延迟的时间
    /*
     *@parameter 1,时间参照，从此刻开始计时
     *@parameter 2,延时多久，此处为秒级，还有纳秒等。10ull * NSEC_PER_MSEC
     */
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // do something
        _hudView.alpha = 0;
        [_hudView removeFromSuperview];
    });
}
- (CGSize)textConstraintSize:(NSString *)text
{
    CGSize constraint = CGSizeMake(150, 20000.0f);
    
    return [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
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
