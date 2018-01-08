//
//  ScanView.m
//  TGTWiFi
//
//  Created by TGT-Tech on 16/11/15.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import "ScanView.h"
#import "YXManager.h"

#define XCenter self.center.x
#define SWidth (300)



@interface ScanView() <AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate> {
    
    UIView      *_qrBgView;
    UIImageView *_qrLine;
    NSTimer     *timer;
    int         num;
    BOOL        upOrdown;
    
    UIButton    *btn;
    UILabel     *_Openlabel;
}
@property (strong,nonatomic) AVCaptureDevice *device;
@property (strong,nonatomic) AVCaptureDeviceInput *input;
@property (strong,nonatomic) AVCaptureMetadataOutput *output;
@property (strong,nonatomic) AVCaptureSession *session;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation ScanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _initView];
        [self creatScanSession];
        [self OpenLightBtn];
    }
    return self;
}
- (void)_initView {
    
    _qrBgView = [[UIView alloc] initWithFrame:CGRectMake((XScreenWidth-SWidth)/2,(XScreenHeight-SWidth)/2,SWidth,SWidth)];
    [self addSubview:_qrBgView];
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i % 2 * (SWidth - 16), i / 2 * (SWidth - 16), 16, 16)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ScanQR%d",i+1]];
        [_qrBgView addSubview:imageView];
    }
    _qrLine = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, SWidth - 40, 1)];
    _qrLine.image = [UIImage imageNamed:@"qrcode_scan_line.png"];
    [_qrBgView addSubview:_qrLine];
    // 初始
    upOrdown = NO;
    num =0;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _qrBgView.maxY + 20, XScreenWidth, 40)];
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.text = @"请将途鸽翻译机设备二维码/条形码放入框内,即可自动扫描并绑定/激活设备";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    [self addSubview:tipLabel];
    
    
}



- (void)creatScanSession {
    AVCaptureVideoDataOutput *lightOutput = [[AVCaptureVideoDataOutput alloc] init];
    [lightOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    _output.rectOfInterest =[self rectOfInterestByScanViewRect:_qrBgView.frame];
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
        [_session addOutput:lightOutput];
    }
    
    // 条码类型
    _output.metadataObjectTypes =@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResize;
    _preview.frame =self.bounds;
    [self.layer insertSublayer:self.preview atIndex:0];
    [self bringSubviewToFront:_qrBgView];
    [self setOverView];
    // Start
    [self startScanQrCode];
    
//    NSError *error;
//    if (_device.hasTorch) {  // 判断设备是否有闪光灯
//        BOOL b = [_device lockForConfiguration:&error];
//        if (!b) {
//            if (error) {
//                NSLog(@"lock torch configuration error:%@", error.localizedDescription);
//            }
//            return;
//        }
//        _device.torchMode = (_device.torchMode == AVCaptureTorchModeOff ? AVCaptureTorchModeOn : AVCaptureTorchModeOff);
//        [_device unlockForConfiguration];
//    }

}

