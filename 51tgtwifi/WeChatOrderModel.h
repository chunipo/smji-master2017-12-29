//
//  WeChatOrderModel.h
//  Pay
//
//  Created by 董立峥 on 2017/5/23.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeChatOrderModel : NSObject
@property (nonatomic,copy)NSString * nonceStr;
@property (nonatomic,copy)NSString * package;
@property (nonatomic,copy)NSString * partnerId;
@property (nonatomic,copy)NSString * prepayId;
@property (nonatomic,copy)NSString * sign;
@property (nonatomic,assign)NSInteger timeStamp;

@property (nonatomic,copy)NSString * out_order_no;//支付成功返回服务器确认


@property (nonatomic,copy)NSString * error;




@property (nonatomic,copy)NSString * payType;



@end
