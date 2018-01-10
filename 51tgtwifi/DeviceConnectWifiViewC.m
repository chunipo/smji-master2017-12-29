//
//  DeviceConnectWifiViewC.m
//  51tgtwifi
//
//  Created by DEVCOM on 2017/12/26.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "DeviceConnectWifiViewC.h"
#import "YXManager.h"
#import "HomeVc.h"
#import "SingletonView.h"

@interface DeviceConnectWifiViewC ()<UITextFieldDelegate>
{
    UIView        *_TitleView;
    UITextField   *_wifiPwd;
    UITextField   *_wifiName;
    YXManager     *_manager;
    MBProgressHUD *hud;
}

@end

@implementation DeviceConnectWifiViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
    _manager = [YXManager share];
    
    [self HeadTitle];
    
    
    [self wifitextfield];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePWD_suc) name:@"closePWD_suc" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePWD_fai) name:@"closePWD_fai" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectWIFI_suc) name:@"disconnectWIFI_suc" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectWIFI_fai) name:@"disconnectWIFI_fai" object:nil];
}
-(void)closePWD_suc{
    [self hideSchdu];
    [self.navigationController popViewControllerAnimated:YES];
    
//    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.label.text = @"连接成功";
//
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hideAnimated:YES afterDelay:2];
    [self setSuc];
}
-(void)closePWD_fai{
    [self hideSchdu];
    [self.navigationController popViewControllerAnimated:YES];
    
//    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.label.text = @"连接失败";
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hideAnimated:YES afterDelay:2];
    [self setFai];
}

-(void)disconnectWIFI_suc{
    [self hideSchdu];
    [self.navigationController popViewControllerAnimated:YES];
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"断开成功";
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

-(void)disconnectWIFI_fai{
    [self hideSchdu];
    [self.navigationController popViewControllerAnimated:YES];
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"断开失败";
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

#pragma mark - 创建标题栏
-(void)HeadTitle{
    //    背景图片
    UIView *backgroud = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XScreenWidth,20+X_bang)];

    backgroud.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:144.0/255.0 blue:242.0/255.0 alpha:1];

    [self.view addSubview:backgroud];

    
    _TitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 20+X_bang, XScreenWidth, 60)];
    
    _TitleView.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:144.0/255.0 blue:242.0/255.0 alpha:1];
    
    [self.view addSubview:_TitleView];
    
    UILabel *TitleText = [UILabel new];
    [_TitleView addSubview:TitleText];
    
    TitleText.text = @"连接WIFI";
    TitleText.textColor = [UIColor whiteColor];
    TitleText.numberOfLines = 0;
    
    [TitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(_TitleView);
        make.size.mas_equalTo(CGSizeMake(200, 60));
    }];
    
    TitleText.textAlignment = NSTextAlignmentCenter;
    
    
    
    //    取消按钮
    UIButton *btn = [UIButton new];
    [_TitleView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_TitleView).offset(10);
        
        make.centerY.equalTo(TitleText);
        
        make.size.mas_equalTo(CGSizeMake(35, 30));
        
        
    }];
    
    btn.tag = 101;
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"ic_arrow_back_white.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark 创建输入框
-(void)wifitextfield{
    //热点名称
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, _TitleView.maxY, XScreenWidth, 60)];
    view1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view1];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 40)];
    lab1.text =[NSString stringWithFormat:@"热点名称:"];
    lab1.textColor = [UIColor blackColor];
    [view1 addSubview:lab1];
    
    _wifiName = [[UITextField alloc]initWithFrame:CGRectMake(lab1.maxX, 10, XScreenWidth-lab1.maxX-20, 40)];;
    [view1 addSubview:_wifiName];
    
    _wifiName.delegate = self;
    //oldText.text = @"输入旧密码";
    _wifiName.textAlignment = NSTextAlignmentLeft;
    //_wifiPwd.font = [UIFont systemFontOfSize:20];
    _wifiName.borderStyle = UITextBorderStyleNone;
    _wifiName.placeholder = @"输入热点名称";
    //_wifiName.secureTextEntry = YES;
    _wifiName.keyboardType = UIKeyboardTypeNamePhonePad;
    
    _wifiName.rightViewMode = UITextFieldViewModeWhileEditing;
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 12)];
    //    btn1.backgroundColor =[UIColor redColor];
    [btn2 setImage:[UIImage imageNamed:@"ic_show_password.png"] forState:UIControlStateNormal];
    btn2.tag = 202;
    [btn2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    _wifiPwd.rightView = btn2;
    
    //热点密码
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view1.maxY, XScreenWidth, view1.height)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 40)];
    lab2.text =[NSString stringWithFormat:@"热点密码:"];
    lab2.textColor = [UIColor blackColor];
    [view2 addSubview:lab2];
    
    _wifiPwd = [[UITextField alloc]initWithFrame:CGRectMake(lab2.maxX, 10, XScreenWidth-lab2.maxX-20, 40)];;
    [view2 addSubview:_wifiPwd];

    _wifiPwd.delegate = self;
    //oldText.text = @"输入旧密码";
    _wifiPwd.textAlignment = NSTextAlignmentLeft;
    //_wifiPwd.font = [UIFont systemFontOfSize:20];
    _wifiPwd.borderStyle = UITextBorderStyleNone;
    _wifiPwd.placeholder = @"输入手机热点密码";
    _wifiPwd.secureTextEntry = YES;
    _wifiPwd.keyboardType = UIKeyboardTypeNamePhonePad;
    
    _wifiPwd.rightViewMode = UITextFieldViewModeWhileEditing;
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [btn1 setImage:[UIImage imageNamed:@"hide-write.png"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"show-write.png"] forState:UIControlStateSelected];
    btn1.tag = 201;
    [btn1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    _wifiPwd.rightView = btn1;
   // [_wifiPwd becomeFirstResponder];
    
    //加入热点
    UIButton *joinBtn = [UIButton new];
    [self.view addSubview:joinBtn];
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
         make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(view2.mas_bottom).with.offset(40);
        make.height.mas_equalTo(@55);
        //make.width.mas_equalTo(@);

    }];
    joinBtn.tag = 301;
    [joinBtn setTitle:@"加  入" forState:UIControlStateNormal];
    joinBtn.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:144.0/255.0 blue:242.0/255.0 alpha:1];
    joinBtn.layer.cornerRadius = 5;
    [joinBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(20, view2.maxY+20+joinBtn.height+30, 250, 300)];
    tip.backgroundColor = [UIColor clearColor];
    tip.textColor = [UIColor grayColor];
    tip.text = @"连接提示:\n1.确保已开启热点\n2.确保热点密码正确\n";
    [self.view addSubview:tip];
    tip.numberOfLines = 0;
    if (_manager.isConnectWifi == YES) {
        UIButton *joinBtn2 = [UIButton new];
        [self.view addSubview:joinBtn2];
        [joinBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(20);
            make.right.equalTo(self.view).with.offset(-20);
            make.top.equalTo(view2.mas_bottom).with.offset(40);
            make.height.mas_equalTo(@55);
            //make.width.mas_equalTo(@);
            
        }];
        joinBtn2.tag = 302;
        [joinBtn2 setTitle:@"断  开" forState:UIControlStateNormal];
        joinBtn2.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:1];
        joinBtn2.layer.cornerRadius = 5;
        [joinBtn2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        tip.alpha = 0;
        _wifiPwd.text = _manager.WIFIpwd;
        [_wifiPwd resignFirstResponder];
    }
    
}

