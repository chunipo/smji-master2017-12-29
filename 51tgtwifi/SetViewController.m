//
//  SetViewController.m
//  51tgtwifi
//
//  Created by TGT on 2017/10/13.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "SetViewController.h"
#import "TGTInfoSDK.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#import "LanguageViewController.h"
#import "YXManager.h"
#import "AboutMeViewController.h"
#import "DeviceConnectWifiViewC.h"
#import "SingletonView.h"

#define Name_Device [UIScreen mainScreen].bounds.size.width<375?14:17

@interface SetViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    UITableView     *_tableView;
    NSArray         *_arr;
    NSArray         *_arrImg;
    //UIView          *_viewBack;
    UIView          *_viewBack1;//背景底部
    UIView          *_viewBack2;//背景大
    
    UIView         *_view;
    UITextField     *oldText;
    UITextField     *newText;
    //热点黑名单
    UIView          *_view_wifi;
    UITextView      *heimingTextView;
    
    YXManager       *_manager;
    //设置apn
    UIView          *_view_APN;
    UITextField     *_APN_name;
    UITextField     *_APN_apn;
    UITextField     *_APN_mcc;
    UITextField     *_APN_mnc;
    UITextField     *_APN_numeric;
    UITextField     *_APN_type;
    UITextField     *_APN_user;
    UITextField     *_APN_pwd;
    UITextField     *_APN_port;
    UITextField     *_APN_mmsc;
    UITextField     *_APN_mmsport;
    UITextField     *_APN_proxy;
    UITextField     *_APN_server;
    UITextField     *_APN_mmsproxy;
    
    
    MBProgressHUD   *hud;
    //进度
   // UIView          *_hudView;
}

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _manager = [YXManager share];
    //    背景图片
    [self setBackgroudImage];
    
    //    标题栏
    [self HeadTitle];
    
    
    [self createTableview];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeChangePWD_suc) name:@"closeChangePWD_suc" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeChangePWD_fai) name:@"closeChangePWD_fai" object:nil];
}
#pragma mark 监听键盘
-(void)keyboardWillShow:(NSNotification*)notification{
    if (heimingTextView) {
        //获取处于焦点中的view
        NSArray *textFields = @[heimingTextView];
        UIView *focusView = nil;
        for (UIView *view in textFields) {
            if ([view isFirstResponder]) {
                focusView = view;
                break;
            }
        }
        
        if (focusView) {
            //获取键盘弹出的时间
            double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            //获取键盘上端Y坐标
            CGFloat keyboardY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
            //获取输入框下端相对于window的Y坐标
            CGRect rect = [_view_wifi convertRect:_view_wifi.bounds toView:[[[UIApplication sharedApplication] delegate] window]];
            CGPoint tmp = rect.origin;
            CGFloat inputBoxY = _view_wifi.maxY;
            //计算二者差值
            CGFloat ty = keyboardY - inputBoxY;
            NSLog(@"position keyboard: %f, inputbox: %f, ty: %f", keyboardY, inputBoxY, ty);
            //差值小于0，做平移变换
            [UIView animateWithDuration:duration animations:^{
                if (ty < 0) {
                    self.view.transform = CGAffineTransformMakeTranslation(0, ty);
                }
            }];
        }
    }
   
    //设置APN的
    if (_APN_apn) {
        NSArray *textFields2 = @[_APN_name,_APN_apn,_APN_mcc,_APN_mnc,_APN_numeric,_APN_type,_APN_user,_APN_pwd,_APN_port,_APN_mmsc,_APN_proxy];
        UIView *focusView2 = nil;
        for (UIView *view in textFields2) {
            if ([view isFirstResponder]) {
                focusView2 = view;
                break;
            }
        }
        
        if (focusView2) {
            //获取键盘弹出的时间
            double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            //获取键盘上端Y坐标
            CGFloat keyboardY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
            //获取输入框下端相对于window的Y坐标
            CGRect rect = [_view_APN convertRect:_view_APN.bounds toView:[[[UIApplication sharedApplication] delegate] window]];
            CGPoint tmp = rect.origin;
            CGFloat inputBoxY = _view_APN.maxY;
            //计算二者差值
            CGFloat ty = keyboardY - inputBoxY;
            NSLog(@"position keyboard: %f, inputbox: %f, ty: %f", keyboardY, inputBoxY, ty);
            //差值小于0，做平移变换
            [UIView animateWithDuration:duration animations:^{
                if (ty < 0) {
                    self.view.transform = CGAffineTransformMakeTranslation(0, ty);
                }
            }];
        }

    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘弹出的时间
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //还原
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}



#pragma mark 监听修改的数据是否成功的回调
-(void)closeChangePWD_suc{
    [self hideSchdu];
    [oldText resignFirstResponder];
    [newText resignFirstResponder];
    _viewBack1.frame = CGRectMake(0, 0, 0, 0);
    _viewBack2.frame = CGRectMake(0, 0, 0, 0);
    _view.frame = CGRectMake(0, 0, 0, 0);
    [heimingTextView resignFirstResponder];
    _view_wifi.frame = CGRectMake(0, 0, 0, 0);
    [_APN_apn resignFirstResponder];
    [_APN_name resignFirstResponder];
    [_APN_mcc resignFirstResponder];
    [_APN_mnc resignFirstResponder];
    [_APN_numeric resignFirstResponder];
    [_APN_type resignFirstResponder];
    [_APN_user resignFirstResponder];
    [_APN_pwd resignFirstResponder];
    [_APN_mmsc resignFirstResponder];
    [_APN_port resignFirstResponder];
    [_APN_proxy resignFirstResponder];
    _view_APN.frame = CGRectMake(0, 0, 0, 0);
    [_view_APN removeFromSuperview];
    [_view_wifi removeFromSuperview];
    [_view removeFromSuperview];
    
//    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.label.text = @"修改成功";
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hideAnimated:YES afterDelay:1];
    [self setSuc];
    
}
-(void)closeChangePWD_fai{
    [self hideSchdu];
    [oldText resignFirstResponder];
    [newText resignFirstResponder];
    _viewBack1.frame = CGRectMake(0, 0, 0, 0);
    _viewBack2.frame = CGRectMake(0, 0, 0, 0);
    _view.frame = CGRectMake(0, 0, 0, 0);
    [heimingTextView resignFirstResponder];
    _view_wifi.frame = CGRectMake(0, 0, 0, 0);
    [_APN_apn resignFirstResponder];
    [_APN_name resignFirstResponder];
    [_APN_mcc resignFirstResponder];
    [_APN_mnc resignFirstResponder];
    [_APN_numeric resignFirstResponder];
    [_APN_type resignFirstResponder];
    [_APN_user resignFirstResponder];
    [_APN_pwd resignFirstResponder];
    [_APN_mmsc resignFirstResponder];
    [_APN_port resignFirstResponder];
    [_APN_proxy resignFirstResponder];
    _view_APN.frame = CGRectMake(0, 0, 0, 0);
    [_view_APN removeFromSuperview];
    [_view_wifi removeFromSuperview];
    [_view removeFromSuperview];
    
//    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.label.text = @"修改失败";
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hideAnimated:YES afterDelay:1];
  
    [self setFai];
    
}



