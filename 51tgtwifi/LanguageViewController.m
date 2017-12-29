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
    
    NSInteger       _isWhatLanguage;
    
    
    UIView          *_TitleView;
    
    MBProgressHUD   *hud;
    
}

@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isWhatLanguage = 0;
    
    [self createTableview];
    
    //    标题栏
    [self HeadTitle];
    
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
    _TitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, XScreenWidth, 60)];
    
    _TitleView.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:84.0/255.0 blue:178.0/255.0 alpha:1];
    
    [self.view addSubview:_TitleView];
    
    UILabel *TitleText = [UILabel new];
    [_TitleView addSubview:TitleText];
    
    TitleText.text = @"设置语言";
    TitleText.textColor = [UIColor whiteColor];
    
    [TitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(_TitleView);
        make.size.mas_equalTo(CGSizeMake(140, 140));
 
    }];
    
    TitleText.textAlignment = 1;
    
    
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
    
    
//    设置语言
    UIButton *btn2 = [UIButton new];
    [_TitleView addSubview:btn2];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_TitleView).offset(0);
        
        make.centerY.equalTo(TitleText);
        
        make.size.mas_equalTo(CGSizeMake(80, 80));
        
        
    }];
    
    btn2.tag = 102;
    btn2.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn2 setTitle:@"完成" forState:UIControlStateNormal];
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
    //启动语言转换。
    [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
    
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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20+60, XScreenWidth, XScreenHeight-40-64-25) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.rowHeight = 60;
    
    _tableView.sectionHeaderHeight = 20;
    
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
    
   
    if (indexPath.row==0) {
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
        
        _FirstCell = cell;

    }
    
    
    
    
    cell.textLabel.text = _arr[indexPath.row];
    
    
    

    
    //    设置左边小图标
    //    NSArray *images = @[@[@"",@"",@"",@"",@"",@""],@[@"",@"",@"",@""]];
    //
    //    cell.imageView.image = [UIImage imageNamed:images[indexPath.section][indexPath.row]];
    
    
    return cell;
    
    
}

-(void)haha{

    //    语言切换
    // 切换语言前
    NSArray *langArr1 = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *language1 = langArr1.firstObject;
    for (NSString *str  in langArr1) {
        NSLog(@"模拟器语言=：%@",str);
    }
    //    NSLog(@"模拟器语言切换之前：%@",language1);
    
    // 切换语言。简体中文  zh-Hans    繁体中文  zh-Hant  英语 en  日文  ja
    NSArray *lans = @[@"en"];
    [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
    
    // 切换语言后
    NSArray *langArr2 = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *language2 = langArr2.firstObject;
    NSLog(@"模拟器语言切换之后：%@",language2);
    
    
    
    
    AppDelegate *appDelegate =
    (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = [[MainNavVc alloc]initWithRootViewController:[[MainTabbarController alloc]init]];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetLanguage" object:nil];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    把第一行☑️去掉
    if (indexPath.row!=0) {
        _FirstCell.accessoryType = UITableViewCellAccessoryNone;
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
