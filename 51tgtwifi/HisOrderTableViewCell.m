//
//  HisOrderTableViewCell.m
//  51tgtwifi
//
//  Created by DEVCOM on 2018/1/19.
//  Copyright © 2018年 weiyuxiang. All rights reserved.
//

#import "HisOrderTableViewCell.h"
#import "PackagInfoModel.h"

#define Name_Device [UIScreen mainScreen].bounds.size.width<375?10:15
#define Device_Info [UIScreen mainScreen].bounds.size.width<375?12:15
#define Hmargin  16

@interface HisOrderTableViewCell ()
{
    UIImageView *flowInfoImg;
    UILabel *flowInfo;
    UILabel *tips;
    UILabel *name_GlobaltotalFlow;
    UILabel *name_GlobaleftFlow;
    UILabel *name_GlobaluseCountry;
    UILabel *name_Globalstartime;
    UILabel *name_Globalendtime;
    UILabel *_GlobaltotalFlow;
    UILabel *_GloballeftFlow;
    UILabel *_Globaleffective_countries;
    UILabel *_GlobalstarTime;
    UILabel *_GlobalendTime;
    
}
@end

@implementation HisOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)CellWithtable:(UITableView *)table{
    static NSString *ID = @"id";
    
    HisOrderTableViewCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[HisOrderTableViewCell alloc]initWithStyle:0 reuseIdentifier:ID];
        
        [cell addsubviews];
    }
    
    return cell;
    
    
}

-(void)addsubviews{
    flowInfoImg = [UIImageView new];
    [self addSubview:flowInfoImg];
    flowInfo = [UILabel new];
    [self addSubview:flowInfo];
    tips = [UILabel new];
    [self addSubview:tips];
    name_GlobaltotalFlow = [UILabel new];
    [self addSubview:name_GlobaltotalFlow];
    name_GlobaleftFlow= [UILabel new];
    [self addSubview:name_GlobaleftFlow];
    name_GlobaluseCountry = [UILabel new];
    [self addSubview:name_GlobaluseCountry];
    name_Globalstartime = [UILabel new];
    
    [self addSubview:name_Globalstartime];
    name_Globalendtime = [UILabel new];
    
    [self addSubview:name_Globalendtime];
    _GlobaltotalFlow = [UILabel new];
    
    [self addSubview:_GlobaltotalFlow];
    _GloballeftFlow = [UILabel new];
    
    [self addSubview:_GloballeftFlow];
    _Globaleffective_countries = [UILabel new];
    
    [self addSubview:_Globaleffective_countries];
    _GlobalstarTime = [UILabel new];
    
    [self addSubview:_GlobalstarTime];
    _GlobalendTime = [UILabel new];
    
    [self addSubview:_GlobalendTime];
}

