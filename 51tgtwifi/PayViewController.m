//
//  PayViewController.m
//  51tgtwifi
//
//  Created by TGT on 2017/10/23.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "PayViewController.h"
#import "PayView.h"
#import "WXApi.h"
#import "WeChatOrderModel.h"

@interface PayViewController ()<PayViewDelegate,PayPalPaymentDelegate,WXApiDelegate>

@property (nonatomic, strong)PayView *payView;

/***paypal 支付对象***/
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

/**PayPal预支付订单ID*/
@property (nonatomic, strong)NSString *paypalOrderId;
/**PayPal支付成功返回的订单ID*/
@property (nonatomic, strong)NSString *paymentId;




/***微信***／

/*** 随机串，防重发 ***/
@property (nonatomic, strong)NSString *noncestr;
/**商家根据财付通文档填写的数据和签名*/
@property (nonatomic, strong)NSString *package;
/**商家向财付通申请的商家id*/
@property (nonatomic, strong)NSString *partnerid;
/**商家根据微信开放平台文档对数据做的签名*/
@property (nonatomic, strong)NSString *paySign;
/**预支付订单*/
@property (nonatomic, strong)NSString *prepayid;
/**时间戳，防重发*/
@property (nonatomic, strong)NSString *timestamp;
/** 微信支付model */
@property (nonatomic,strong)WeChatOrderModel * weChatSing;



@end

@implementation PayViewController
{
    BOOL _isReceiveNotification;//是否接收到充值通知
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXpayNotification) name:@"WXpayNotification" object:nil];
    //    标题栏
    [self HeadTitle];
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.payView];
    
}

#pragma mark -- paypal支付
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
        //是否使用信用卡
        _payPalConfiguration.acceptCreditCards = NO;
        _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
        //配置语言环境
        _payPalConfiguration.languageOrLocale = [NSLocale preferredLanguages][0];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Start out working with the test environment! When you are ready, switch to PayPalEnvironmentProduction.
    /// 真实交易环境-也就是上架之后的环境
    //extern NSString * _Nonnull const PayPalEnvironmentProduction;
    /// 模拟环境-也就是沙盒环境
    //extern NSString * _Nonnull const PayPalEnvironmentSandbox;
    /// 无网络连接环境-具体用处
    //extern NSString * _Nonnull const PayPalEnvironmentNoNetwork;
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
}


