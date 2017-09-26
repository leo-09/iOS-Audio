
//
//  AdvertisementLocalData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "AdvertisementLocalData.h"

static NSString *advertisementModelKey = @"AdvertisementModelKey";

@implementation AdvertisementLocalData

#pragma mark - 单例模式

static AdvertisementLocalData *instance;

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

- (void) saveAdvertisementModel:(AdvertisementModel *)loginModel {
    [_yyCache setObject:loginModel forKey:advertisementModelKey withBlock:^{
        NSLog(@"save AdvertisementModel sucess");
    }];
}

- (void) removeAdvertisementModel {
    [_yyCache removeObjectForKey:advertisementModelKey];
}

- (AdvertisementModel *) getAdvertisementModel {
    AdvertisementModel * model = (AdvertisementModel *) [_yyCache objectForKey:advertisementModelKey];
    return model;
}

@end
