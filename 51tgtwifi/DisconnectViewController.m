//
//  DisconnectViewController.m
//  51tgtwifi
//
//  Created by DEVCOM on 2017/12/26.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "DisconnectViewController.h"

#import "YXManager.h"

@interface DisconnectViewController ()<UITextFieldDelegate>
{
    UIView        *_TitleView;
    UITextField   *_wifiPwd;
    YXManager     *_manager;
}

@end

@implementation DisconnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
    _manager = [YXManager share];
    
    [self HeadTitle];
    
    
    [self wifitextfield];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWIFIUI) name:@"closeWIFIUI" object:nil];
}
-(void)closeWIFIUI{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 40)];
    lab1.text =[NSString stringWithFormat:@"热点名称: %@",[[UIDevice currentDevice] name]];
    lab1.textColor = [UIColor blackColor];
    [view1 addSubview:lab1];
    
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
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 12)];
    //    btn1.backgroundColor =[UIColor redColor];
    [btn1 setImage:[UIImage imageNamed:@"ic_show_password.png"] forState:UIControlStateNormal];
    btn1.tag = 201;
    [btn1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    _wifiPwd.rightView = btn1;
    [_wifiPwd becomeFirstResponder];
    
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
    tip.text = @"连接提示:\n1、确保手机已开启热点\n2、确保热点密码正确\n3、建议以字母或数字命名热点";
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
    //返回
    if (btn.tag==101) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    //显示密码
    else if (btn.tag==201){
        if (_wifiPwd.secureTextEntry) {
            _wifiPwd.secureTextEntry = NO;
        }else
            _wifiPwd.secureTextEntry=YES;
        
    }
    //加入热点的设置
    else if (btn.tag==301){
        if (_manager.isConnectWifi==NO) {
            NSString *SSID = [[UIDevice currentDevice] name];
            _manager.WIFIpwd = _wifiPwd.text;
            if (_wifiPwd.text.length<8 || !_wifiPwd.text) {
                UIAlertController *alertOne = [UIAlertController alertControllerWithTitle:@"连接失败" message:@"热点密码不能小于8位数" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertOne animated:YES completion:nil];
                
                UIAlertAction *certain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                
                [alertOne addAction:certain];
            }else{
                NSDictionary *dict = @{
                                       @"SSID":@"tgt001",
                                       @"PWD":@"tgt51848"
                                       };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"setWIFI" object:nil userInfo:dict];
            }
            
        }
        
    }
    else if (btn.tag==302){//断开热点
        NSDictionary *dict = @{
                               @"SSID":@"tgt001",
                               @"PWD":@"tgt51848"
                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeWIFI" object:nil userInfo:dict];
    }
}
-(void)dealloc{
    
    
}

#pragma mark textField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //textField:调用次方法的textField
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

