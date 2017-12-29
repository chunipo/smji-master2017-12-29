//
//  Network.h
//  PtahInteractive
//
//  Created by ptah on 16/8/22.
//  Copyright © 2016年 Ptah. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SuccessBlock)(id data);
typedef void(^FailureBlock)(NSString *error);


@interface NetWork : NSObject

+ (void)sendGetNetWorkWithUrl:(NSString *)url parameters:(NSDictionary *)dict hudView:(UIView *)hudView successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;


+ (void)PostNetWorkWithUrl:(NSString *)url parameters:(NSDictionary *)dict hudView:(UIView *)hudView successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;


+ (void)PutNetWorkWithUrl:(NSString *)url parameters:(NSDictionary *)dict hudView:(UIView *)hudView successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;


-(BOOL)showSchedule:(UIView *)view;

-(BOOL)hideSchedule;


@end
