//
//  SingletonView.m
//  Test
//
//  Created by liaomingming on 2017/7/13.
//  Copyright © 2017年 liaomingming. All rights reserved.
//

#import "SingletonView.h"

#define SCREEN_RECT [[UIScreen mainScreen] bounds]

@interface SingletonView (){
    
    UIActivityIndicatorView  *activityIndicator;
    UILabel *activityIndicatorLabel;
    UIImageView *img;
}

@end


@implementation SingletonView

static SingletonView *viewObject = nil;

+ (void)showSingleViewWithTitle:(NSString *)title imageName:(NSString *)imgName inParentView:(UIView *)parentView isSuc:(BOOL)isSuc{
    
    SingletonView *obj = [SingletonView sharedSingletonView];
    
    NSLog(@"%p",obj);//都是同一个地址
    
    [obj singleViewWithTitle:title inParentView:parentView isSuc:isSuc];
    
}

+ (void)hideWaitView
{
    
    [viewObject removeFromSuperview];
}

+ (instancetype)sharedSingletonView{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        viewObject = [[super allocWithZone:NULL] init];
    });

    return viewObject;
}

+ (instancetype)alloc{
    
    
    return [SingletonView sharedSingletonView];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    return [SingletonView sharedSingletonView];
}




#pragma mark - override

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        self = [self customInitMethod];
        
    }
    
    return self;
}


- (instancetype)customInitMethod{

    self.layer.cornerRadius = 6.0f;
    self.backgroundColor = [UIColor grayColor];
    self.alpha = 1;
//    activityIndicator = [[UIActivityIndicatorView alloc]
//                         initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
//    img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"currect.png"] highlightedImage:nil];
//
//    [self addSubview:img];
    

    activityIndicatorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    activityIndicatorLabel.textAlignment = NSTextAlignmentCenter;
    [activityIndicatorLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [activityIndicatorLabel setNumberOfLines:0];
    [activityIndicatorLabel setFont:[UIFont systemFontOfSize:13]];
    activityIndicatorLabel.backgroundColor = [UIColor clearColor];
    activityIndicatorLabel.textColor = [UIColor whiteColor];
    [self addSubview:activityIndicatorLabel];
   

    
    return self;
}



- (void)singleViewWithTitle:(NSString *)title inParentView:(UIView *)parentView isSuc:(BOOL)isSuc{
    if (isSuc) {
        img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"currect.png"] highlightedImage:nil];
        img.frame = CGRectMake(60.0f, 10.0f, 40.0f, 40.0f);
        [self addSubview:img];
    }else{
        img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fasle.png"] highlightedImage:nil];
        img.frame = CGRectMake(55.0f, 10.0f, 50.0f, 50.0f);
        [self addSubview:img];
    }
    CGSize contentSize = [self textConstraintSize:title];

    viewObject.frame = CGRectMake(0, 0, 160,20 +50 + contentSize.height);
    activityIndicatorLabel.frame = CGRectMake(5.0f,60.0f ,150.0f, contentSize.height);
    
    viewObject.center = CGPointMake(SCREEN_RECT.size.width/2, SCREEN_RECT.size.height/2 - 50);

    activityIndicatorLabel.text = title;

    [activityIndicator startAnimating];

    [parentView addSubview:viewObject];
    
    
    [[self class] performSelector:@selector(hideWaitView) withObject:nil afterDelay:2];//如果要在外部调用hideWaitView方法，需将此处注释
    
}


- (CGSize)textConstraintSize:(NSString *)text
{
    CGSize constraint = CGSizeMake(150, 20000.0f);
    
    return [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
}


@end
