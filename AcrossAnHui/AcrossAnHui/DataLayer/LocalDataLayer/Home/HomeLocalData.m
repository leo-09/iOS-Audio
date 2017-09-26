//
//  HomeLocalData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "HomeLocalData.h"

static NSString *aMapLocationModelKey = @"aMapLocationModelKey";

@implementation HomeLocalData

#pragma mark - 单例模式

static HomeLocalData *instance;

+ (id) allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (instancetype) sharedInstance {
    static dispatch_once_t oncetToken;
    dispatch_once(&oncetToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id) copyWithZone:(NSZone *)zone {
    return instance;
}

- (instancetype) init {
    if (self = [super init]) {
        _yyCache = [YYCache cacheWithName:LocationDataCache];
    }
    return self;
}

#pragma mark - public method

- (void) saveAMapLocationModel:(AMapLocationModel *)loginModel {
    [_yyCache setObject:loginModel forKey:aMapLocationModelKey withBlock:^{
        NSLog(@"setObject sucess");
    }];
}

- (AMapLocationModel *) getAMapLocationModel {
    //根据key读取数据
    AMapLocationModel * model =(AMapLocationModel *) [_yyCache objectForKey:aMapLocationModelKey];
    return model;
}

@end
