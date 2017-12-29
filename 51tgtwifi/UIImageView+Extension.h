//
//  UIImageView+Extension.h
//  text
//
//  Created by 格式化油条 on 15/9/10.
//  Copyright (c) 2015年 XQBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

/** 根据图片名创建imageView */
+ (instancetype)imageViewWithImageName:(NSString *)imageName;
/** 根据图片名创建一张圆形图片，默认半径为50 */
+ (instancetype)imageViewWithClipsOfImageName:(NSString *)imageName;
/** 根据图片名与裁剪半径创建一张图形图片 */
+ (instancetype)imageViewWithClipsOfImageName:(NSString *)imageName atRadius:(CGFloat)radius;
/** 水平分隔线 */
+ (UIImageView *)horizontalSeparateImageView;
/** 垂直分隔线 */
+ (UIImageView *)verticalSeparateImageView;

@end
