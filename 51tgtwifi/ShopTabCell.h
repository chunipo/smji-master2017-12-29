//
//  ShopTabCell.h
//  51tgtwifi
//
//  Created by TGT on 2017/10/27.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductMo;

@interface ShopTabCell : UITableViewCell

+(instancetype)CellWithtable:(UITableView *)table;


@property(nonatomic,strong)ProductMo *model;

@end