#pragma mark - 创建标题栏
-(void)HeadTitle{
    UIImageView *backgroud = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, XScreenWidth,XScreenHeight)];
    
    backgroud.image = [UIImage imageNamed:@"ic_bg.jpg"];
    
    [self.view addSubview:backgroud];
    UIImageView *backgroud2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20+X_bang+60, XScreenWidth,XScreenHeight)];
    
    backgroud2.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:backgroud2];
    
    
    
    UIView *_TitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 20+X_bang, XScreenWidth, 60)];
    _TitleView.userInteractionEnabled = YES;
    _TitleView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_TitleView];
    
    UILabel *TitleText = [UILabel new];
    [_TitleView addSubview:TitleText];
    
    TitleText.text = @"支付订单";
    TitleText.textColor = [UIColor whiteColor];
    
    [TitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(_TitleView);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    TitleText.textAlignment = NSTextAlignmentCenter;
    
    
    
    //    取消按钮
    UIButton *btn = [UIButton new];
    [_TitleView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_TitleView).offset(0);
        
        make.centerY.equalTo(TitleText);
        
        make.size.mas_equalTo(CGSizeMake(80, 80));
        
        
    }];
    
    btn.tag = 101;
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)click:(UIButton *)btn{
    if (btn.tag==101) {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

#pragma mark - --微信支付成功回调
-(void)WXpayNotification
{
    if (_isReceiveNotification==NO) {
        /*订单支付成功 */
        /**更新UI*/
        _isReceiveNotification=YES;
    }else{
        _isReceiveNotification=YES;
    }
}


/***1 支付宝支付   2微信支付*/
-(void)InitiatePaymentWithPayType:(NSInteger)type
{
    
    //    userId	string	是		1
    //    accessToken	string	是		394799fbc87b6a8364afa2b09558475a
    //    busId	string	是	业务ID	1
    
    //    type	string	是	支付类型：0-支付宝 1-微信 2-PayPal 3-内购	0
    //    money	string	是	支付金额	2
    

    if (type==1) {
//        [mutDic setObject:@"0" forKey:@"type"];
        
        [self payPal];
        
    }else if (type==2){
        [self weixinPay];
//        [mutDic setObject:@"1" forKey:@"type"];
    }


}


-(void)weixinPay
{
    //测试数据
    self.noncestr = @"xV04rlEmretLE7QsO4zD3BIWcbQQRyig";
    self.package = @"Sign=WXPay";
    self.partnerid = @"1447899502";
    self.paySign = @"B7D0E78A32C47056B8019FE1D7749437";
    self.prepayid = @"wx201705101116004d23fa269b0224245096";
    self.timestamp = @"1494386160";
    //获取当前的时间戳
    if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
    {
        PayReq *request = [[PayReq alloc] init];
        /** 商家向财付通申请的商家id */
        request.partnerId = self.partnerid;
        /** 预支付订单 */
        request.prepayId= self.prepayid;
        /** 商家根据财付通文档填写的数据和签名 */
        request.package = self.package;
        /** 随机串，防重发 */
        request.nonceStr=self.noncestr ;
        /** 时间戳，防重发 */
        request.timeStamp = self.timestamp.intValue;
        /** 商家根据微信开放平台文档对数据做的签名 */
        request.sign = self.paySign;
        [WXApi sendReq:request];
    }else{
        /**未安装微信*/
        [MBProgressHUD showError:@"您未安装微信"];
    }

    
}


-(void)payPal{

    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:@"0.01"];//金额
    payment.currencyCode = @"USD";//货币类型
    payment.shortDescription = @"100M 流量";
    payment.intent = PayPalPaymentIntentSale;
    //传入订单ID  后台生成
    self.paypalOrderId = @"1";
    PayPalItem *palltem = [PayPalItem itemWithName:self.paypalOrderId withQuantity:1 withPrice:payment.amount withCurrency:@"USD" withSku:self.paypalOrderId];
    NSArray *array = [NSArray arrayWithObjects:palltem, nil];
    payment.items = array;
    payment.shippingAddress = nil;//收货地址
    //检查付款是否可行
    if (!payment.processable) {
        //不能发起支付
        NSLog(@"／*不能支付*／");
    }
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfiguration delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];


}


