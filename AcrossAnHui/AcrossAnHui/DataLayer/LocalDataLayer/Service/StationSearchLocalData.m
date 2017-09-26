//
//  StationSearchLocalData.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "StationSearchLocalData.h"
#import "CarInspectStationModel.h"

static NSString *SearchStationInfoKey = @"SearchStationInfoKey";

@implementation StationSearchLocalData

#pragma mark - 单例模式

static StationSearchLocalData *instance;

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
    YYCache *yyCache = [YYCache cacheWithName:ClearableLocalCache];
    NSMutableArray *result = (NSMutableArray *)[yyCache objectForKey:SearchStationInfoKey];
    
    return result;
}

- (void) addRecord:(CarInspectStationModel *) record {
    NSMutableArray *result = [self queryAllRecord];
    
    if (!result) {
        result = [[NSMutableArray alloc] init];
        [result addObject:record];
    } else {
        // 排除重复的
        if (![self isContainRecordWithResult:result record:record.stationName]) {
            [result addObject:record];
        }
    }
    
    [_yyCache setObject:result forKey:SearchStationInfoKey withBlock:^{
        NSLog(@"setObject sucess");
    }];
}

- (void) removeAllRecord {
    //根据key移除缓存
    [_yyCache removeObjectForKey:SearchStationInfoKey];
}

- (BOOL) isContainRecordWithResult:(NSMutableArray *)result record:(NSString *) record {
    for (CarInspectStationModel *item in result) {
        if ([item.stationName isEqualToString:record]) {
            return YES;
        }
    }
    
    return NO;
}

@end
