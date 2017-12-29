//
//  ScanView.h
//  TGTWiFi
//
//  Created by TGT-Tech on 16/11/15.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMetadataObject.h>
#import <AVFoundation/AVCaptureOutput.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <AVFoundation/AVMediaFormat.h>

@protocol TGTScanQRCodeDelegate <NSObject>

- (void)getResponse:(NSString *)qrCodeString;

@end

@interface ScanView : UIView

@property (nonatomic,assign) id<TGTScanQRCodeDelegate> delegate;

// 开始扫描
- (void)startScanQrCode;
// 停止扫描
- (void)stopScanQrCode;

@end
