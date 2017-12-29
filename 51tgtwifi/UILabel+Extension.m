//
//  UILabel+Extension.m
//  text
//
//  Created by 格式化油条 on 15/9/10.
//  Copyright (c) 2015年 XQBoy. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

/** 自定义文字大小与颜色 */
+ (instancetype)labelWithText:(NSString *)text atColor:(UIColor *)color atTextSize:(CGFloat)size atTextFontForType:(NSString *)type{
    UILabel *label = [[self alloc] init];
    [label setText:text];
    [label setTextColor:color ? : FontGray_Color];
    if ([type isEqualToString:Title_Font]) {
        [label setFont:[UIFont fontWithName:Title_Font size:size]];
    }else if ([type isEqualToString:UserName_Font]){
        [label setFont:[UIFont fontWithName:UserName_Font size:size]];
    }else if ([type isEqualToString:Common_Font]){
        [label setFont:[UIFont  systemFontOfSize:size]];
    }
    return label;
}

@end
