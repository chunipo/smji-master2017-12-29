//
//  PayView.m
//  Pay
//
//  Created by Mr_怪蜀黍 on 2017/5/18.
//  Copyright © 2017年 LW. All rights reserved.
//

#import "PayView.h"
#import "YXManager.h"

@implementation PayView
{
    NSInteger index;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        index = 2;
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
        case 4:
        {
            [UIView animateWithDuration:0.3 animations:^{
                _datePicker.frame = CGRectMake(0, XScreenHeight-(260*XScreenHeight/960), XScreenWidth, 260*XScreenHeight/960);
                _LineView.frame = CGRectMake(0, XScreenHeight-(260*XScreenHeight/960)-60, XScreenWidth, 60);
            }];
            break;
        }
        case 5:
        {
            [UIView animateWithDuration:0 animations:^{
                _datePicker.frame = CGRectMake(0, XScreenHeight, XScreenWidth, 0);
                _LineView.frame = CGRectMake(0, XScreenHeight, XScreenWidth, 0);
            }];
        
            break;
        }
        case 6:
        {
            [UIView animateWithDuration:0 animations:^{
                _datePicker.frame = CGRectMake(0, XScreenHeight, XScreenWidth, 0);
                _LineView.frame = CGRectMake(0, XScreenHeight, XScreenWidth, 0);
            }];
            NSDate *date = _datePicker.date; // 获得时间对象
            NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
            //[forMatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [forMatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [forMatter stringFromDate:date];
            [YXManager share].TimeStr = dateStr;
            _starTimeLabel.text = [NSString stringWithFormat:@"生效时间：%@ ",dateStr];
            break;
        }
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
        //make.centerX.mas_equalTo(self);
        make.top.offset(30);
    }];
    UIImageView *hLinView2 = [UIImageView horizontalSeparateImageView];
    [self addSubview:hLinView2];
    [hLinView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.height.offset(1);
        make.right.offset(-10);
        make.top.equalTo(weakself.titleLabel.mas_bottom).offset(4);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.titleLabel);
        //make.centerX.equalTo(self).offset(-20);
        make.top.equalTo(weakself.titleLabel.mas_bottom).offset(17);
    }];
    
    [self.subPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.priceLabel.mas_right);
        //make.centerX.mas_equalTo(self);
        make.top.equalTo(weakself.titleLabel.mas_bottom).offset(17);
    }];
    UIImageView *hLinView3 = [UIImageView horizontalSeparateImageView];
    [self addSubview:hLinView3];
    [hLinView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.height.offset(1);
        make.right.offset(-10);
        make.top.equalTo(weakself.priceLabel.mas_bottom).offset(4);
    }];
    
    [self.deviceSSID mas_makeConstraints:^(MASConstraintMaker *make) {//设备ssid
        make.left.offset(10);
        //make.centerX.mas_equalTo(self);
        make.top.equalTo(weakself.priceLabel.mas_bottom).offset(17);
    }];
    UIImageView *hLinView4 = [UIImageView horizontalSeparateImageView];
    [self addSubview:hLinView4];
    [hLinView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.height.offset(1);
        make.right.offset(-10);
        make.top.equalTo(weakself.deviceSSID.mas_bottom).offset(4);
    }];
    
    [self.starTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {//有效时间
        make.left.equalTo(weakself.titleLabel);
        //make.centerX.mas_equalTo(self);
        make.top.equalTo(weakself.deviceSSID.mas_bottom).offset(30);
    }];
    
    [self.clickOpenTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {//打开选择器
        make.right.equalTo(self).offset(-10);
        //make.centerX.mas_equalTo(self);
        make.top.equalTo(weakself.deviceSSID.mas_bottom).offset(22);
        make.width.mas_equalTo(100);
    }];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {//选择器
        make.left.equalTo(0);
        make.right.equalTo(0);
        //make.top.equalTo(weakself.titleLabel.mas_bottom).offset(17);
        make.bottom.equalTo(0);
        make.height.mas_equalTo(0);
    }];
    [self.LineView mas_makeConstraints:^(MASConstraintMaker *make) {//选择器
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(weakself.datePicker.mas_bottom).offset(0);
        make.height.mas_equalTo(0);
    }];
    [self.canselButton mas_makeConstraints:^(MASConstraintMaker *make) {//选择器取消按钮
        make.left.mas_equalTo(15);
        //make.right.equalTo(0);
        make.top.mas_equalTo(12);
        make.width.mas_equalTo(60);
    }];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {//选择器确定按钮
        //make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(12);
        make.width.mas_equalTo(60);
    }];
    
    UIImageView *hLinView = [UIImageView horizontalSeparateImageView];
    [self addSubview:hLinView];
    [hLinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.height.offset(8);
        make.right.offset(0);
        make.top.equalTo(weakself.clickOpenTimeButton.mas_bottom).offset(10);
    }];
    
    
    [self.alipayImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(hLinView.mas_bottom).offset(0);
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
    UIImageView *weixinLineTop = [UIImageView horizontalSeparateImageView];
    [self addSubview:weixinLineTop];
    [weixinLineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.height.offset(1);
        make.right.offset(0);
        make.bottom.equalTo(weakself.weixinImage.mas_top).offset(-15);
    }];
    UIImageView *weixinLineBottom = [UIImageView horizontalSeparateImageView];
    [self addSubview:weixinLineBottom];
    [weixinLineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.height.offset(1);
        make.right.offset(0);
        make.top.equalTo(weakself.weixinImage.mas_bottom).offset(15);
    }];

    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-40);
        make.left.offset(55/2);
        make.right.offset(-55/2);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark --懒加载