#pragma mark - 设置背景图片
-(void)setBackgroudImage{
    //self.view.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:84.0/255.0 blue:178.0/255.0 alpha:1];
    UIImageView *backgroud = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, XScreenWidth,XScreenHeight)];
    
    backgroud.image = [UIImage imageNamed:@"ic_bg.jpg"];
    
    [self.view addSubview:backgroud];
}


#pragma mark - 创建标题栏
-(void)HeadTitle{
    UIView *_TitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 20+X_bang, XScreenWidth, 44)];
    
    _TitleView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_TitleView];
    
    UILabel *TitleText = [UILabel new];
    [_TitleView addSubview:TitleText];
    
    //TitleText.text = SetLange(@"setTitle");
    TitleText.text = @"设 置";
    TitleText.textColor = [UIColor whiteColor];
    TitleText.font = [UIFont systemFontOfSize:19];
    [TitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(_TitleView);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
     TitleText.textAlignment = NSTextAlignmentCenter;
}

#pragma mark -创建tableview
-(void)createTableview{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20+44+X_bang, XScreenWidth, XScreenHeight-20-44-X_bang-X_bottom) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.rowHeight = 60;
    
    _tableView.sectionHeaderHeight = 20;
    
    [self.view addSubview:_tableView];
    
//    _arr = @[@[@"关闭设备热点",@"修改设备热点",@"设置APN",@"连接Wifi",@"设置翻译语言",@"设置提示语言",@"多语言"],@[@"设置热点访问黑名单",@"设备自检",@"软件版本检测",@"历史流量订单"]];
    
    NSString *str1 = SetLange(@"guanbishebeiredian");
    NSString *str2 = SetLange(@"xiugaishebeiredian");
    NSString *str3 = SetLange(@"shezhivpn");
    NSString *str4 = SetLange(@"lianjieWifi");
    NSString *str5 = SetLange(@"shezhifanyiyuyan");
    NSString *str6 = SetLange(@"shezhitishiyuyan");
    NSString *str7 = SetLange(@"duoyuyan");
  
    NSString *str8 = SetLange(@"shezhiredianfangwenmingdan");
    NSString *str9 = SetLange(@"shebeizijian");
    NSString *str10 = SetLange(@"ruanjianbanbenjiance");
    NSString *str11 = SetLange(@"lishiliuliangdingdan");
    
    
    
    
     _arr = @[@[@"修改设备热点密码",@"设置APN",@"连接WIFI"],@[@"设置热点访问黑名单",@"当前设备软件版本号"],@[@"关于我们"]];
     _arrImg = @[@[@"ic_setting_modify_password.png",@"ic_setting_apn.png",@"ic_connect_wifi.png"],@[@"ic_setting_blacklist.png",@"ic_setting_blacklist.png"],@[@"ic_setting_tip_language.png"]];
    _tableView.tableHeaderView =[self headView] ;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arr[section] count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"idd";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
//     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.textLabel.text = _arr[indexPath.section][indexPath.row];
    
   
    
//    设置右边箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.imageView.image = [UIImage imageNamed:_arrImg[indexPath.section][indexPath.row]];
    
    return cell;


}



-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *str1 = SetLange(@"jibenshezhi");
    NSString *str2 = SetLange(@"gaojishezhi");
    
    NSArray *arr = @[@"基本设置",@"高级设置",@""];

    return arr[section];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
