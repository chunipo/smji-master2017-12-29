//
//  Network.m
//  PtahInteractive
//
//  Created by ptah on 16/8/22.
//  Copyright © 2016年 Ptah. All rights reserved.
//
#import "NetWork.h"
//#import "MBProgressHUD.h"
#import "AFNetworking.h"



@interface NetWork ()
{
    UILabel       *_label;
    
    MBProgressHUD *hud;
   
}
@end

@implementation NetWork

+ (void)sendGetNetWorkWithUrl:(NSString *)url parameters:(NSDictionary *)dict hudView:(UIView *)hudView successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    
   
    
    
   
    AFHTTPSessionManager *manage111 = [AFHTTPSessionManager manager];

 
    manage111.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    NSLog(@"<<url = %@>>", url);
    
   [manage111 GET:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
       id data = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
       
       NSLog(@"#########%@##########",data);
       
       
       
       
       successBlock(data);
       
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       NSLog(@"error:%@", error.localizedDescription);
       
       failureBlock(error.localizedDescription);

       
   }];
    
    
    
    
    
}



+ (void)PostNetWorkWithUrl:(NSString *)url parameters:(NSDictionary *)dict hudView:(UIView *)hudView successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //创建加载条
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    view.center = hudView.center;
    view.color = [UIColor redColor];
    [view startAnimating];
    view.hidesWhenStopped = YES;
    //[hudView addSubview:view];
    
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    manage.requestSerializer=[AFJSONRequestSerializer serializer];
    [manage.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", nil]];

    
    NSLog(@"<<url = %@>>", url);
    
 
    
   [manage POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        [view stopAnimating];
        
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSLog(@"#########%@##########",data);
        
        
        
        
        successBlock(data);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSLog(@"error:%@", error.localizedDescription);
        
        failureBlock(error.localizedDescription);
        
        // [MBProgressHUD hideAllHUDsForView:hudView animated:YES];
        [view stopAnimating];
        
    }];
    
    
}

+ (void)PutNetWorkWithUrl:(NSString *)url parameters:(NSDictionary *)dict hudView:(UIView *)hudView successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    manage.requestSerializer=[AFJSONRequestSerializer serializer];
    [manage.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain" ,nil]];
    
    
    NSLog(@"<<url = %@>>", url);
    
    [manage PUT:url parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSLog(@"#########%@##########",data);
        
        
        
        
        successBlock(data);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@", error.localizedDescription);
        
        failureBlock(error.localizedDescription);
        

    }];
    
    


}


-(BOOL)showSchedule:(UIView *)view{
    hud =   [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    
    hud.color = [UIColor grayColor];
    
    [hud showAnimated:YES];
    
    return YES;


}

-(BOOL)hideSchedule{
    
    [hud hideAnimated:YES];
    
    return YES;

}


//-(void)changgeColor{
//    [UIColor colorWithRed:arc4random()%11*0.1 green:arc4random()%11*0.1  blue:arc4random()%11*0.1  alpha:0.8];
//}
@end
