//
//  PayView.h
//  Pay
//
//  Created by Mr_怪蜀黍 on 2017/5/18.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PayView;
@protocol PayViewDelegate <NSObject>

/**支付  1支付宝  2 微信*/
-(void)InitiatePaymentWithPayType:(NSInteger )type;

/*点击展示订单全称的代理噢*/
-(void)ShowOrderName:(NSString*)OrderName andProduct:(NSString *)dingdanming;
@end

@interface PayView : UIView

@property (nonatomic, weak) id<PayViewDelegate>delegate;
/**设备ssid*/
@property (nonatomic, strong)UILabel *deviceSSID;
/**订单名*/
@property (nonatomic, strong)UILabel *titleLabel;

/**订单金额*/
@property (nonatomic, strong)UILabel *priceLabel;
/**订单金额 $*/
@property (nonatomic, strong)UILabel *subPriceLabel;
/*订单开始时间*/
@property (nonatomic, strong)UILabel *starTimeLabel;
/*点击时间选择按钮*/
@property (nonatomic, strong)UIButton *clickOpenTimeButton;
/*时间选择器上的白色跳条条*/
@property (nonatomic, strong)UIView *LineView;
@property (nonatomic, strong)UIButton *okButton;
@property (nonatomic, strong)UIButton *canselButton;
/**时间选择器*/
@property (nonatomic, strong)UIDatePicker *datePicker;

/**支付宝支付*/
@property (nonatomic, strong)UIImageView *alipayImage;
@property (nonatomic, strong)UILabel *alipayLabel;
@property (nonatomic, strong)UIButton *alipayButton;
/**微信支付*/
@property (nonatomic, strong)UIImageView *weixinImage;
@property (nonatomic, strong)UILabel *weixinLabel;
@property (nonatomic, strong)UIButton *weixinButton;
/**支付*/
@property (nonatomic, strong)UIButton *payButton;

@end
