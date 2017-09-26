//
//  HomeNetData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "HomeNetData.h"

@implementation HomeNetData

- (void) getWeatherWithCity:(NSString *)city priorUseCache:(BOOL)priorUseCache tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.dataFromCacheHint = @"";// 数据取自缓存,不提示
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"city": (city ? city : defaultCity) };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    if (priorUseCache) {
        [self httpPostPriorUseCacheRequest:Weather_Url params:params paramsForCacheKey:dict requestModel:model];
    } else {
        [self httpPostCacheRequest:Weather_Url params:params paramsForCacheKey:dict requestModel:model];
    }
}

- (void) queryOilPriceWithTag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.dataFromCacheHint = @"";// 数据取自缓存,不提示
    model.isRecordOperation = YES;
    model.tag = tag;
    
    [self httpPostPriorUseCacheRequest:OilPrice_Url params:nil paramsForCacheKey:nil requestModel:model];
}

- (void) getModularNewsWithTag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.dataFromCacheHint = @"";// 数据取自缓存,不提示
    model.isRecordOperation = YES;
    model.tag = tag;
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:@"14" forKey:@"id"];// 模块编号
    
    [self httpPostPriorUseCacheRequest:ModularNews_Url params:params paramsForCacheKey:params requestModel:model];
}

- (void) queryCarIllegalInfoWithToken:(NSString *)token userId:(NSString *)userId isPriorUseCache:(BOOL)isCache tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @"") };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    // paramsForCacheKey
    NSDictionary *paramsForCacheKey = @{@"userID":(userId ? userId : @"")};
    
    if (isCache) {
        // 违章详情页的数据，可以优先取缓存
        [self httpPostPriorUseCacheRequest:WZCX_Url params:params paramsForCacheKey:paramsForCacheKey requestModel:model];
    } else {
        // 注意：由于后台服务器不稳定，此处一定要加缓存。缓存的key包含userID，以区分每个用户的缓存
        [self httpPostCacheRequest:WZCX_Url params:params paramsForCacheKey:paramsForCacheKey requestModel:model];
    }
}

- (void) getAppStoreVersionWithTag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.dataFromCacheHint = @"";// 数据取自缓存,不提示
    model.tag = tag;
    
    NSString *url = @"https://itunes.apple.com/lookup?id=1052223055";
    [self httpPostRequest:url params:nil requestModel:model];
}

@end
