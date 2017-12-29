//
//  ProductMo.h
//  51tgtwifi
//
//  Created by TGT on 2017/10/27.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductMo : NSObject

@property(nonatomic,strong)NSString *cover_image_url; //覆盖tableview 上

@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *ProductId;

@property(nonatomic,strong)NSString *money_type; //货币类型

@property(nonatomic,assign)NSInteger price;//价格

@property(nonatomic,strong)NSString *price_type;//支付类型

@property(nonatomic,strong)NSString *url;//详情页

@end



//{
//    "cover_image_url" = "/upload/IMAGE/PRODUCT/NORMAL/20171026/3808e411-e148-4315-a2b9-20b26f7703a8.jpg";
//    id = 1260;
//    "money_type" = "\U00a5";
//    price = 750;
//    "price_type" = JPY;
//    url = "/App/product_info.shtml?pfu_id=1260";
//},