//   点击闪一闪
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    app语言切换
    if (indexPath.section==0&&indexPath.row==3) {
        
        LanguageViewController *vc = [[LanguageViewController alloc]init];
        
        [self presentViewController:vc animated:YES completion:nil];
       
    }
    //修改密码
    else if (indexPath.section==0&&indexPath.row==0){
        if (_manager.isOpenBluetooth) {
             [self changePwdUI];
        }else{
            MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"请打开蓝牙开关";
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:1];
        }
       
    }
    //设备连接wifi
    else if (indexPath.section==0&&indexPath.row==2){
        if (_manager.isOpenBluetooth) {
            DeviceConnectWifiViewC *vc = [[DeviceConnectWifiViewC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"请打开蓝牙开关";
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:1];
        }
       
       
    }
    //设置黑名单
    else if (indexPath.section==1&&indexPath.row==0){
        if (_manager.isOpenBluetooth) {
             [self SetBadUrl];
        }else{
            MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"请打开蓝牙开关";
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:1];
        }
       
    }
    //当前版本
    else if (indexPath.section==1&&indexPath.row==1){
        NSString *str = [NSString stringWithFormat:@"当前版本 %@",_manager.appVersion];
        UIAlertController *alertOne = [UIAlertController alertControllerWithTitle:@"设备版本信息" message:str preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertOne animated:YES completion:nil];
        
        UIAlertAction *certain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        [alertOne addAction:certain];
    }
    //关于我们
    else if (indexPath.section==2&&indexPath.row==0){
        AboutMeViewController *aboutVc = [[AboutMeViewController alloc]init];
        [self.navigationController pushViewController:aboutVc animated:YES];
    }
    //设置APN
    else if (indexPath.section==0&&indexPath.row==1){
        if (_manager.isOpenBluetooth) {
            [self setApn];
        }else{
            MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"请打开蓝牙开关";
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:1];
        }

    }
}




#pragma mark- 头部视图
-(UIView *)headView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XScreenWidth, 90)];
    UIImageView *logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_logo.png"]];
    logo.frame = CGRectMake(20, 10, 65, 65);
    [view addSubview:logo];
    UILabel *ssid = [[UILabel alloc]initWithFrame:CGRectMake(logo.maxX+20, 20, 300, 45)];
    
   
    ssid.text = _manager.ScanID;
//    if (!ssid.text) {
//        ssid.text=SetLange(@"devicedName");
//    }
    ssid.font = [UIFont systemFontOfSize:Name_Device];
    ssid.textColor = [UIColor blackColor];
    [view addSubview:ssid];
    
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

/*****************************************************************/
-(void)changePwdUI{
    //弹窗背景
    _viewBack1 = [[UIView alloc]initWithFrame:CGRectMake(0, XScreenHeight-49-X_bottom, XScreenWidth, 49+X_bottom)];
    _viewBack1.backgroundColor = [UIColor blackColor];
    _viewBack1.alpha = 0.3;
    [[UIApplication sharedApplication].keyWindow addSubview:_viewBack1];
    // [self.view addSubview:_viewBack];
    _viewBack2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight)];
    _viewBack2.backgroundColor = [UIColor blackColor];
    _viewBack2.alpha = 0.3;
    [self.view addSubview:_viewBack2];
    
    //距离左右边margin
    CGFloat kMagin = 20.0;
    //宽度
    CGFloat kWidth = XScreenWidth - 2*kMagin;
    _view = [[UIView alloc]initWithFrame:CGRectMake(kMagin, 20+50+X_bang, kWidth, 280)];
    _view.layer.cornerRadius = 5;
    _view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view];
    
    //修改热点密码
    UILabel *chageTitle = [UILabel new];
    [_view addSubview:chageTitle];
    [chageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view).with.offset(10);
        make.right.equalTo(_view).with.offset(-10);
        make.top.equalTo(_view).with.offset(10);
        make.height.mas_equalTo(@45);
    }];
    chageTitle.textAlignment = NSTextAlignmentCenter;
    chageTitle.textColor = [UIColor colorWithRed:62.0/255.0 green:110.0/255.0 blue:148.0/255.0 alpha:1];
    chageTitle.text = @"修改热点密码";
    chageTitle.font = [UIFont systemFontOfSize:28];
    
    
    //第一条横线
    UIView *firstLine = [UIView new];
    [_view addSubview:firstLine];
    firstLine.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:110.0/255.0 blue:148.0/255.0 alpha:1];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view).with.offset(0);
        make.right.equalTo(_view).with.offset(0);
        make.top.equalTo(chageTitle.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@1);
        
    }];
    
    //原密码
    oldText = [UITextField new];
    [_view addSubview:oldText];
    [oldText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view).with.offset(7);
        make.right.equalTo(_view).with.offset(-15);
        make.top.equalTo(firstLine.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@60);
    }];
    oldText.delegate = self;
    //oldText.text = @"输入旧密码";
    oldText.textAlignment = NSTextAlignmentLeft;
    oldText.font = [UIFont systemFontOfSize:20];
    oldText.borderStyle = UITextBorderStyleNone;
    oldText.placeholder = @"输入旧密码";
    oldText.secureTextEntry = YES;
    oldText.keyboardType = UIKeyboardTypeNamePhonePad;
    
    oldText.rightViewMode = UITextFieldViewModeWhileEditing;
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [btn1 setImage:[UIImage imageNamed:@"hide-write.png"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"show-write.png"] forState:UIControlStateSelected];
    btn1.tag = 101;
    [btn1 addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    oldText.rightView = btn1;
    [oldText becomeFirstResponder];
    
    //第二条横线
    UIView *secdLine = [UIView new];
    [_view addSubview:secdLine];
    secdLine.backgroundColor = [UIColor blueColor];
    [secdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view).with.offset(0);
        make.right.equalTo(_view).with.offset(0);
        make.top.equalTo(oldText.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@1);
        
    }];
    secdLine.backgroundColor = [UIColor grayColor];
    secdLine.alpha = 0.2;
    
    //新密码
    newText = [UITextField new];
    [_view addSubview:newText];
    [newText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view).with.offset(7);
        make.right.equalTo(_view).with.offset(-15);
        make.top.equalTo(secdLine.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@60);
    }];
    newText.delegate = self;
    //oldText.text = @"输入新密码";
    newText.textAlignment = NSTextAlignmentLeft;
    newText.font = [UIFont systemFontOfSize:19];
    newText.borderStyle = UITextBorderStyleNone;
    newText.placeholder = @"输入新密码";
    newText.secureTextEntry = YES;
    newText.keyboardType = UIKeyboardTypeNamePhonePad;
    
    newText.rightViewMode = UITextFieldViewModeWhileEditing;
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [btn2 setImage:[UIImage imageNamed:@"hide-write.png"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"show-write.png"] forState:UIControlStateSelected];
    btn2.tag = 102;
    [btn2 addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    newText.rightView = btn2;
    
    
    //第三条横线
    UIView *thirdLine = [UIView new];
    [_view addSubview:thirdLine];
    thirdLine.backgroundColor = [UIColor blueColor];
    [thirdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view).with.offset(0);
        make.right.equalTo(_view).with.offset(0);
        make.top.equalTo(newText.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@1);
        
    }];
    thirdLine.backgroundColor = [UIColor grayColor];
    thirdLine.alpha = 0.2;
    
    //确定取消按钮
    UIButton *confirmBtn = [UIButton new];
    [_view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view).with.offset(0);
        make.bottom.equalTo(_view).with.offset(0);
        make.top.equalTo(thirdLine.mas_bottom).with.offset(0);
        make.width.mas_equalTo(_view.frame.size.width*0.5);
    }];
    confirmBtn.tag = 103;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal ];
    [confirmBtn setTitleColor:[UIColor colorWithRed:62.0/255.0 green:110.0/255.0 blue:148.0/255.0 alpha:1] forState:UIControlStateNormal];
    confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    //
    UIButton *cancelBtn = [UIButton new];
    [_view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmBtn.mas_right).with.offset(0);
        make.right.equalTo(_view).with.offset(0);
        make.bottom.equalTo(_view).with.offset(0);
        make.top.equalTo(thirdLine.mas_bottom).with.offset(0);
        make.width.mas_equalTo(_view.frame.size.width*0.5);
    }];
    cancelBtn.tag = 104;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal ];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmBtn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    
    //竖线
    UIView *suLine = [UIView new];
    [_view addSubview:suLine];
    [suLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_view);
        make.top.equalTo(thirdLine.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(@1);
    }];
    suLine.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:110.0/255.0 blue:148.0/255.0 alpha:1];
    suLine.alpha = 1;
    
}

