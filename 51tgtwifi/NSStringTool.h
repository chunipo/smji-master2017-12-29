//
//  NSStringTool.h
//  51tgtwifi
//
//  Created by 51tgt on 2017/11/8.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringTool : NSObject
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+(NSString *)convertToJsonData:(NSDictionary *)dict;
+ (NSString *)arrayToJSONString:(NSArray *)array;
+(NSArray *)stringToJSON:(NSString *)jsonStr;
@end
