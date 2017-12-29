//
//  PayView.m
//  Pay
//
//  Created by Mr_怪蜀黍 on 2017/5/18.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "PayView.h"

@implementation PayView
{
    NSInteger index;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        index = 1;
        [self setSubLayout];
    }
    return self;
}

-(void)buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case 1:
            index = 1;
            self.alipayButton.selected = YES;
            self.weixinButton.selected = NO;
            break;
        case 2:
             index = 2;
            self.alipayButton.selected = NO;
            self.weixinButton.selected = YES;
            break;
        case 3:
            if ([self.delegate respondsToSelector:@selector(InitiatePaymentWithPayType:)]) {
                [self.delegate InitiatePaymentWithPayType:index];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark--懒加载
-(void)setSubLayout
{
    WS(weakself);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(30);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLabel);
        make.top.equalTo(weakself.titleLabel.mas_bottom).offset(17);
    }];
    
    [self.subPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.priceLabel.mas_right);
        make.top.equalTo(weakself.priceLabel);
    }];
    
    UIImageView *hLinView = [UIImageView horizontalSeparateImageView];
    [self addSubview:hLinView];
    [hLinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLabel);
        make.height.offset(1);
        make.right.offset(-10);
        make.top.equalTo(weakself.priceLabel.mas_bottom).offset(30);
    }];
    
    [self.alipayImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(hLinView.mas_bottom).offset(40);
    }];
    [self.alipayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.alipayImage);
        make.left.equalTo(weakself.alipayImage.mas_right).offset(16);
    }];
    [self.alipayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.equalTo(weakself.alipayImage);
    }];
    
    [self.weixinImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.alipayImage);
        make.top.equalTo(weakself.alipayImage.mas_bottom).offset(40);
    }];
    [self.weixinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.weixinImage);
        make.left.equalTo(weakself.weixinImage.mas_right).offset(20);
    }];
    [self.weixinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.equalTo(weakself.weixinImage);
    }];

    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-40);
        make.left.offset(55/2);
        make.right.offset(-55/2);
    }];
}

#pragma mark --懒加载
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:@"订单名称：100M流量" atColor:Black_Color atTextSize:15 atTextFontForType:Common_Font];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [UILabel labelWithText:@"订单价格：" atColor:Black_Color atTextSize:15 atTextFontForType:Common_Font];
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

-(UILabel *)subPriceLabel
{
    if (!_subPriceLabel) {
        _subPriceLabel = [UILabel labelWithText:@"￥0.01" atColor:Red_Color atTextSize:15 atTextFontForType:Common_Font];
        [self addSubview:_subPriceLabel];
    }
    return _subPriceLabel;
}

-(UIImageView *)alipayImage
{
    if (!_alipayImage) {
        _alipayImage = [UIImageView imageViewWithImageName:@"Icon-Paypal"];
        [self addSubview:_alipayImage];
    }
    return _alipayImage;
}

-(UILabel *)alipayLabel
{
    if (!_alipayLabel) {
        _alipayLabel = [UILabel labelWithText:@"Paypal支付" atColor:Black_Color atTextSize:15 atTextFontForType:Common_Font];
        [self addSubview:_alipayLabel];
    }
    return _alipayLabel;
}


-(UIButton *)alipayButton
{
    if (!_alipayButton) {
        _alipayButton = [UIButton buttonWithTitle:nil atNormalImageName:@"icon_Ticking_gray" atSelectedImageName:@"icon_Ticking" atTarget:self atAction:@selector(buttonAction:)];
        _alipayButton.selected = YES;
        _alipayButton.tag = 1;
        [self addSubview:_alipayButton];
    }
    return _alipayButton;
}

-(UIImageView *)weixinImage
{
    if (!_weixinImage) {
        _weixinImage = [UIImageView imageViewWithImageName:@"iocn_weixin_green"];
        [self addSubview:_weixinImage];
    }
    return _weixinImage;
}

-(UILabel *)weixinLabel
{
    if (!_weixinLabel) {
        _weixinLabel = [UILabel labelWithText:@"微信支付" atColor:Black_Color atTextSize:15 atTextFontForType:Common_Font];
        [self addSubview:_weixinLabel];
    }
    return _weixinLabel;
}

-(UIButton *)weixinButton
{
    if (!_weixinButton) {
        _weixinButton = [UIButton buttonWithTitle:nil atNormalImageName:@"icon_Ticking_gray" atSelectedImageName:@"icon_Ticking" atTarget:self atAction:@selector(buttonAction:)];
        _weixinButton.tag = 2;
        [self addSubview:_weixinButton];
    }
    return _weixinButton;
}

-(UIButton *)payButton
{
    if (!_payButton) {
        _payButton = [UIButton buttonWithTitle:@"去支付" atTitleSize:18 atTitleColor:White_Color atTarget:self atAction:@selector(buttonAction:)];
        _payButton.tag = 3;
        [_payButton setBackgroundImage:UIImageName(@"button_bg_red") forState:UIControlStateNormal];
        [self addSubview:_payButton];
    }
    return _payButton;
}

@end