-(void)click:(UIButton *)btn{
    NSLog(@"Thread:======%@",[NSThread currentThread]);
    
    
    //返回
    if (btn.tag==101) {
        [self.navigationController popViewControllerAnimated:YES];
       // [self dismissViewControllerAnimated:YES completion:nil];
       
    }
    //显示密码
    else if (btn.tag==201){
        if (_wifiPwd.secureTextEntry) {
            _wifiPwd.secureTextEntry = NO;
            btn.selected = YES;
        }else{
            _wifiPwd.secureTextEntry=YES;
            btn.selected = NO;
        }
        
    }
//    //显示WIFI名称
//    else if (btn.tag==202){
//        if (_wifiName.secureTextEntry) {
//            _wifiName.secureTextEntry = NO;
//        }else
//            _wifiName.secureTextEntry=YES;
//
//    }
    //加入热点的设置
    else if (btn.tag==301){
        if (_manager.isConnectWifi==NO) {
            _manager.WIFIname = _wifiName.text;
            _manager.WIFIpwd = _wifiPwd.text;
            if (_wifiPwd.text.length<8 || !_wifiPwd.text) {
                UIAlertController *alertOne = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入的热点密码小于8位，是否要连接该热点？" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertOne animated:YES completion:nil];
                
                UIAlertAction *certain = [UIAlertAction actionWithTitle:@"连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSDictionary *dict = @{
                                           @"SSID":_manager.WIFIname,
                                           @"PWD":_manager.WIFIpwd
                                           };
                    //远程设置让蓝牙可搜索服务
                    _manager.isReload = NO;
                    _manager.isConnectInfo = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"setWIFI" object:nil userInfo:dict];
                    [self showSchdu];
                }];
                UIAlertAction *certain2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                
                [alertOne addAction:certain];
                [alertOne addAction:certain2];
            }else{
                NSDictionary *dict = @{
                                       @"SSID":_manager.WIFIname,
                                       @"PWD":_manager.WIFIpwd
                                       };
                //远程设置让蓝牙可搜索服务
                _manager.isReload = NO;
                _manager.isConnectInfo = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"setWIFI" object:nil userInfo:dict];
                [self showSchdu];
            }
         
        }
       
    }
    else if (btn.tag==302){//断开热点
        NSDictionary *dict = @{
                               @"SSID":_manager.WIFIname,
                               @"PWD":_manager.WIFIpwd
                               };
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"SetLanguage" object:nil];
        _manager.isReload = NO;
        _manager.isConnectInfo = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeWIFI" object:nil userInfo:dict];
        [self showSchdu];
    }
}

#pragma mark - 显示进度条

-(void)showSchdu{
    hud =   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
   // hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = NSLocalizedString(@"正在连接中...", @"HUD loading title");
    
    hud.color = [UIColor grayColor];
    
    [hud showAnimated:YES];
}

-(void)hideSchdu{
    [hud hideAnimated:YES];
}

#pragma mark -修改成功/失败弹窗
-(void)setFai{
    CGSize contentSize = [self textConstraintSize:@"修改失败"];
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
    
    activityIndicatorLabel.text = @"连接失败";
    
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
    CGSize contentSize = [self textConstraintSize:@"修改成功"];
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
    
    activityIndicatorLabel.text = @"连接成功";
    
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


#pragma mark textField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //textField:调用次方法的textField嗯呢
    NSLog(@"点击return 按钮时会执行的方法");
    [textField resignFirstResponder]; //回收键盘
   
    return YES;
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