-(UILabel *)deviceSSID
{
    
    if (!_deviceSSID) {
        _deviceSSID = [UILabel labelWithText:[NSString stringWithFormat:@"%@  %@",setCountry(@"shebeissid"),[YXManager share].ScanID]  atColor:Black_Color atTextSize:15 atTextFontForType:Common_Font];
        [self addSubview:_deviceSSID];
    }
    return _deviceSSID;
}
-(UILabel *)titleLabel
{
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@：%@",setCountry(@"changpinmincheng"),[YXManager share].OrderName]  atColor:Black_Color atTextSize:15 atTextFontForType:Common_Font];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UILabel *)priceLabel
{
    if (!_priceLabel) {
        NSString *MoneyType;
        if ([[YXManager share].TrueLanguageStr containsString:@"zh-H"]) {
            MoneyType = @"￥";
        }else if([[YXManager share].TrueLanguageStr containsString:@"ja"]){
            MoneyType = @"JPY";
        }else{
            MoneyType = @"$";
        }
        _priceLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@： %@ ",setCountry(@"chanpinjiage"),MoneyType] atColor:Black_Color atTextSize:15 atTextFontForType:Common_Font];
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

-(UILabel *)subPriceLabel
{
    if (!_subPriceLabel) {
        _subPriceLabel = [UILabel labelWithText:[YXManager share].OrderPrice atColor:Red_Color atTextSize:15 atTextFontForType:Common_Font];
        [self addSubview:_subPriceLabel];
    }
    return _subPriceLabel;
}

-(UILabel *)starTimeLabel{
    if (!_starTimeLabel) {
        NSDate *date = [NSDate date]; // 获得时间对象
        NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
        //[forMatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [forMatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [forMatter stringFromDate:date];
        [YXManager share].TimeStr = dateStr;
        _starTimeLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@：%@ ",setCountry(@"shengxiaoshijian"),dateStr] atColor:Black_Color atTextSize:15 atTextFontForType:Common_Font];
        [self addSubview:_starTimeLabel];
    }
    return _starTimeLabel;
}

-(UIButton *)clickOpenTimeButton
{
    if (!_clickOpenTimeButton) {
        _clickOpenTimeButton = [UIButton buttonWithTitle:@"修改日期" atNormalImageName:nil atSelectedImageName:nil atTarget:self atAction:@selector(buttonAction:)];
        _clickOpenTimeButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _clickOpenTimeButton.tag = 4;
        _clickOpenTimeButton.layer.borderWidth = 1;
        _clickOpenTimeButton.layer.borderColor =[UIColor colorWithRed:252.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1].CGColor;
        _clickOpenTimeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [_clickOpenTimeButton setTitleColor: [UIColor colorWithRed:252.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1] forState:UIControlStateNormal];
        _clickOpenTimeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_clickOpenTimeButton];
    }
    return _clickOpenTimeButton;
}
//选择器上的线
-(UIView *)LineView{
    if (!_LineView) {
        _LineView = [[UIView alloc]init];
        _LineView.backgroundColor = [UIColor grayColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_LineView];
    }
    return _LineView;
}

-(UIButton *)canselButton{
    if (!_canselButton) {
        _canselButton = [UIButton buttonWithTitle:@"取消" atNormalImageName:nil atSelectedImageName:nil atTarget:self atAction:@selector(buttonAction:)];
        _canselButton.tag = 5;
        [_canselButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _canselButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_LineView addSubview:_canselButton];
    }
    return _canselButton;
}
-(UIButton *)okButton{
    if (!_okButton) {
        _okButton = [UIButton buttonWithTitle:@"确定" atNormalImageName:nil atSelectedImageName:nil atTarget:self atAction:@selector(buttonAction:)];
        _okButton.tag = 6;
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _okButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_LineView addSubview:_okButton];
    }
    return _okButton;
}

-(UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]init];
        _datePicker.backgroundColor = GrayColorself;
        //_datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:7];//设置最大时间为：当前时间推后十年
        NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [comps setYear:0];//设置最小时间为：当前时间前推十年
        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [_datePicker setMaximumDate:maxDate];
        [_datePicker setMinimumDate:minDate];
        [[UIApplication sharedApplication].keyWindow addSubview:_datePicker];
    }
    
    return _datePicker;
}

-(UIImageView *)alipayImage
{
    if (!_alipayImage) {
        _alipayImage = [UIImageView imageViewWithImageName:@"Icon-Paypal"];
        _alipayImage.alpha = 0;
        [self addSubview:_alipayImage];
    }
    return _alipayImage;
}

-(UILabel *)alipayLabel
{
    if (!_alipayLabel) {
        _alipayLabel = [UILabel labelWithText:@"Paypal支付" atColor:Black_Color atTextSize:15 atTextFontForType:Common_Font];
        _alipayLabel.alpha = 0;
        [self addSubview:_alipayLabel];
    }
    return _alipayLabel;
}


-(UIButton *)alipayButton
{
    if (!_alipayButton) {
        _alipayButton = [UIButton buttonWithTitle:nil atNormalImageName:@"icon_Ticking_gray" atSelectedImageName:@"icon_Ticking" atTarget:self atAction:@selector(buttonAction:)];
        //_alipayButton.selected = YES;
        _alipayButton.tag = 1;
        _alipayButton.alpha = 0;
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
        _weixinButton.selected = YES;
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
        //[_payButton setBackgroundImage:UIImageName(@"button_bg_red") forState:UIControlStateNormal];
        _payButton.backgroundColor = BlueColor;
        _payButton.layer.cornerRadius = 15;
        [self addSubview:_payButton];
    }
    return _payButton;
}




@end
