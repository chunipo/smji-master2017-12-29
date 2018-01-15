//
//  HistoryOrderVc.m
//  51tgtwifi
//
//  Created by DEVCOM on 2018/1/15.
//  Copyright © 2018年 weiyuxiang. All rights reserved.
//

#import "HistoryOrderVc.h"
#import "PackagInfoModel.h"
#import "YXManager.h"
#define Name_Device [UIScreen mainScreen].bounds.size.width<375?13:17
#define Device_Info [UIScreen mainScreen].bounds.size.width<375?12:15
#define Hmargin  16

@interface HistoryOrderVc ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView       *_tableView;
    NSMutableArray    *_tableArr;
    YXManager         *_manager;
    //最底部在进度条时显示的透明遮挡tabbarview
    UIView            *_viewBack1;
    UIView            *_viewBack2;
   
    //使用国家弹窗
    UIView            *_useCountyView;
}

@end

@implementation HistoryOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _manager = [YXManager share];
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    [self HeadTitle];
    
    [self requestOrder:_manager.ScanID];
}

#pragma mark - 创建标题栏
-(void)HeadTitle{
    UIView *_TitleView = [[UIView alloc]init];
    _TitleView.frame =CGRectMake(0, 0, XScreenWidth, 44+X_bang+20);
    
    _TitleView.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:144.0/255.0 blue:242.0/255.0 alpha:1];
    [self.view addSubview:_TitleView];
    
    UILabel *TitleText = [UILabel new];
    [_TitleView addSubview:TitleText];
    
    
    
    
    TitleText.text = @"历史流量订单";
    //    TitleText.text = NSLocalizedString(@"title", nil);
    
    
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

