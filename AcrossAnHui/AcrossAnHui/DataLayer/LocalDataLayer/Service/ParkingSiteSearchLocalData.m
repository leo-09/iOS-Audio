//
//  ParkingSiteSearchLocalData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingSiteSearchLocalData.h"
#import "ParkingSiteRecordModel.h"

static NSString *SearchSiteInfoKey = @"SearchSiteInfoKey";

@implementation ParkingSiteSearchLocalData

#pragma mark - 单例模式

static ParkingSiteSearchLocalData *instance;

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

- (NSMutableArray *) queryAllRecord {
    //根据key读取数据
    id result = [_yyCache objectForKey:SearchSiteInfoKey];
    
    if (result) {
        ParkingSiteRecordModel *model = (ParkingSiteRecordModel *) result;
        return model.siteModels;
    } else {
        return [[NSMutableArray alloc] init];
    }
}

- (void) addRecord:(SiteModel *) record {
    ParkingSiteRecordModel *model;
    
    id result = [_yyCache objectForKey:SearchSiteInfoKey];
    
    if (result) {
        model = (ParkingSiteRecordModel *) result;
        
        for (SiteModel *site in model.siteModels) {
            if ([site.siteID isEqualToString:record.siteID]) {
                // 有重复的，则不保存
                return;
            }
        }
    } else {
        model = [[ParkingSiteRecordModel alloc] init];
        model.siteModels = [[NSMutableArray alloc] init];
    }
    
    // 没有重复的，则添加
    [model.siteModels insertObject:record atIndex:0];
    
    while (model.siteModels.count > 5) {
        [model.siteModels removeLastObject];
    }
    
    // 保存
    [_yyCache setObject:model forKey:SearchSiteInfoKey];
}

- (void) removeAllRecord {
    //根据key移除缓存
    [_yyCache removeObjectForKey:SearchSiteInfoKey withBlock:^(NSString * _Nonnull key) {
        NSLog(@"removeObjectForKey %@", key);
    }];
}

@end
