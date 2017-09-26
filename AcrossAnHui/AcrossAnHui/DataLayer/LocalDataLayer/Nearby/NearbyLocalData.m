//
//  NearbyLocalData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "NearbyLocalData.h"

@implementation NearbyLocalData

#pragma mark - 单例模式

static NearbyLocalData *instance;

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
        _yyCache = [YYCache cacheWithName:ClearableLocalCache];
    }
    
    return self;
}

#pragma mark - public method

/**
 根据key 查找其搜索记录
 
 @param key 健值
 @return 保存的搜索记录
 */
- (NSMutableArray *) queryAnnotationsWithKey:(NSString *)key {
    NSMutableArray *result = (NSMutableArray *)[_yyCache objectForKey:key];
    return result;
}

/**
 根据key 覆盖其搜索记录
 
 @param annos 搜索记录
 @param key key
 */
- (void) coverAnnotations:(NSArray *) annos key:(NSString *)key {
    [_yyCache setObject:annos forKey:key];
}

/**
 根据key 删除其搜索记录
 
 @param key key
 */
- (void) removeAnnotationsWithKey:(NSString *)key {
    [_yyCache removeObjectForKey:key];
}

@end
