//
//  WeChatOrderModel.h
//  Pay
//
//  Created by 董立峥 on 2017/5/23.
//  Copyright © 2017年 LW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeChatOrderModel : NSObject

@property (nonatomic,copy)NSString * appid;
@property (nonatomic,copy)NSString * busId;
@property (nonatomic,copy)NSString * error;
@property (nonatomic,copy)NSString * noncestr;
@property (nonatomic,copy)NSString * package;
@property (nonatomic,copy)NSString * partnerid;
@property (nonatomic,copy)NSString * paySign;
@property (nonatomic,copy)NSString * payType;
@property (nonatomic,copy)NSString * prepayid;
@property (nonatomic,copy)NSString * timestamp;

@end
