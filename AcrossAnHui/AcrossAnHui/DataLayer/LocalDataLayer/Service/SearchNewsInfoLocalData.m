//
//  SearchNewsInfoLocalData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SearchNewsInfoLocalData.h"

static NSString *SearchNewsInfoKey = @"SearchNewsInfoKey";

@implementation SearchNewsInfoLocalData

#pragma mark - 单例模式

static SearchNewsInfoLocalData *instance;

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

- (void) queryAllRecordWithBlock:(void (^)(NSString *key, id<NSCoding> object))block {
    //根据key读取数据
    [_yyCache objectForKey:SearchNewsInfoKey withBlock:block];
}

- (void) addRecord:(NSString *) record {
    [self queryAllRecordWithBlock:^(NSString *key, id<NSCoding> object) {
        NSMutableArray *result = (NSMutableArray *)object;
        
        if (!result) {
            result = [[NSMutableArray alloc] init];
            [result addObject:record];
        } else {
            // 排除重复的
            if (![self isContainRecordWithResult:result record:record]) {
                [result addObject:record];
            }
        }
        
        [_yyCache setObject:result forKey:SearchNewsInfoKey withBlock:^{
            NSLog(@"setObject sucess");
        }];
    }];
}

- (void) removeAllRecord {
    //根据key移除缓存
    [_yyCache removeObjectForKey:SearchNewsInfoKey withBlock:^(NSString * _Nonnull key) {
        NSLog(@"removeObjectForKey %@", key);
    }];
}

- (BOOL) isContainRecordWithResult:(NSMutableArray *)result record:(NSString *) record {
    for (NSString *item in result) {
        if ([item isEqualToString:record]) {
            return YES;
        }
    }
    return NO;
}

@end
