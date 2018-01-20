//
//  LanguageViewController.m
//  51tgtwifi
//
//  Created by TGT on 2017/10/24.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "LanguageViewController.h"
#import "AppDelegate.h"
#import "MainTabbarController.h"
#import "MainNavVc.h"

@interface LanguageViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>

{
    UITableView     *_tableView;
    NSArray         *_arr;
    UITableViewCell *_FirstCell;
    
    NSInteger       _isWhatLanguage;//判断选中了什么语言
    NSInteger       _isNowtLanguage;//判断当前语言
    UIButton        *btn2;//完成 按钮
    
    UIView          *_TitleView;
    
    MBProgressHUD   *hud;
    
}

@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    _isWhatLanguage = 0;
    [self islang];
    [self createTableview];
    
    //    标题栏
    [self HeadTitle];
    
}
#pragma mark 判断当前语言
-(void)islang{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userDefaults objectForKey:@"changeLan"];
    if ([str containsString:@"zh-Hans"]) {
        _isNowtLanguage = 0;
    }else if ([str containsString:@"zh-Hant"]){
        _isNowtLanguage = 1;
    }else if ([str containsString:@"en"]){
        _isNowtLanguage = 2;
    }else if ([str containsString:@"ja"]){
        _isNowtLanguage = 3;
    }else{
        _isNowtLanguage = 0;
    }
    _isWhatLanguage = _isNowtLanguage;
}
#pragma mark - 显示进度条

-(void)showSchdu{
    hud =   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    
    hud.color = [UIColor grayColor];
    
    [hud showAnimated:YES];
}

-(void)hideSchdu{
    [hud hideAnimated:YES];
}


#pragma mark - 创建标题栏
-(void)HeadTitle{
    UIView *_TitleView = [[UIView alloc]init];
    _TitleView.frame =CGRectMake(0, 0, XScreenWidth, 44+X_bang+20);
    
    _TitleView.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:144.0/255.0 blue:242.0/255.0 alpha:1];
    [self.view addSubview:_TitleView];
    
    UILabel *TitleText = [UILabel new];
    [_TitleView addSubview:TitleText];
    
    //TitleText.text = @"设置语言";
    TitleText.text = setCountry(@"shezhiyuyan");
    TitleText.textColor = [UIColor whiteColor];
    
    [TitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_TitleView);
        make.centerY.mas_equalTo(_TitleView.mas_centerY).with.offset(X_bang/2.0+10);
 
    }];
    
    TitleText.textAlignment = 1;
    
    
//    取消按钮
    UIButton *btn = [UIButton new];
    [_TitleView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_TitleView).offset(0);
        
        make.centerY.mas_equalTo(_TitleView.mas_centerY).with.offset(X_bang/2.0+10);
        
         make.size.mas_equalTo(CGSizeMake(85, 80));
        
        
    }];
    
    btn.tag = 101;
    btn.titleLabel.font  = [UIFont systemFontOfSize:16];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn setTitle:setCountry(@"quxiao") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    设置语言
    btn2 = [UIButton new];
    [_TitleView addSubview:btn2];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_TitleView).offset(0);
        
        make.centerY.mas_equalTo(_TitleView.mas_centerY).with.offset(X_bang/2.0+10);
        
        make.size.mas_equalTo(CGSizeMake(80, 80));
        
        
    }];
    
    btn2.tag = 102;
    btn2.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn2 setTitle:setCountry(@"wancheng") forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor colorWithRed:236.0/255.0  green:236.0/255.0  blue:236.0/255.0  alpha:0.5] forState:UIControlStateDisabled];
    [btn2 setEnabled:NO];
    [btn2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)click:(UIButton *)btn{
    if (btn.tag==101) {
          [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (btn.tag == 102)
    {
        NSArray *lans;
        [self showSchdu];
        if (_isWhatLanguage==0) {
            // 切换语言。简体中文  zh-Hans    繁体中文  zh-Hant  英语 en  日文  ja
            lans = @[@"zh-Hans"];
           
            
//            // 切换语言后
//            NSArray *langArr2 = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
//            NSString *language2 = langArr2.firstObject;
//            NSLog(@"模拟器语言切换之后：%@",language2);


        }else if (_isWhatLanguage==1){
            // 切换语言。简体中文  zh-Hans    繁体中文  zh-Hant  英语 en  日文  ja
            lans = @[@"zh-Hant"];
    
        }else if (_isWhatLanguage==2){
            // 切换语言。简体中文  zh-Hans    繁体中文  zh-Hant  英语 en  日文  ja
            lans = @[@"en"];
           
        }else if (_isWhatLanguage==3){
            // 切换语言。简体中文  zh-Hans    繁体中文  zh-Hant  英语 en  日文  ja
            lans = @[@"ja"];
        
        }else{}
        
       //语言转换开始
        [self changeLanguage:lans];
    }
  

}

#pragma mark - 语言转换开始--
-(void)changeLanguage:(NSArray *)lans{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceStr = @"";
    NSString *strMut  = @"";
    if (![userDefaults objectForKey:@"changeLan"]) {
        deviceStr = lans.firstObject;
        NSLog(@"===strmut%@",deviceStr);
        [[NSUserDefaults standardUserDefaults ]setObject:deviceStr forKey:@"changeLan"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else{
        deviceStr = [userDefaults objectForKey:@"changeLan"];
        //        strMut = [deviceStr mutableCopy];
        NSLog(@"===strmut%@",deviceStr);
      
            strMut =lans.firstObject;
            [userDefaults removeObjectForKey:@"changeLan"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults ]setObject:strMut forKey:@"changeLan"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSLog(@"===strmut%@",[userDefaults objectForKey:@"changeLan"]);
    }
    //启动语言转换。
    [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
        [_TitleView removeFromSuperview];
        [self hideSchdu];
        AppDelegate *appDelegate =
        (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [[MainNavVc alloc]initWithRootViewController:[[MainTabbarController alloc]init]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SetLanguage" object:nil];
        
        
        
        
        //                double delayInSeconds2 = 1.0;
        //                dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds2 *NSEC_PER_SEC);
        //                dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
        //                    //执行事件
        //
        //                });
        
        
        
    });


}


#pragma mark -创建tableview
-(void)createTableview{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44+X_bang+20, XScreenWidth, XScreenHeight-(44+X_bang+20)) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.rowHeight = 60;
    _tableView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    _tableView.sectionHeaderHeight = 20;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    _arr = @[@"Simplified Chinese(简体中文)",@"traditional Chinese(繁体中文)",@"English",@"Japanese"];
    
   
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _arr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"idd";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
   
    if (indexPath.row==_isNowtLanguage) {
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
        
        _FirstCell = cell;

    }
    
    cell.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    cell.textLabel.text = _arr[indexPath.row];
    
    
    

    
    //    设置左边小图标
    //    NSArray *images = @[@[@"",@"",@"",@"",@"",@""],@[@"",@"",@"",@""]];
    //
    //    cell.imageView.image = [UIImage imageNamed:images[indexPath.section][indexPath.row]];
    
    
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
//    把第一行☑️去掉
    if (indexPath.row!=_isNowtLanguage) {
        _FirstCell.accessoryType = UITableViewCellAccessoryNone;
        [btn2 setEnabled:YES];
    }else{
       [btn2 setEnabled:NO];
    }
    
    _isWhatLanguage = indexPath.row;
    
         UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
        //    设置右边箭头
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        [_tableView reloadInputViews];
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //    设置右边箭头
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [_tableView reloadInputViews];

    
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
