//
//  ServiceNetDataLayer.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ServiceNetData.h"

@implementation ServiceNetData

- (void) getAdvListById:(NSString *)advID tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.dataFromCacheHint = @"";// 数据取自缓存,不提示
    model.isRecordOperation = YES;
    model.tag = tag;
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:(advID ? advID : @"") forKey:@"id"];
    
    [self httpPostPriorUseCacheRequest:AdvList_Url params:params paramsForCacheKey:params requestModel:model];
}

- (void) getAdvertisementWithTag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.dataFromCacheHint = @"";
    model.offNetHint = @"";
    model.queryFailureHint = @"";
    model.isRecordOperation = YES;
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:@"25" forKey:@"id"];
    
    [self httpPostRequest:AdvList_Url params:params requestModel:model];
}

- (void) getActivityZoneListWithStartPage:(int)page tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"offset": @(page),// 起始页(从0开始)
                            @"pageSize": @"10" };// 每页显示的页数, 默认10
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostPriorUseCacheRequest:Activity_Url params:params paramsForCacheKey:dict requestModel:model];
}

- (void) getNewsListWithName:(NSString *)name currentPage:(int)page tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:@(page) forKey:@"pageNo"];
    
    if (name) {
        [params setObject:name forKey:@"name"];
    }
    
    [self httpPostPriorUseCacheRequest:NewsList_Url params:params paramsForCacheKey:params requestModel:model];
}

- (void) getHotkeywordsWithTag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    [self httpPostCacheRequest:getHotkeywords_URl params:nil paramsForCacheKey:nil requestModel:model];
}

- (void) getAPPSellCarListWithToken:(NSString *)token userId:(NSString *)userId page:(int) page tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"0";
    model.isRecordOperation = YES;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"offset": @(page) };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *paramsForCacheKey = @{ @"userID":(userId ? userId : @""), @"offset": @(page) };
    
    [self httpPostCacheRequest:APPSellCarList_Url params:params paramsForCacheKey:paramsForCacheKey requestModel:model];
}

- (void) saveAppSellInfoWithToken:(NSString *)token carType:(NSString *)carType carTime:(NSString *)carTime
                          mileage:(NSString *)mileage city:(NSString *)city name:(NSString *)name
                            phone:(NSString *)phone tag:(NSString *)tag {
    
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"carType": (carType ? carType : @""),
                            @"carTime": (carTime ? carTime : @""),
                            @"mileage": (mileage ? mileage : @""),
                            @"city": (city ? city : @""),
                            @"name": (name ? name : @""),
                            @"phone": (phone ? phone : @""),
                            @"from": @3 };// 来源： 1 微信 2 安卓 3 ios
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:CarSellInfo_Url params:params requestModel:model];
}

@end
