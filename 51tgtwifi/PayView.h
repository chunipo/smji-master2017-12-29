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

@end

@interface PayView : UIView

@property (nonatomic, weak) id<PayViewDelegate>delegate;

/**订单名*/
@property (nonatomic, strong)UILabel *titleLabel;
/**订单金额*/
@property (nonatomic, strong)UILabel *priceLabel;
/**订单金额 $*/
@property (nonatomic, strong)UILabel *subPriceLabel;
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
