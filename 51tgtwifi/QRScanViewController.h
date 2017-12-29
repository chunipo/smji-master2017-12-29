//
//  QRScanViewController.h
//  TGTOrderSystem
//
//  Created by TGT-Tech on 16/12/29.
//  Copyright © 2016年 TGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>

@protocol QrCodeResponseDelegate <NSObject>
- (void)getQrCodeResponse:(NSString *)qrCodeString;
@end

@interface QRScanViewController : UIViewController
@property (nonatomic,assign) id<QrCodeResponseDelegate> delegate;
@end
