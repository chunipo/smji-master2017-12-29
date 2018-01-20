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
#import "YXManager.h"

@interface PayViewController ()<PayViewDelegate,PayPalPaymentDelegate,WXApiDelegate>
{
    YXManager         *_manager;
}
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _manager = [YXManager share];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXpayNotification:) name:@"WXpayNotification" object:nil];
    //    标题栏
    [self HeadTitle];
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.payView];
    
}

#pragma mark - 创建标题栏
-(void)HeadTitle{
    UIImageView *backgroud = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, XScreenWidth,XScreenHeight)];
    
    backgroud.image = [UIImage imageNamed:@"ic_bg.jpg"];
    
    [self.view addSubview:backgroud];
    UIImageView *backgroud2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20+X_bang+44, XScreenWidth,XScreenHeight)];
    
    backgroud2.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:backgroud2];
    
    UIView *_TitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 20+X_bang, XScreenWidth, 44)];
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

/***1 支付宝支付   2微信支付*/
-(void)InitiatePaymentWithPayType:(NSInteger)type
{

    if (type==1) {

        [self payPal];
        
    }else if (type==2){
        //[self weixinPay];
        [self WXrequestSever];
    }


}

-(void)WXrequestSever{
    NSString *url = [NSString stringWithFormat:payTosever,PicHead,_manager.ScanID,_manager.Product_id];
    NSLog(@"===付款url%@",url);
    [NetWork sendGetNetWorkWithUrl:url parameters:nil hudView:self.view successBlock:^(id data) {
        WeChatOrderModel *model = [[WeChatOrderModel alloc]init];
        [model setValuesForKeysWithDictionary:data[@"data"]];
        [self weixinPay:model];
        
    } failureBlock:^(NSString *error) {
        NSLog(@"======付款向服务器提交失败=======");
    }];
}
-(void)weixinPay:(WeChatOrderModel *)model
{
    //测试数据
//    self.noncestr = @"xV04rlEmretLE7QsO4zD3BIWcbQQRyig";
//    self.package = @"Sign=WXPay";
//    self.partnerid = @"1447899502";
//    self.paySign = @"B7D0E78A32C47056B8019FE1D7749437";
//    self.prepayid = @"wx201705101116004d23fa269b0224245096";
//    self.timestamp = @"1494386160";
    //获取当前的时间戳
    
    if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
    {
        //保存订单id，支付成功返回给服务器
        _manager.out_order_no = model.out_order_no;
        PayReq *request = [[PayReq alloc] init];
        /** 商家向财付通申请的商家id */
        request.partnerId = model.partnerId;
        /** 预支付订单 */
        request.prepayId= model.prepayId;
        /** 商家根据财付通文档填写的数据和签名 */
        request.package = model.package;
        /** 随机串，防重发 */
        request.nonceStr= model.nonceStr ;
        /** 时间戳，防重发 */
        request.timeStamp = model.timeStamp;
        /** 商家根据微信开放平台文档对数据做的签名 */
        request.sign = model.sign;
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


#pragma mark - --微信支付成功回调
-(void)WXpayNotification:(NSNotification *)noti
{
    if ([noti.object isEqualToString:@"1"]) {//
        NSLog(@"微信支付成功回调");
        if (_isReceiveNotification==NO) {
            /*订单支付成功 */
            NSString *url = [NSString stringWithFormat:returnSeverSuc,PicHead,_manager.out_order_no];
            [NetWork sendGetNetWorkWithUrl:url parameters:nil hudView:self.view successBlock:^(id data) {
                NSNumber *pay_status = data[@"data"][@"pay_status"];
                if ([pay_status integerValue]==1) {
                    [self setSuc];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self setFai];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } failureBlock:^(NSString *error) {
                
            }];
            
            /**更新UI*/
            _isReceiveNotification=YES;
        }else{
            _isReceiveNotification=YES;
        }
    }else if([noti.object isEqualToString:@"0"]) {
        NSLog(@"zhifushibai");
        [self setFai];
    }
    
}


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


-(PayView *)payView
{
    if (!_payView) {
        _payView = [[PayView alloc]initWithFrame:CGRectMake(0, 60+X_bang, XScreenWidth, XScreenHeight-64)];
        _payView.delegate = self;
       
    }
    return _payView;
}


#pragma mark -修改成功/失败弹窗
-(void)setFai{
    CGSize contentSize = [self textConstraintSize:@"支付失败"];
    UIView *_hudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160,20 +50 + contentSize.height)];
    _hudView.layer.cornerRadius = 6.0f;
    _hudView.backgroundColor = [UIColor grayColor];
    _hudView.alpha = 1;
    [[UIApplication sharedApplication].keyWindow addSubview:_hudView];
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
    
    activityIndicatorLabel.text = @"支付失败";
    
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

-(void)setSuc{
    CGSize contentSize = [self textConstraintSize:@"支付成功"];
    UIView *_hudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160,20 +50 + contentSize.height)];
    _hudView.layer.cornerRadius = 6.0f;
    _hudView.backgroundColor = [UIColor grayColor];
    _hudView.alpha = 1;
    [[UIApplication sharedApplication].keyWindow addSubview:_hudView];
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
    
    activityIndicatorLabel.text = @"支付成功";
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"currect.png"] highlightedImage:nil];
    img.frame = CGRectMake(60.0f, 10.0f, 40.0f, 40.0f);
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