#pragma mark 点击事件，设置密码黑名单apn
-(void)show:(UIButton*)btn{
    //取消
    if (btn.tag==104) {
        [oldText resignFirstResponder];
        [newText resignFirstResponder];
        _viewBack1.frame = CGRectMake(0, 0, 0, 0);
        _viewBack2.frame = CGRectMake(0, 0, 0, 0);
        _view.frame = CGRectMake(0, 0, 0, 0);
        [_view removeFromSuperview];
        [_viewBack1 removeFromSuperview];
        [_viewBack2 removeFromSuperview];
       
    }
    else if (btn.tag==103){
        if ([oldText.text isEqualToString:_manager.password] && newText.text) {
             [self showSchdu];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"changePwd" object:newText.text userInfo:nil];
        }
        else if(![oldText.text isEqualToString:_manager.password] && newText.text){
            UIAlertController *alertOne = [UIAlertController alertControllerWithTitle:@"输入密码错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertOne animated:YES completion:nil];
            
            UIAlertAction *certain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [alertOne addAction:certain];
            
        }else{
            UIAlertController *alertOne = [UIAlertController alertControllerWithTitle:@"新密码不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertOne animated:YES completion:nil];
            
            UIAlertAction *certain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [alertOne addAction:certain];
        }
    }
    else if (btn.tag==101){
        if (oldText.secureTextEntry) {
            oldText.secureTextEntry = NO;
            btn.selected = YES;
        }else{
            oldText.secureTextEntry=YES;
            btn.selected = NO;
        }
        
        
    }
    else if (btn.tag==102){
        if (newText.secureTextEntry) {
            newText.secureTextEntry = NO;
            btn.selected = YES;
        }else{
            newText.secureTextEntry=YES;
            btn.selected = NO;
        }
    }
    else if (btn.tag==204)//黑名单取消输入
    {
        [heimingTextView resignFirstResponder];
        _viewBack1.frame = CGRectMake(0, 0, 0, 0);
        _viewBack2.frame = CGRectMake(0, 0, 0, 0);
        _view_wifi.frame = CGRectMake(0, 0, 0, 0);
        [_view_wifi removeFromSuperview];
        [_viewBack1 removeFromSuperview];
        [_viewBack2 removeFromSuperview];
    }else if (btn.tag==203)//确认输入黑名单
    {
        [self showSchdu];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"heimingdan" object:heimingTextView.text userInfo:nil];
    }else if (btn.tag==304)//apn取消输入
    {
        //修改apn
        [_APN_apn resignFirstResponder];
        [_APN_name resignFirstResponder];
        [_APN_mcc resignFirstResponder];
        [_APN_mnc resignFirstResponder];
        [_APN_numeric resignFirstResponder];
        [_APN_type resignFirstResponder];
        [_APN_user resignFirstResponder];
        [_APN_pwd resignFirstResponder];
        [_APN_mmsc resignFirstResponder];
        [_APN_port resignFirstResponder];
        [_APN_proxy resignFirstResponder];
        _viewBack1.frame = CGRectMake(0, 0, 0, 0);
        _viewBack2.frame = CGRectMake(0, 0, 0, 0);
        _view_APN.frame = CGRectMake(0, 0, 0, 0);
        [_view_APN removeFromSuperview];
        [_viewBack1 removeFromSuperview];
        [_viewBack2 removeFromSuperview];
    }else if (btn.tag==303)//apn输入
    {
        NSDictionary *dict = @{
                               @"apn":_APN_apn.text,
                               @"mcc":_APN_mcc.text,
                               @"mmsc":_APN_mmsc.text,
                               @"mmsport":@"",
                               @"mmsproxy":@"",
                               @"mnc":_APN_mnc.text,
                               @"name":_APN_name.text,
                               @"numeric":_APN_numeric.text,
                               @"password":_APN_pwd.text,
                               @"port":_APN_port.text,
                               @"proxy":_APN_proxy.text,
                               @"server":@"",
                               @"type":_APN_type.text,
                               @"user":_APN_user.text
                               };
        [self showSchdu];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setAPN" object:nil userInfo:dict];
    }
}