-(void)setModel:(PackagInfoModel *)model{
    _model = model;
    
    if (!model.end_time||[model.end_time isEqualToString:@""]) {
        
    }else{//不为空才读写
        //小图标
       
        [flowInfoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            
            make.top.equalTo(self).with.offset(20);
            make.height.mas_equalTo(@25);
            make.width.mas_equalTo(@25);
        }];
        flowInfoImg.image = [UIImage imageNamed:@"activity_fill.png"];
        
        
        // flowInfo.text =SetLange(@"fanyidingdan");
        [flowInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(flowInfoImg.mas_right).with.offset(10);
            make.right.equalTo(self).with.offset(-10);
            make.top.equalTo(self).with.offset(20);
            make.height.mas_equalTo(@25);
            
            
        }];
        flowInfo.numberOfLines = 0;
        flowInfo.font = [UIFont boldSystemFontOfSize:Name_Device+2];
        
        //使用中的标致
        
        // flowInfo.text =SetLange(@"fanyidingdan");
        [tips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-15);
            make.top.equalTo(flowInfo.mas_bottom).with.offset(Hmargin);
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@55);
            
            
        }];
        // tips.text = @"使用中";
        tips.text = setCountry(@"shiyongzhong");
        tips.textColor = White_Color;
        tips.backgroundColor =[UIColor colorWithRed:53.0/255.0 green:144.0/255.0 blue:242.0/255.0 alpha:1];
        tips.numberOfLines = 0;
        tips.textAlignment = NSTextAlignmentCenter;
        tips.layer.cornerRadius = 10;
        tips.clipsToBounds = YES;
        tips.font = [ UIFont systemFontOfSize:13];
        
        
        //总流量
       
        
        [name_GlobaltotalFlow mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(flowInfo.mas_bottom).with.offset(Hmargin);
            make.right.equalTo(self).with.offset(-10);
            make.left.equalTo(self).with.offset(10);
            make.height.mas_equalTo(@25);
            
        }];
        name_GlobaltotalFlow.text  = setCountry(@"zongliuliang");
        //name_GlobaltotalFlow.text  = @"总流量:";
        name_GlobaltotalFlow.numberOfLines = 0;
        name_GlobaltotalFlow.font = [UIFont boldSystemFontOfSize:Name_Device];
        
        //剩余流量
        
        
        [name_GlobaleftFlow mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(name_GlobaltotalFlow.mas_bottom).with.offset(Hmargin);
            make.right.equalTo(self).with.offset(-10);
            make.left.equalTo(self).with.offset(10);
            make.height.mas_equalTo(@25);
            
        }];
        name_GlobaleftFlow.text  = setCountry(@"shengyuliuliag");
        //name_GlobaleftFlow.text  = @"剩余流量:";
        name_GlobaleftFlow.numberOfLines = 0;
        name_GlobaleftFlow.font = [UIFont boldSystemFontOfSize:Name_Device];
        
        
        //使用国家
        
        
        [name_GlobaluseCountry mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(name_GlobaleftFlow.mas_bottom).with.offset(Hmargin);
            make.right.equalTo(self).with.offset(-10);
            make.left.equalTo(self).with.offset(10);
            make.height.mas_equalTo(@25);
            
        }];
        name_GlobaluseCountry.text  = setCountry(@"shiyongguojia");
        //name_GlobaluseCountry.text  = @"使用国家:";
        name_GlobaluseCountry.numberOfLines = 0;
        name_GlobaluseCountry.font = [UIFont boldSystemFontOfSize:Name_Device];
        
        //开始时间
        
        
        [name_Globalstartime mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(name_GlobaluseCountry.mas_bottom).with.offset(Hmargin);
            make.right.equalTo(self).with.offset(-10);
            make.left.equalTo(self).with.offset(10);
            make.height.mas_equalTo(@25);
            
        }];
        name_Globalstartime.text  = setCountry(@"kaishishjian");
        //name_Globalstartime.text  = @"开始时间:";
        name_Globalstartime.numberOfLines = 0;
        name_Globalstartime.font = [UIFont boldSystemFontOfSize:Name_Device];
        
        //结束时间
        
        
        [name_Globalendtime mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(name_Globalstartime.mas_bottom).with.offset(Hmargin);
            make.right.equalTo(self).with.offset(-10);
            make.left.equalTo(self).with.offset(10);
            make.height.mas_equalTo(@25);
            
        }];
        name_Globalendtime.text  = setCountry(@"jieshushijian");
        //name_Globalendtime.text  = @"结束时间:";
        name_Globalendtime.numberOfLines = 0;
        name_Globalendtime.font = [UIFont boldSystemFontOfSize:Name_Device];
        
        //总流量
        
        
        [_GlobaltotalFlow mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(flowInfo.mas_bottom).with.offset(Hmargin);
            // make.right.equalTo(_view2).with.offset(-10);
            make.left.mas_equalTo(self.frame.size.width/2);
            make.height.mas_equalTo(@25);
            
        }];
        _GlobaltotalFlow.text  = [NSString stringWithFormat:@"%@M",model.flow_count];
        _GlobaltotalFlow.numberOfLines = 0;
        _GlobaltotalFlow.font = [UIFont boldSystemFontOfSize:Name_Device];
        
        //剩余流量
        
        
        [_GloballeftFlow mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_GlobaltotalFlow.mas_bottom).with.offset(Hmargin);
            // make.right.equalTo(_view2).with.offset(-10);
            make.left.mas_equalTo(self.frame.size.width/2);
            make.height.mas_equalTo(@25);
            
        }];
        _GloballeftFlow.text  =  [NSString stringWithFormat:@"%@M",model.left_flow_count];
        _GloballeftFlow.numberOfLines = 0;
        _GloballeftFlow.font = [UIFont boldSystemFontOfSize:Name_Device];
        
        //使用国家
        
        
        [_Globaleffective_countries mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_GloballeftFlow.mas_bottom).with.offset(Hmargin);
            make.right.equalTo(self).with.offset(-10);
            make.left.mas_equalTo(self.frame.size.width/2);
            make.height.mas_equalTo(@25);
            
            
        }];
        _Globaleffective_countries.text  = [model.effective_countries stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _Globaleffective_countries.numberOfLines = 0;
        _Globaleffective_countries.font = [UIFont boldSystemFontOfSize:Name_Device];
        _Globaleffective_countries.userInteractionEnabled = YES;
        [_Globaleffective_countries addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
        
        //开始时间
        
        
        [_GlobalstarTime mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_Globaleffective_countries.mas_bottom).with.offset(Hmargin);
            // make.right.equalTo(_view2).with.offset(-10);
            make.left.mas_equalTo(self.frame.size.width/2);
            make.height.mas_equalTo(@25);
            
        }];
        _GlobalstarTime.text  = model.start_time;
        _GlobalstarTime.numberOfLines = 0;
        _GlobalstarTime.font = [UIFont boldSystemFontOfSize:Name_Device];
        
        //结束时间
        
        
        [_GlobalendTime mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_GlobalstarTime.mas_bottom).with.offset(Hmargin);
            // make.right.equalTo(_view2).with.offset(-10);
            make.left.mas_equalTo(self.frame.size.width/2);
            make.height.mas_equalTo(@25);
            
        }];
        _GlobalendTime.text  =model.end_time;
        _GlobalendTime.numberOfLines = 0;
        _GlobalendTime.font = [UIFont boldSystemFontOfSize:Name_Device];
        
        //赋值
        flowInfo.text = [model.product_name stringByRemovingPercentEncoding];
        if ([model.product_type integerValue]==104) {//判断为翻译订单
            name_GlobaltotalFlow.alpha = 0;
            _GlobaltotalFlow.alpha = 0;
            name_GlobaleftFlow.text  = setCountry(@"youxiaoqi");
            _GloballeftFlow.text  =  @"三年";
        }
        if ([model.flow_status integerValue]==2) {
            tips.alpha = 1;
        }else{
            tips.alpha = 0;
        }
    }
    
}

-(void)labelTap:(UIGestureRecognizer *)tap{
    UILabel *lab =(UILabel *)tap.view;
    if ([self.Opendelegat respondsToSelector:@selector(ShowCountry:)]) {
        [self.Opendelegat ShowCountry:lab.text];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
