//
//  ShoppingVc.m
//  51tgtwifi
//
//  Created by TGT on 2017/10/17.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "ShoppingVc.h"
#import "NSString+SHA256.h"
#import "ProductMo.h"
#import "PayViewController.h"
#import "ShopTabCell.h"
#import "DetailVc.h"
#import "LoadingViewForOC.h"
#import "YXManager.h"





@interface ShoppingVc ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView        *_tableView;
    
    NSMutableArray     *_arr;
    
    MBProgressHUD      *hud;

    LoadingViewForOC   *_loadView;
    
    YXManager          *_manager;
}


//加载图像
//@property(nonatomic,strong)LoadingViewForOC *loadView;

@end

@implementation ShoppingVc

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _manager = [YXManager share];
    // 初始化数组
    _arr = [NSMutableArray arrayWithCapacity:0];
    // 背景图片
    [self setBackgroudImage];
    // 创建标题
    [self HeadTitle];
    // 网络请求
    [self httpRequest];
  
    



}

#pragma mark - 设置背景图片
-(void)setBackgroudImage{
   // self.view.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:84.0/255.0 blue:178.0/255.0 alpha:1];
    UIImageView *backgroud = [[UIImageView alloc]init];
    backgroud.frame = CGRectMake(0, 0, XScreenWidth,XScreenHeight);

    backgroud.image = [UIImage imageNamed:@"ic_bg.jpg"];
    
    [self.view addSubview:backgroud];
}

#pragma mark - 显示进度条

-(void)showSchdu{
    _loadView = [LoadingViewForOC showLoadingWith:self.view];
}

-(void)hideSchdu{
    [_loadView hideLoadingView];
    
}




#pragma mark -网络请求数据
-(void)httpRequest{
    [self showSchdu];
    NSString *str ;
    NSString *MoneyType;
    if ([_manager.TrueLanguageStr containsString:@"zh-H"]) {
        MoneyType = @"RMB";
    }else if([_manager.TrueLanguageStr containsString:@"ja"]){
        MoneyType = @"JPY";
    }else{
        MoneyType = @"USD";
    }
    if (isBeta) {
        str = [NSString stringWithFormat:DoorOpen,PicHead,@"TGT23170126536",@"RMB"];
    }else{
        str = [NSString stringWithFormat:DoorOpen,PicHead,_manager.ScanID,MoneyType];
    }
    
    [NetWork sendGetNetWorkWithUrl:str parameters:nil hudView:self.view successBlock:^(id data) {
            
        NSDictionary *dic1 = data[@"data"];
        NSArray *arr = dic1[@"products"];
        NSLog(@"data==================%@",arr);
            for (NSDictionary *dic in arr) {
                ProductMo *ProModel = [[ProductMo alloc]init];
                
                [ProModel setValuesForKeysWithDictionary:dic];
                [ProModel setValue:dic[@"id"] forKey:@"ProductId"];
                
                [_arr addObject:ProModel];
            }
            
        if (!_tableView) {
            [self createTableView];
        }
        
            
        } failureBlock:^(NSString *error) {
            [self hideSchdu];
            NSLog(@"什么鬼？？？？？？");
            UIImageView *errorImg = [[UIImageView alloc]initWithFrame:CGRectMake((XScreenWidth-128)/2, (XScreenHeight-128)/2, 128, 128)];
            errorImg.image = [UIImage imageNamed:@"netError.png"];
            [self.view addSubview:errorImg];
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake((XScreenWidth-150)/2, errorImg.maxY+10, 150, 50)];
            lab.text = @"当前无可用网路";
            lab.textColor = [UIColor grayColor];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont systemFontOfSize:18];
            [self.view addSubview:lab];
    
        }];
    

}


#pragma mark - 创建标题栏
-(void)HeadTitle{
    UIView *_TitleView = [[UIView alloc]init];
    _TitleView.frame =CGRectMake(0, 20+X_bang, XScreenWidth, 44);
   
    _TitleView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_TitleView];
    
    UILabel *TitleText = [UILabel new];
    [_TitleView addSubview:TitleText];

    TitleText.text = setCountry(@"title");
    //TitleText.text = @"流量商城";
//    TitleText.text = NSLocalizedString(@"title", nil);
    TitleText.textColor = [UIColor whiteColor];
    TitleText.font = [UIFont systemFontOfSize:19];
    [TitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(_TitleView);
        make.size.mas_equalTo(CGSizeMake(150, 50));
    }];
    
    TitleText.textAlignment = 1;
}


#pragma mark - 创建tablewview
-(void)createTableView{
    
    [self hideSchdu];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20+44+X_bang, XScreenWidth, XScreenHeight-44-49-20-X_bang-X_bottom) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //_tableView.rowHeight = 225;
    _tableView.rowHeight = 420*XScreenWidth/603+60;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arr.count;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopTabCell *cell = [ShopTabCell CellWithtable:tableView];
    
    cell.model = _arr[indexPath.row];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopTabCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //   点击闪一闪
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

  
     DetailVc *vc = [[DetailVc alloc]init];
    
    vc.DetailUrl =  ((ProductMo *)_arr[indexPath.row]).url;
    vc.DetailTitle =  ((ProductMo *)_arr[indexPath.row]).title;
    vc.type =  ((ProductMo *)_arr[indexPath.row]).price_type;
    //vc.type = @"RMB";
    vc.price = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:cell.model.price]];
    _manager.Product_id = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:cell.model.ProductId]];
    _manager.OrderPrice = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:cell.model.price]];
    [self.navigationController pushViewController:vc animated:YES];

    
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
