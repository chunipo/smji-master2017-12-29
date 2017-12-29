//
//  UIImageView+Extension.m
//  text
//
//  Created by 格式化油条 on 15/9/10.
//  Copyright (c) 2015年 XQBoy. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

/** 根据图片名创建imageView */
+ (instancetype)imageViewWithImageName:(NSString *)imageName {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = imageName.length ? [UIImage imageNamed:imageName] : nil;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sizeToFit];
    return imageView;
}

/** 根据图片名创建一张圆形图片，默认半径为50 */
+ (instancetype)imageViewWithClipsOfImageName:(NSString *)imageName {
    return [self imageViewWithClipsOfImageName:imageName atRadius:0];
}

/** 根据图片名与裁剪半径创建一张图形图片 */
+ (instancetype)imageViewWithClipsOfImageName:(NSString *)imageName atRadius:(CGFloat)radius {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.layer.cornerRadius = radius ? : 50.0;
    [imageView setClipsToBounds:YES];
    return imageView;
}

+ (UIImageView *)horizontalSeparateImageView {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = UIColorFromRGB(0xE8E8E8);
    return imageView;
}

+ (UIImageView *)verticalSeparateImageView {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = UIColorFromRGB(0xE8E8E8);
    return imageView;
}


@end
