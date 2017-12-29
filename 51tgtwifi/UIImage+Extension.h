//
//  UIImage+Extension.h
//  01_LimitFree
//
//  Created by lxrent on 15/12/26.
//  Copyright © 2015年 lxrent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageOriginalNamed:(NSString *)imageName;

+ (UIImage *)strechableImage:(NSString *)imageName;

@end
