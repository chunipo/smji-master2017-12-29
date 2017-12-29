//
//  YXManager.m
//  51tgtwifi
//
//  Created by DEVCOM on 2017/12/20.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "YXManager.h"
// 创建静态对象 防止外部访问
static YXManager * _singletonVC;
@implementation YXManager
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    // 一次函数
    dispatch_once(&onceToken, ^{
        if (_singletonVC == nil) {
            _singletonVC = [super allocWithZone:zone];
        }
    });
    
    return _singletonVC;
}
+ (instancetype)share{
    
    return  [[self alloc] init];
}

+(void)str{
    
    
}

-(PackagInfoModel *)model{
    if (!_model) {
        _model = [[PackagInfoModel alloc]init];
    }
    return _model;
}

-(PackagInfoModel *)modelTranslate{
    if (!_modelTranslate) {
        _modelTranslate = [[PackagInfoModel alloc]init];
    }
    return _modelTranslate;
}


-(PackagInfoModel *)modelGlobal{
    if (!_modelGlobal) {
        _modelGlobal = [[PackagInfoModel alloc]init];
    }
    return _modelGlobal;
}

@end