#pragma mark 设置热点访问黑名单
-(void)SetBadUrl{
    //弹窗背景
    _viewBack1 = [[UIView alloc]initWithFrame:CGRectMake(0, XScreenHeight-49-X_bottom, XScreenWidth, 49+X_bottom)];
    _viewBack1.backgroundColor = [UIColor blackColor];
    _viewBack1.alpha = 0.3;
    [[UIApplication sharedApplication].keyWindow addSubview:_viewBack1];
    // [self.view addSubview:_viewBack];
    _viewBack2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight)];
    _viewBack2.backgroundColor = [UIColor blackColor];
    _viewBack2.alpha = 0.3;
    [self.view addSubview:_viewBack2];
    
    //距离左右边margin
    CGFloat kMagin = 20.0;
    //宽度
    CGFloat kWidth = XScreenWidth - 2*kMagin;
    _view_wifi = [[UIView alloc]initWithFrame:CGRectMake(kMagin, 20+50+X_bang, kWidth, 380)];
    _view_wifi.layer.cornerRadius = 5;
    _view_wifi.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view_wifi];
    
    //修改热点密码
    UILabel *chageTitle = [UILabel new];
    [_view_wifi addSubview:chageTitle];
    [chageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_wifi).with.offset(10);
        make.right.equalTo(_view_wifi).with.offset(-10);
        make.top.equalTo(_view_wifi).with.offset(10);
        make.height.mas_equalTo(@45);
    }];
    chageTitle.textAlignment = NSTextAlignmentCenter;
    chageTitle.textColor = [UIColor colorWithRed:62.0/255.0 green:110.0/255.0 blue:148.0/255.0 alpha:1];
    chageTitle.text = @"设置热点访问黑名单";
    chageTitle.font = [UIFont systemFontOfSize:28];
    
    
    //第一条横线
    UIView *firstLine = [UIView new];
    [_view_wifi addSubview:firstLine];
    firstLine.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:110.0/255.0 blue:148.0/255.0 alpha:1];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_wifi).with.offset(0);
        make.right.equalTo(_view_wifi).with.offset(0);
        make.top.equalTo(chageTitle.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@1);
        
    }];
    
    UILabel *lab = [UILabel new];
    [_view_wifi addSubview:lab];
    lab.textColor = [UIColor grayColor];
    lab.text = @"1.网址或ip以英文 , 隔开\n(例:www.iCloud.com,yunpan.360.cn,192.168.1.10);\n2.为空设置设备默认的黑名单";
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:15];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_wifi).with.offset(10);
        make.right.equalTo(_view_wifi).with.offset(10);
        make.top.equalTo(firstLine.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@90);
        
    }];
    
    heimingTextView = [UITextView new];
    [_view_wifi addSubview:heimingTextView];
    heimingTextView.backgroundColor = [UIColor whiteColor];
    heimingTextView.textAlignment = NSTextAlignmentLeft;
    heimingTextView.layer.borderColor = [UIColor grayColor].CGColor;
    heimingTextView.layer.borderWidth = 1;
    heimingTextView.layer.cornerRadius = 5;
    heimingTextView.keyboardType = UIKeyboardTypeDefault;
    [ heimingTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_wifi).with.offset(10);
        make.right.equalTo(_view_wifi).with.offset(-10);
        make.top.equalTo(lab.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@150);
        
    }];
    heimingTextView.delegate = self;
   // [heimingTextView becomeFirstResponder];
    heimingTextView.font = [UIFont systemFontOfSize:18];
    
    
    //第三条横线
    UIView *thirdLine = [UIView new];
    [_view_wifi addSubview:thirdLine];
    thirdLine.backgroundColor = [UIColor blueColor];
    [thirdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_wifi).with.offset(0);
        make.right.equalTo(_view_wifi).with.offset(0);
        make.top.equalTo(heimingTextView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@1);
        
    }];
    thirdLine.backgroundColor = [UIColor grayColor];
    thirdLine.alpha = 0.2;
    
    //确定取消按钮
    UIButton *confirmBtn = [UIButton new];
    [_view_wifi addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_wifi).with.offset(0);
        make.bottom.equalTo(_view_wifi).with.offset(0);
        make.top.equalTo(thirdLine.mas_bottom).with.offset(0);
        make.width.mas_equalTo(_view_wifi.frame.size.width*0.5);
    }];
    confirmBtn.tag = 203;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal ];
    [confirmBtn setTitleColor:[UIColor colorWithRed:62.0/255.0 green:110.0/255.0 blue:148.0/255.0 alpha:1] forState:UIControlStateNormal];
    confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    //
    UIButton *cancelBtn = [UIButton new];
    [_view_wifi addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmBtn.mas_right).with.offset(0);
        make.right.equalTo(_view_wifi).with.offset(0);
        make.bottom.equalTo(_view_wifi).with.offset(0);
        make.top.equalTo(thirdLine.mas_bottom).with.offset(0);
        make.width.mas_equalTo(_view_wifi.frame.size.width*0.5);
    }];
    cancelBtn.tag = 204;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal ];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmBtn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //竖线
    UIView *suLine = [UIView new];
    [_view_wifi addSubview:suLine];
    [suLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_view_wifi);
        make.top.equalTo(thirdLine.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(@1);
    }];
    suLine.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:110.0/255.0 blue:148.0/255.0 alpha:1];
    suLine.alpha = 1;
    
}