#pragma mark 网络请求获取数据
-(void)requestOrder:(NSString *)DeviceId{
    _tableArr = [NSMutableArray arrayWithCapacity:0];
    NSString *url = [NSString stringWithFormat:Global_url,_manager.ScanID];
    [NetWork sendGetNetWorkWithUrl:url parameters:nil hudView:self.view successBlock:^(id data) {
        NSArray *arr = [NSArray array];
        arr = data[@"device_order"];
        if (!arr) {
            arr = [NSMutableArray arrayWithCapacity:0];
        }else{
        for (int i= 0; i<arr.count; i++) {
            NSDictionary *dict = arr[i];
            PackagInfoModel *model = [[PackagInfoModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_tableArr addObject:model];
        }
            [self createTbaleView];
    }
    } failureBlock:^(NSString *error) {
        
        
    }];
}

-(void)createTbaleView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+X_bang+20, XScreenWidth, XScreenHeight-(44+X_bang+20)-X_bottom)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.rowHeight = 270;
    _tableView.tableFooterView = [[UIView alloc]init];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"idd";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    PackagInfoModel *model = _tableArr[indexPath.row];
    
    //小图标
    UIImageView *flowInfoImg = [UIImageView new];
    [cell addSubview:flowInfoImg];
    [flowInfoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).with.offset(10);
        
        make.top.equalTo(cell).with.offset(20);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@25);
    }];
    flowInfoImg.image = [UIImage imageNamed:@"activity_fill.png"];
    
    UILabel *flowInfo = [UILabel new];
    [cell addSubview:flowInfo];
    // flowInfo.text =SetLange(@"fanyidingdan");
    [flowInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(flowInfoImg.mas_right).with.offset(10);
        make.right.equalTo(cell).with.offset(-10);
        make.top.equalTo(cell).with.offset(20);
        make.height.mas_equalTo(@25);
        
        
    }];
    flowInfo.numberOfLines = 0;
    flowInfo.font = [UIFont boldSystemFontOfSize:Name_Device+2];
    
    //总流量
    UILabel *name_GlobaltotalFlow = [UILabel new];
    
    [cell addSubview:name_GlobaltotalFlow];
    
    [name_GlobaltotalFlow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(flowInfo.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(cell).with.offset(-10);
        make.left.equalTo(cell).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    //name_GlobaltotalFlow.text  = SetLange(@"zongliuliang");
    name_GlobaltotalFlow.text  = @"总流量:";
    name_GlobaltotalFlow.numberOfLines = 0;
    name_GlobaltotalFlow.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //剩余流量
    UILabel *name_GlobaleftFlow = [UILabel new];
    
    [cell addSubview:name_GlobaleftFlow];
    
    [name_GlobaleftFlow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_GlobaltotalFlow.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(cell).with.offset(-10);
        make.left.equalTo(cell).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    //name_GlobaleftFlow.text  = SetLange(@"shengyuliuliag");
    name_GlobaleftFlow.text  = @"剩余流量:";
    name_GlobaleftFlow.numberOfLines = 0;
    name_GlobaleftFlow.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    
    //使用国家
    UILabel *name_GlobaluseCountry = [UILabel new];
    
    [cell addSubview:name_GlobaluseCountry];
    
    [name_GlobaluseCountry mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_GlobaleftFlow.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(cell).with.offset(-10);
        make.left.equalTo(cell).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    //name_GlobaluseCountry.text  = SetLange(@"shiyongguojia");
    name_GlobaluseCountry.text  = @"使用国家:";
    name_GlobaluseCountry.numberOfLines = 0;
    name_GlobaluseCountry.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //开始时间
    UILabel *name_Globalstartime = [UILabel new];
    
    [cell addSubview:name_Globalstartime];
    
    [name_Globalstartime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_GlobaluseCountry.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(cell).with.offset(-10);
        make.left.equalTo(cell).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    // name_Globalstartime.text  = SetLange(@"kaishishjian");
    name_Globalstartime.text  = @"开始时间:";
    name_Globalstartime.numberOfLines = 0;
    name_Globalstartime.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //结束时间
    UILabel *name_Globalendtime = [UILabel new];
    
    [cell addSubview:name_Globalendtime];
    
    [name_Globalendtime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(name_Globalstartime.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(cell).with.offset(-10);
        make.left.equalTo(cell).with.offset(10);
        make.height.mas_equalTo(@25);
        
    }];
    // name_Globalendtime.text  = SetLange(@"jieshushijian");
    name_Globalendtime.text  = @"结束时间:";
    name_Globalendtime.numberOfLines = 0;
    name_Globalendtime.font = [UIFont boldSystemFontOfSize:Name_Device];
   
    //总流量
    UILabel *_GlobaltotalFlow = [UILabel new];
    
    [cell addSubview:_GlobaltotalFlow];
    
    [_GlobaltotalFlow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(flowInfo.mas_bottom).with.offset(Hmargin);
        // make.right.equalTo(_view2).with.offset(-10);
        make.left.mas_equalTo(cell.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
    }];
    _GlobaltotalFlow.text  = [NSString stringWithFormat:@"%@M",model.flow_count];
    _GlobaltotalFlow.numberOfLines = 0;
    _GlobaltotalFlow.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //剩余流量
    UILabel *_GloballeftFlow = [UILabel new];
    
    [cell addSubview:_GloballeftFlow];
    
    [_GloballeftFlow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_GlobaltotalFlow.mas_bottom).with.offset(Hmargin);
        // make.right.equalTo(_view2).with.offset(-10);
        make.left.mas_equalTo(cell.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
    }];
    _GloballeftFlow.text  =  [NSString stringWithFormat:@"%@M",model.left_flow_count];
    _GloballeftFlow.numberOfLines = 0;
    _GloballeftFlow.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //使用国家
    UILabel *_Globaleffective_countries = [UILabel new];
    
    [cell addSubview:_Globaleffective_countries];
    
    [_Globaleffective_countries mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_GloballeftFlow.mas_bottom).with.offset(Hmargin);
        make.right.equalTo(cell).with.offset(-10);
        make.left.mas_equalTo(cell.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
        
    }];
    _Globaleffective_countries.text  = [model.effective_countries stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _Globaleffective_countries.numberOfLines = 0;
    _Globaleffective_countries.font = [UIFont boldSystemFontOfSize:Name_Device];
    _Globaleffective_countries.userInteractionEnabled = YES;
    [_Globaleffective_countries addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
    
    //开始时间
    UILabel *_GlobalstarTime = [UILabel new];
    
    [cell addSubview:_GlobalstarTime];
    
    [_GlobalstarTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_Globaleffective_countries.mas_bottom).with.offset(Hmargin);
        // make.right.equalTo(_view2).with.offset(-10);
        make.left.mas_equalTo(cell.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
    }];
    _GlobalstarTime.text  = model.start_time;
    _GlobalstarTime.numberOfLines = 0;
    _GlobalstarTime.font = [UIFont boldSystemFontOfSize:Name_Device];
    
    //结束时间
    UILabel *_GlobalendTime = [UILabel new];
    
    [cell addSubview:_GlobalendTime];
    
    [_GlobalendTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_GlobalstarTime.mas_bottom).with.offset(Hmargin);
        // make.right.equalTo(_view2).with.offset(-10);
        make.left.mas_equalTo(cell.frame.size.width/2);
        make.height.mas_equalTo(@25);
        
    }];
    _GlobalendTime.text  =model.end_time;
    _GlobalendTime.numberOfLines = 0;
    _GlobalendTime.font = [UIFont boldSystemFontOfSize:Name_Device];

    //赋值
    flowInfo.text = [model.product_name stringByRemovingPercentEncoding];
    if ([flowInfo.text isEqualToString:@"翻译订单"]) {
        name_GlobaltotalFlow.alpha = 0;
        _GlobaltotalFlow.alpha = 0;
        name_GlobaleftFlow.text  = @"有效期:";
        _GloballeftFlow.text  =  @"三年";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //   点击闪一闪
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark 手势点击，显示详细的可用国家
-(void)labelTap:(UIGestureRecognizer *)labTap{
    UILabel *lab =(UILabel *) labTap.view;
    //弹窗背景
    _viewBack1 = [[UIView alloc]initWithFrame:CGRectMake(0, XScreenHeight-49-X_bottom, XScreenWidth, 49+X_bottom)];
    _viewBack1.backgroundColor = [UIColor blackColor];
    _viewBack1.alpha = 0.3;
    //[[UIApplication sharedApplication].keyWindow addSubview:_viewBack1];
    // [self.view addSubview:_viewBack];
    _viewBack2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight)];
    _viewBack2.backgroundColor = [UIColor blackColor];
    _viewBack2.alpha = 0.3;
    [self.view addSubview:_viewBack2];
    
    //使用国家
    //国家名字
    _useCountyView = [UIView new];
    [self.view addSubview:_useCountyView];
    UILabel *label = [UILabel new];
    [_useCountyView addSubview:label];
    label.textColor = [UIColor blackColor];
    label.text  = [lab.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:Name_Device];
    CGRect tmpRect = [label.text boundingRectWithSize:CGSizeMake(XScreenWidth-30-30, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil] context:nil];
    
    [_useCountyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view);
        make.centerX.mas_equalTo(self.view);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.height.mas_equalTo(ceilf(tmpRect.size.height)+80);
    }];
    _useCountyView.backgroundColor = [UIColor whiteColor];
    _useCountyView.layer.cornerRadius = 10;
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.bottom.mas_offset(-70);
        
    }];
    
    //第一条横线
    UIView *firstLine = [UIView new];
    [_useCountyView addSubview:firstLine];
    firstLine.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:110.0/255.0 blue:148.0/255.0 alpha:1];
    [firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_useCountyView).with.offset(0);
        make.right.equalTo(_useCountyView).with.offset(0);
        make.top.equalTo(label.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@1);
        
    }];
    
    
    UIButton *imagebtn = [UIButton new];
    [_useCountyView addSubview:imagebtn];
    [imagebtn setImage:[UIImage imageNamed:@"dislikeicon_textpage"] forState:UIControlStateNormal];
    [imagebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-10);
        make.centerX.mas_equalTo(_useCountyView);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(36);
    }];
    
    [imagebtn addTarget:self action:@selector(disView) forControlEvents:UIControlEventTouchUpInside];
    [_viewBack1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disView)]];
    [_viewBack2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disView)]];
}

-(void)disView{
    [_viewBack1 removeFromSuperview];
    [_viewBack2 removeFromSuperview];
    [_useCountyView removeFromSuperview];
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