#pragma mark 创建手电筒
-(void)OpenLightBtn{
    btn = [[UIButton alloc]initWithFrame:CGRectMake(XScreenWidth/2-25/2,_qrBgView.maxY-70, 25, 25)];
    [btn setImage:[UIImage imageNamed:@"light"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"click"] forState:UIControlStateSelected];
    [self addSubview:btn];
    btn.alpha = 0;
    [btn addTarget:self action:@selector(clickLightBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _Openlabel = [[UILabel alloc]initWithFrame:CGRectMake(XScreenWidth/2-50/2, btn.maxY+5, 50, 30)];
    _Openlabel.text = @"轻触照亮";
    _Openlabel.textColor = [UIColor whiteColor];
    _Openlabel.backgroundColor = CLEARCOLOR;
    [self addSubview:_Openlabel];
    _Openlabel.alpha = btn.alpha;
    _Openlabel.font = [UIFont systemFontOfSize:12];
    _Openlabel.textAlignment = NSTextAlignmentCenter;
    
    
}
- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGFloat width = XScreenWidth;
    CGFloat height = XScreenHeight;
    
    CGFloat x = ((height - CGRectGetHeight(rect)) / 2) / height;
    CGFloat y =  (width - CGRectGetWidth(rect)) / 2 / width;
    
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
    
    return CGRectMake(x, y, w, h);
}
#pragma mark - 添加模糊效果
- (void)setOverView {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat x = CGRectGetMinX(_qrBgView.frame);
    CGFloat y = CGRectGetMinY(_qrBgView.frame);
    CGFloat w = CGRectGetWidth(_qrBgView.frame);
    CGFloat h = CGRectGetHeight(_qrBgView.frame);
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
}
- (void)creatView:(CGRect)rect {
    CGFloat alpha = 0.5;
    UIColor *backColor = [UIColor darkGrayColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self addSubview:view];
}
// 开始扫描
- (void)startScanQrCode {
    [_session startRunning];
    timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(qrLineAnimation) userInfo:nil repeats:YES];
}
// 停止扫描
- (void)stopScanQrCode {
    [_session stopRunning];
    [timer invalidate];
}
// 扫描动画
- (void)qrLineAnimation {
    _qrLine.hidden = NO;
    if (upOrdown == NO) {
        num ++;
        _qrLine.frame = CGRectMake(20, 2*num, SWidth - 40, 2);
        if (2*num >= SWidth-1) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _qrLine.frame = CGRectMake(20, 2*num, SWidth - 40, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0) {
        // 停止扫描
        [self stopScanQrCode];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        // 输出扫描字符串
        NSLog(@"%@===metadataObjects==%@",metadataObject.stringValue,metadataObjects);
        //扫描二维码使用的~
        NSString *str = metadataObject.stringValue;
        if ([[metadataObject type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            str = [str stringByReplacingOccurrencesOfString:@"sn=" withString:@"***"];
            str = [str stringByReplacingOccurrencesOfString:@"＆wmac" withString:@"###"];
            NSRange star = [str rangeOfString:@"***"];//匹配得到的下标
            NSRange end = [str rangeOfString:@"###"];//匹配得到的下标
            NSLog(@"===str==%@",str);
            str = [str substringWithRange:NSMakeRange(star.location+3,14)];//截取范围内的字符串
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(getResponse:)]) {
                [self.delegate getResponse:str];
            }
        }else {
            if ([str hasPrefix:@"TGT"]) {
                if (self.delegate != nil && [self.delegate respondsToSelector:@selector(getResponse:)]) {
                    [self.delegate getResponse:str];
                }
            }else{
                
            }
        }
        
        
        
    }
}

#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        
        CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
        NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
        CFRelease(metadataDict);
        NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
        float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
        
        NSLog(@"%f",brightnessValue);
        
        // 根据brightnessValue的值来打开和关闭闪光灯
        AVCaptureDevice * myLightDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        BOOL result = [myLightDevice hasTorch];// 判断设备是否有闪光灯
        if ((brightnessValue < -2) && result) {// 打开闪光灯
//            [myLightDevice lockForConfiguration:nil];
//            [myLightDevice setTorchMode: AVCaptureTorchModeOn];//开
//            [myLightDevice unlockForConfiguration];
            [self showLight];
            NSLog(@"闪关灯打开");
            
        }else if((brightnessValue > -2) && result) {// 关闭闪光灯
            //[myLightDevice lockForConfiguration:nil];
            // [myLightDevice setTorchMode: AVCaptureTorchModeOff];
            //[myLightDevice unlockForConfiguration];
            [self hideLight];
             NSLog(@"闪关灯关闭");
        }
    }
}

/**
 *  开启/关闭手电筒
 */
- (void)clickLightBtn:(UIButton *)sender {
    if ([self.Opendelegate respondsToSelector:@selector(buttonBeTouched: view:)]) {
        [self.Opendelegate buttonBeTouched:sender view:_Openlabel];
    }
}

-(void)showLight{
    [UIView animateWithDuration:0.5 animations:^{
        btn.alpha = 1;
        _Openlabel.alpha = btn.alpha;
    }];
    
}

-(void)hideLight{
    if (![YXManager share].isLight) {
        [UIView animateWithDuration:0.5 animations:^{
            btn.alpha = 0;
            _Openlabel.alpha = btn.alpha;
        }];
    }
   
}




@end
