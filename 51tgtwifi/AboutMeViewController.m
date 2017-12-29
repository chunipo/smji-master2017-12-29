//
//  AboutMeViewController.m
//  51tgtwifi
//
//  Created by DEVCOM on 2017/12/22.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self HeadTitle];
    
    [self logo];
}

#pragma mark - 创建标题栏
-(void)HeadTitle{
    UIView *_TitleView = [[UIView alloc]init];
    _TitleView.frame =CGRectMake(0, 0, XScreenWidth, 60+X_bang+20);
    
    _TitleView.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:144.0/255.0 blue:242.0/255.0 alpha:1];
    [self.view addSubview:_TitleView];
    
    UILabel *TitleText = [UILabel new];
    [_TitleView addSubview:TitleText];
    
    
    
    
    TitleText.text = @"关于我们";
    //    TitleText.text = NSLocalizedString(@"title", nil);
    
    
    TitleText.textColor = [UIColor whiteColor];
    
    [TitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.centerX.equalTo(_TitleView);
        make.centerY.mas_equalTo(_TitleView.mas_centerY).with.offset(X_bang/2.0+10);
    }];
    TitleText.font = [UIFont systemFontOfSize:24];
    TitleText.textAlignment = 1;
    
    
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



-(void)logo{
    
    UIImageView *logo = [UIImageView new];
    [self.view addSubview:logo];
    
    CGFloat Klogo = 95;
    CGFloat logoX = XScreenWidth/2-Klogo/2;
    logo.frame = CGRectMake(logoX, XScreenHeight*2/10, Klogo, Klogo);
    logo.image = [UIImage imageNamed:@"ic_tuge_icon.png"];
    
    UILabel *appname = [[UILabel alloc]initWithFrame:CGRectMake(logo.x, logo.maxY+10, Klogo, 80)];
    appname.text = @"途鸽翻译机\n1.0";
    appname.textColor = [UIColor grayColor];
    [self.view addSubview:appname];
    appname.font = [UIFont systemFontOfSize:16];
    appname.numberOfLines = 0;
    appname.textAlignment = NSTextAlignmentCenter;
    
    UILabel *bottom = [UILabel new];
    [self.view addSubview:bottom];
    bottom.text = @"深圳市途鸽信息有限公司\nCopyright  ©2014-2017";
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(50);
    }];
    bottom.numberOfLines = 0;
    bottom.textAlignment = NSTextAlignmentCenter;
}

-(void)click:(UIButton *)btn{
    //返回
    if (btn.tag==101) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
