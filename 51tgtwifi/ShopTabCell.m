//
//  ShopTabCell.m
//  51tgtwifi
//
//  Created by TGT on 2017/10/27.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "ShopTabCell.h"
#import "ProductMo.h"



@interface ShopTabCell ()
{
    UIImageView  *_imageView;
    UILabel      *_title;
    UILabel      *_type;
    UILabel      *_price;
}
@end

@implementation ShopTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(instancetype)CellWithtable:(UITableView *)table{
    static NSString *ID = @"id";
    
    ShopTabCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[ShopTabCell alloc]initWithStyle:0 reuseIdentifier:ID];
        
        [cell addsubviews];
    }
    
    return cell;
    
    
}

-(void)addsubviews{
    _imageView = [UIImageView new];
    
    _title = [UILabel new];
    _type = [UILabel new];
    _price = [UILabel new];
    

    
    [self.contentView addSubview:_imageView];
    [self.contentView addSubview:_title];
    [self.contentView addSubview:_type];
    [self.contentView addSubview:_price];
    
    
    
 
    
}



-(void)setModel:(ProductMo *)model{
    _model = model;
    
    NSString *str = [PicHead stringByAppendingString:model.cover_image_url];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:str] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"#我在shopcell里#商城的图片加载完成思密达");
    }];
    
    //解码
    _title.text = [model.title stringByRemovingPercentEncoding];
    
    //_type.text = model.price_type;
    _type.text =@"RMB";
    _price.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:model.price]];
    
    
    
    _imageView.frame = CGRectMake(0, 0, XScreenWidth, 170);
    
    _title.frame = CGRectMake(10,_imageView.maxY, XScreenWidth/2, 50);
    _title.numberOfLines = 0;
    
    

    _type.frame = CGRectMake(XScreenWidth-120, _title.y+10, 40, 30);
    _price.frame = CGRectMake(_type.maxX+2, _type.y, 60, 30);
    
    
    
    _title.textColor = [UIColor grayColor];
    _type.textColor = [UIColor colorWithRed:53.0/255.0 green:144.0/255.0 blue:242.0/255.0 alpha:1];
    _price.textColor = [UIColor colorWithRed:53.0/255.0 green:144.0/255.0 blue:242.0/255.0 alpha:1];
    
    _title.font = [UIFont systemFontOfSize:17];
    _price.font = [UIFont systemFontOfSize:22];
}





@end
