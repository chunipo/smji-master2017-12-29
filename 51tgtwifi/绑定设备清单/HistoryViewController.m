//
//  HistoryViewController.m
//  51tgtwifi
//
//  Created by DEVCOM on 2018/1/13.
//  Copyright © 2018年 weiyuxiang. All rights reserved.
//

#import "HistoryViewController.h"
#import "YXManager.h"

@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView      *_tableView;
    NSArray   *_arr;
    YXManager        *_manager;
}

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [YXManager share];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    [self HeadTitle];
    [self createTable];
}


#pragma mark - 创建标题栏
-(void)HeadTitle{
    UIView *_TitleView = [[UIView alloc]init];
    _TitleView.frame =CGRectMake(0, 0, XScreenWidth, 44+X_bang+20);
    
    _TitleView.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:144.0/255.0 blue:242.0/255.0 alpha:1];
    [self.view addSubview:_TitleView];
    
    UILabel *TitleText = [UILabel new];
    [_TitleView addSubview:TitleText];
    
    
    
    
    //TitleText.text = @"我的历史设备";
    TitleText.text = setCountry(@"wodelishishebei");
    
    
    TitleText.textColor = [UIColor whiteColor];
    
    [TitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.centerX.equalTo(_TitleView);
        make.centerY.mas_equalTo(_TitleView.mas_centerY).with.offset(X_bang/2.0+10);
    }];
    //TitleText.font = [UIFont systemFontOfSize:20];
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

-(void)click:(UIButton *)btn{
    //返回
    if (btn.tag==101) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 创建tableview
-(void)createTable{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+X_bang+20, XScreenWidth, XScreenHeight-(44+X_bang+20)-X_bottom)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 60;
    _tableView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    _arr = [NSArray array];
    NSString *deviceStr  = @"";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"Device"]) {
        
    }else{
        deviceStr = [userDefaults objectForKey:@"Device"];
        NSArray  *array = [deviceStr componentsSeparatedByString:@"*"];
        _arr = array;
        NSLog(@"=== _arr%@==", _arr);
    }
   
   
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count-1;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"idd";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    //     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    
    cell.textLabel.text =[NSString stringWithFormat:@"共享WiFi翻译机    %@",_arr[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.imageView.image = [UIImage imageNamed:@"historyImg.png"];
    
    
    //    设置右边箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //   点击闪一闪
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *str = [cell.textLabel.text stringByReplacingOccurrencesOfString:@"共享WiFi翻译机    " withString:@""];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:setCountry(@"shifouchongxinlianjieshebei")] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:setCountry(@"quxiao") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    //连接设备
    [alert addAction:[UIAlertAction actionWithTitle:setCountry(@"lianjieshebei") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        YXManager *manager = [YXManager share];
        manager.ScanID = str;
        manager.isScan = YES;
        manager.isBind = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:setCountry(@"bulianjieshebei") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YXManager *manager = [YXManager share];
        manager.isBind = NO;
        manager.isScan = YES;
        manager.ScanID = str;
        [self.navigationController popToRootViewControllerAnimated:YES];
       
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
    
    
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
