//
//  HisOrderTableViewCell.h
//  51tgtwifi
//
//  Created by DEVCOM on 2018/1/19.
//  Copyright © 2018年 weiyuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HisOrderCellCodeDelegate <NSObject>

- (void)ShowCountry:(NSString *)CountryStr;

@end
@class PackagInfoModel;

@interface HisOrderTableViewCell : UITableViewCell

+(instancetype)CellWithtable:(UITableView *)table;

//委托回调接口
@property (nonatomic, weak) id <HisOrderCellCodeDelegate> Opendelegat;
@property(nonatomic,strong)PackagInfoModel *model;

@end