#pragma mark 设置apn
-(void)setApn{
    //弹窗背景
    _viewBack1 = [[UIView alloc]initWithFrame:CGRectMake(0, XScreenHeight-49-X_bottom, XScreenWidth, 49+X_bottom)];
    _viewBack1.backgroundColor = [UIColor blackColor];
    _viewBack1.alpha = 0.3;
    [[UIApplication sharedApplication].keyWindow addSubview:_viewBack1];
   // [self.view addSubview:_viewBack];
    _viewBack2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight)];
    _viewBack2.backgroundColor = [UIColor blackColor];
    _viewBack2.alpha = 0.3;
    [self.view addSubview:_viewBack2];
    
    //距离左右边margin
    CGFloat kMagin = 20.0;
    //宽度
    CGFloat kWidth = XScreenWidth - 2*kMagin;
    _view_APN = [[UIView alloc]initWithFrame:CGRectMake(kMagin, 20+50+X_bang, kWidth, 410)];
    _view_APN.layer.cornerRadius = 5;
    _view_APN.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view_APN];
    
    //修改热点密码
    UILabel *chageTitle = [UILabel new];
    [_view_APN addSubview:chageTitle];
    [chageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_APN).with.offset(10);
        make.right.equalTo(_view_APN).with.offset(-10);
        make.top.equalTo(_view_APN).with.offset(10);
        make.height.mas_equalTo(@45);
    }];
    chageTitle.textAlignment = NSTextAlignmentCenter;
    chageTitle.textColor = [UIColor colorWithRed:62.0/255.0 green:110.0/255.0 blue:148.0/255.0 alpha:1];
    chageTitle.text = @"设置APN";
    chageTitle.font = [UIFont systemFontOfSize:28];
    
    //第一条横线
    UIView *firstLine = [UIView new];
    [_view_APN addSubview:firstLine];
    firstLine.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:110.0/255.0 blue:148.0/255.0 alpha:1];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_APN).with.offset(0);
        make.right.equalTo(_view_APN).with.offset(0);
        make.top.equalTo(chageTitle.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@1);
        
    }];
    
    UIScrollView *_scrollView = [UIScrollView new];
    [_view_APN addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_APN).with.offset(0);
        make.right.equalTo(_view_APN).with.offset(0);
        make.top.equalTo(firstLine.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@270);
    }];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(0,550);
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    //隐藏垂直方向滑动条
    _scrollView.showsVerticalScrollIndicator = YES;
    //apn
    _APN_apn = [[UITextField alloc]initWithFrame:CGRectMake(7, 5, kWidth-14, 45)];
    [_scrollView addSubview:_APN_apn];
    _APN_apn.delegate = self;
    _APN_apn.text = @"";
    _APN_apn.textAlignment = NSTextAlignmentLeft;
    _APN_apn.font = [UIFont systemFontOfSize:20];
    _APN_apn.borderStyle = UITextBorderStyleNone;
    _APN_apn.placeholder = @"apn(必填)";
    _APN_apn.secureTextEntry = NO;
    _APN_apn.keyboardType = UIKeyboardTypeDefault;
    //外框
    _APN_apn.layer.borderColor = [UIColor grayColor].CGColor;
    _APN_apn.layer.borderWidth = 1;
    _APN_apn.layer.cornerRadius =5;
    
    //name
    _APN_name = [[UITextField alloc]initWithFrame:CGRectMake(_APN_apn.x, _APN_apn.maxY+5, _APN_apn.width, 45)];
    [_scrollView addSubview:_APN_name];
    _APN_name.delegate = self;
    _APN_name.text = @"";
    _APN_name.textAlignment = NSTextAlignmentLeft;
    _APN_name.font = [UIFont systemFontOfSize:20];
    _APN_name.borderStyle = UITextBorderStyleNone;
    _APN_name.placeholder = @"名称(必填)";
    _APN_name.secureTextEntry = NO;
    _APN_name.keyboardType = UIKeyboardTypeDefault;
    //外框
    _APN_name.layer.borderColor = [UIColor grayColor].CGColor;
    _APN_name.layer.borderWidth = 1;
    _APN_name.layer.cornerRadius =5;
    
    //mcc
    _APN_mcc = [[UITextField alloc]initWithFrame:CGRectMake(_APN_name.x, _APN_name.maxY+5, _APN_apn.width, 45)];
    [_scrollView addSubview:_APN_mcc];
    _APN_mcc.delegate = self;
     _APN_mcc.text = @"";
    _APN_mcc.textAlignment = NSTextAlignmentLeft;
    _APN_mcc.font = [UIFont systemFontOfSize:20];
    _APN_mcc.borderStyle = UITextBorderStyleNone;
    _APN_mcc.placeholder = @"mcc(必填)";
    _APN_mcc.secureTextEntry = NO;
    _APN_mcc.keyboardType = UIKeyboardTypeDefault;
    //外框
    _APN_mcc.layer.borderColor = [UIColor grayColor].CGColor;
    _APN_mcc.layer.borderWidth = 1;
    _APN_mcc.layer.cornerRadius =5;
    
    //mnc
    _APN_mnc = [[UITextField alloc]initWithFrame:CGRectMake(_APN_mcc.x, _APN_mcc.maxY+5, _APN_apn.width, 45)];
    [_scrollView addSubview:_APN_mnc];
    _APN_mnc.delegate = self;
    _APN_mnc.text = @"";
    _APN_mnc.textAlignment = NSTextAlignmentLeft;
    _APN_mnc.font = [UIFont systemFontOfSize:20];
    _APN_mnc.borderStyle = UITextBorderStyleNone;
    _APN_mnc.placeholder = @"mnc(必填)";
    _APN_mnc.secureTextEntry = NO;
    _APN_mnc.keyboardType = UIKeyboardTypeDefault;
    //外框
    _APN_mnc.layer.borderColor = [UIColor grayColor].CGColor;
    _APN_mnc.layer.borderWidth = 1;
    _APN_mnc.layer.cornerRadius =5;
    
    //numeric
    _APN_numeric = [[UITextField alloc]initWithFrame:CGRectMake(_APN_mnc.x, _APN_mnc.maxY+5, _APN_apn.width, 45)];
    [_scrollView addSubview:_APN_numeric];
    _APN_numeric.delegate = self;
    _APN_numeric.text = @"";
    _APN_numeric.textAlignment = NSTextAlignmentLeft;
    _APN_numeric.font = [UIFont systemFontOfSize:20];
    _APN_numeric.borderStyle = UITextBorderStyleNone;
    _APN_numeric.placeholder = @"numeric(必填)";
    _APN_numeric.secureTextEntry = NO;
    _APN_numeric.keyboardType = UIKeyboardTypeDefault;
    //外框
    _APN_numeric.layer.borderColor = [UIColor grayColor].CGColor;
    _APN_numeric.layer.borderWidth = 1;
    _APN_numeric.layer.cornerRadius =5;
    
    //type
    _APN_type = [[UITextField alloc]initWithFrame:CGRectMake(_APN_numeric.x, _APN_numeric.maxY+5, _APN_apn.width, 45)];
    [_scrollView addSubview:_APN_type];
    _APN_type.delegate = self;
    _APN_type.text = @"";
    _APN_type.textAlignment = NSTextAlignmentLeft;
    _APN_type.font = [UIFont systemFontOfSize:20];
    _APN_type.borderStyle = UITextBorderStyleNone;
    _APN_type.placeholder = @"type(必填)";
    _APN_type.secureTextEntry = NO;
    _APN_type.keyboardType = UIKeyboardTypeDefault;
    //外框
    _APN_type.layer.borderColor = [UIColor grayColor].CGColor;
    _APN_type.layer.borderWidth = 1;
    _APN_type.layer.cornerRadius =5;
    
    //user
    _APN_user = [[UITextField alloc]initWithFrame:CGRectMake(_APN_type.x, _APN_type.maxY+5, _APN_apn.width, 45)];
    [_scrollView addSubview:_APN_user];
    _APN_user.delegate = self;
    _APN_user.text = @"";
    _APN_user.textAlignment = NSTextAlignmentLeft;
    _APN_user.font = [UIFont systemFontOfSize:20];
    _APN_user.borderStyle = UITextBorderStyleNone;
    _APN_user.placeholder = @"user";
    _APN_user.secureTextEntry = NO;
    _APN_user.keyboardType = UIKeyboardTypeDefault;
    //外框
    _APN_user.layer.borderColor = [UIColor grayColor].CGColor;
    _APN_user.layer.borderWidth = 1;
    _APN_user.layer.cornerRadius =5;
    
    //pwd
    _APN_pwd = [[UITextField alloc]initWithFrame:CGRectMake(_APN_user.x, _APN_user.maxY+5, _APN_apn.width, 45)];
    [_scrollView addSubview:_APN_pwd];
    _APN_pwd.delegate = self;
    _APN_pwd.text = @"";
    _APN_pwd.textAlignment = NSTextAlignmentLeft;
    _APN_pwd.font = [UIFont systemFontOfSize:20];
    _APN_pwd.borderStyle = UITextBorderStyleNone;
    _APN_pwd.placeholder = @"password";
    _APN_pwd.secureTextEntry = NO;
    _APN_pwd.keyboardType = UIKeyboardTypeDefault;
    //外框
    _APN_pwd.layer.borderColor = [UIColor grayColor].CGColor;
    _APN_pwd.layer.borderWidth = 1;
    _APN_pwd.layer.cornerRadius =5;
    
    //mmsc
    _APN_mmsc = [[UITextField alloc]initWithFrame:CGRectMake(_APN_pwd.x,_APN_pwd.maxY+5, _APN_apn.width, 45)];
    [_scrollView addSubview:_APN_mmsc];
    _APN_mmsc.delegate = self;
    _APN_mmsc.text = @"";
    _APN_mmsc.textAlignment = NSTextAlignmentLeft;
    _APN_mmsc.font = [UIFont systemFontOfSize:20];
    _APN_mmsc.borderStyle = UITextBorderStyleNone;
    _APN_mmsc.placeholder = @"mmsc";
    _APN_mmsc.secureTextEntry = NO;
    _APN_mmsc.keyboardType = UIKeyboardTypeDefault;
    //外框
    _APN_mmsc.layer.borderColor = [UIColor grayColor].CGColor;
    _APN_mmsc.layer.borderWidth = 1;
    _APN_mmsc.layer.cornerRadius =5;
    
    
    //port
    _APN_port = [[UITextField alloc]initWithFrame:CGRectMake(_APN_mmsc.x,_APN_mmsc.maxY+5, _APN_apn.width, 45)];
    [_scrollView addSubview:_APN_port];
    _APN_port.delegate = self;
    _APN_port.text = @"";
    _APN_port.textAlignment = NSTextAlignmentLeft;
    _APN_port.font = [UIFont systemFontOfSize:20];
    _APN_port.borderStyle = UITextBorderStyleNone;
    _APN_port.placeholder = @"端点";
    _APN_port.secureTextEntry = NO;
    _APN_port.keyboardType = UIKeyboardTypeDefault;
    //外框
    _APN_port.layer.borderColor = [UIColor grayColor].CGColor;
    _APN_port.layer.borderWidth = 1;
    _APN_port.layer.cornerRadius =5;
 
    
    //代理proxy
    _APN_proxy = [[UITextField alloc]initWithFrame:CGRectMake(_APN_port.x,_APN_port.maxY+5,_APN_port.width, 45)];
    [_scrollView addSubview:_APN_proxy];
    _APN_proxy.delegate = self;
    _APN_proxy.text = @"";
    _APN_proxy.textAlignment = NSTextAlignmentLeft;
    _APN_proxy.font = [UIFont systemFontOfSize:20];
    _APN_proxy.borderStyle = UITextBorderStyleNone;
    _APN_proxy.placeholder = @"代理";
    _APN_proxy.secureTextEntry = NO;
    _APN_proxy.keyboardType = UIKeyboardTypeDefault;
    //外框
    _APN_proxy.layer.borderColor = [UIColor grayColor].CGColor;
    _APN_proxy.layer.borderWidth = 1;
    _APN_proxy.layer.cornerRadius =5;

    
    //第三条横线
    UIView *thirdLine = [UIView new];
    [_view_APN addSubview:thirdLine];
    thirdLine.backgroundColor = [UIColor blueColor];
    [thirdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_APN).with.offset(0);
        make.right.equalTo(_view_APN).with.offset(0);
        make.top.equalTo(_scrollView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@1);
        
    }];
    thirdLine.backgroundColor = [UIColor grayColor];
    thirdLine.alpha = 0.2;
    
    //确定取消按钮
    UIButton *confirmBtn = [UIButton new];
    [_view_APN addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view_APN).with.offset(0);
        make.bottom.equalTo(_view_APN).with.offset(0);
        make.top.equalTo(thirdLine.mas_bottom).with.offset(0);
        make.width.mas_equalTo(_view_APN.frame.size.width*0.5);
    }];
    confirmBtn.tag = 303;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal ];
    [confirmBtn setTitleColor:[UIColor colorWithRed:62.0/255.0 green:110.0/255.0 blue:148.0/255.0 alpha:1] forState:UIControlStateNormal];
    confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    //
    UIButton *cancelBtn = [UIButton new];
    [_view_APN addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmBtn.mas_right).with.offset(0);
        make.right.equalTo(_view_APN).with.offset(0);
        make.bottom.equalTo(_view_APN).with.offset(0);
        make.top.equalTo(thirdLine.mas_bottom).with.offset(0);
        make.width.mas_equalTo(_view_APN.frame.size.width*0.5);
    }];
    cancelBtn.tag = 304;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal ];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmBtn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    
    //竖线
    UIView *suLine = [UIView new];
    [_view_APN addSubview:suLine];
    [suLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_view_APN);
        make.top.equalTo(thirdLine.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(@1);
    }];
    suLine.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:110.0/255.0 blue:148.0/255.0 alpha:1];
    suLine.alpha = 1;
    
}