//-(void)payPal{
//    //    配置支付环境
//    
//    
//    /// 真实交易环境-也就是上架之后的环境
//    extern NSString * _Nonnull const PayPalEnvironmentProduction;
//    /// 模拟环境-也就是沙盒环境
//    extern NSString * _Nonnull const PayPalEnvironmentSandbox;
//    /// 无网络连接环境-具体用处，咳咳，自行摸索
//    extern NSString * _Nonnull const PayPalEnvironmentNoNetwork;
//    
//    
//    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
//    
//    
//    
//    
//    //是否接受信用卡
//    _payPalConfig.acceptCreditCards = YES;
//    
//    //商家名称
//    _payPalConfig.merchantName = @"商家号";
//    
//    //商家隐私协议网址和用户授权网址-说实话这个没用到
//    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
//    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
//    
//    //设置地址选项-在支付页面可选择账户地址信息
//    typedef NS_ENUM(NSInteger, PayPalShippingAddressOption) {
//        //不展示地址信息 选这个好像支付不成功
//        PayPalShippingAddressOptionNone = 0,
//        //这个没试过，自行查阅
//        PayPalShippingAddressOptionProvided = 1,
//        //paypal账号下的地址信息
//        PayPalShippingAddressOptionPayPal = 2,
//        //全选
//        PayPalShippingAddressOptionBoth = 3,
//    };
//    
//    //paypal账号下的地址信息
//    _payPalConfig.payPalShippingAddressOption = 2;
//    
//    //配置语言环境
//    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
//    
//    
//    //    配置支付相关信息
//    
//    
//    PayPalPayment *payment = [[PayPalPayment alloc] init];
//    
//    //订单总额
//    payment.amount = [NSDecimalNumber decimalNumberWithString:@"100"];
//    
//    //货币类型-RMB是没用的
//    payment.currencyCode = @"USD";
//    
//    //订单描述
//    payment.shortDescription = @"100M流量";
//    
//    
//    
////    PayPalPayment *payment = [[PayPalPayment alloc] init];
////    payment.amount = [[NSDecimalNumber alloc] initWithString:@"99"];//金额
////    payment.currencyCode = @"USD";//货币类型
////    payment.shortDescription = @"100M流量";
//////    payment.intent = PayPalPaymentIntentSale;
////    //传入订单ID  后台生成
////    self.paypalOrderId = @"1";
////    PayPalItem *palltem = [PayPalItem itemWithName:self.paypalOrderId withQuantity:1 withPrice:payment.amount withCurrency:@"USD" withSku:self.paypalOrderId];
////    NSArray *array = [NSArray arrayWithObjects:palltem, nil];
////    payment.items = array;
////    payment.shippingAddress = nil;//收货地址
////    //检查付款是否可行
////    if (!payment.processable) {
////        //不能发起支付
////    }
//    //    第四步：提交订单-最重要也是最简单的一步 r
//    
//    
//    //生成paypal控制器，并模态出来(push也行)
//    //将之前生成的订单信息和paypal配置传进来，并设置订单VC为代理
//    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment                                                                                            configuration:self.payPalConfig                                                                                                  delegate:self];
//    
//    //模态展示
//    [self presentViewController:paymentViewController animated:YES completion:nil];
//    
//    //    [self.navigationController pushViewController:paymentViewController animated:YES];
//    
//    
//    
//    
//}

//监测订单状态



#pragma mark - PayPalPaymentDelegate

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    //付款成功 通知服务器
    NSLog(@"支付成功！PayPal Payment Success!");
    [self verifyCompletedPayment:completedPayment];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
        NSLog(@"PayPal Payment Canceled");
    //付款已取消
    [self dismissViewControllerAnimated:YES completion:nil];
}

//向服务器发送支付成功、支付失败等信息请求
- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    // Send the entire confirmation dictionary
    NSDictionary *confirmation = completedPayment.confirmation;
    self.paymentId = [confirmation[@"response"]objectForKey:@"id"];
    //NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation options:0 error:nil];
    //通知客户端 发送支付信息
          NSLog(@"通知服务器");
    
}


//向服务器发送一些东西，让服务器验证本次订单有效性
//回调的 PayPalPayment 的 confirmation 属性包含此次订单的状态信息包括校验码，服务器可已通过该校验码验证交易真实性。
//返回数据 - id所对应的就是校验码。
//{
//    client =     {
//        environment = sandbox;
//        "paypal_sdk_version" = "2.14.2";
//        platform = iOS;
//        "product_name" = "PayPal iOS SDK";
//    };
//    response =     {
//        "create_time" = "2016-05-12T03:25:49Z";
//        id = "PAY-6BG56850AF923584SK4Z7PNQ";
//        intent = sale;
//        state = approved;
//    };
//    "response_type" = payment;
//}





-(PayView *)payView
{
    if (!_payView) {
        _payView = [[PayView alloc]initWithFrame:CGRectMake(0, 60+X_bang, XScreenWidth, XScreenHeight-64)];
        _payView.delegate = self;
       
    }
    return _payView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
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
