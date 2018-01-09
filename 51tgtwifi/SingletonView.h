//
//  SingletonView.h
//  Test
//
//  Created by liaomingming on 2017/7/13.
//  Copyright © 2017年 liaomingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingletonView : UIView
 
+ (instancetype)sharedSingletonView;

+ (void)showSingleViewWithTitle:(NSString *)title imageName:(NSString *)imgName inParentView:(UIView *)parentView isSuc:(BOOL)isSuc;

+ (void)hideWaitView;


@end