#pragma mark - 显示进度条

-(void)showSchdu{
    hud =   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = NSLocalizedString(@"正在设置中...", @"HUD loading title");
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
    
    activityIndicatorLabel.text = @"修改失败";
    
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
    
    activityIndicatorLabel.text = @"修改成功";
    
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
    //textField:调用次方法的textField
    NSLog(@"点击return 按钮时会执行的方法");
    [textField resignFirstResponder]; //回收键盘
//    //修改密码
//    [oldText resignFirstResponder];
//    [newText resignFirstResponder];
//    //修改apn
//    [_APN_apn resignFirstResponder];
//    [_APN_name resignFirstResponder];
//    [_APN_mcc resignFirstResponder];
//    [_APN_mnc resignFirstResponder];
//    [_APN_numeric resignFirstResponder];
//    [_APN_type resignFirstResponder];
//    [_APN_user resignFirstResponder];
//    [_APN_pwd resignFirstResponder];
//    [_APN_mmsc resignFirstResponder];
//    [_APN_port resignFirstResponder];
//    [_APN_proxy resignFirstResponder];
//
//    _viewBack.frame = CGRectMake(0, 0, 0, 0);
//    _view.frame = CGRectMake(0, 0, 0, 0);
//    _view_APN.frame = CGRectMake(0, 0, 0, 0);
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
