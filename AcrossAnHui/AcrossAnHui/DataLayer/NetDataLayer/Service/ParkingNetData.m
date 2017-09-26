//
//  ParkingNetData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingNetData.h"

@implementation ParkingNetData

- (void) selectPackinfoByCardWithToken:(NSString *)token userId:(NSString *)userId longitude:(double)longitude latitude:(double)latitude tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:@(longitude) forKey:@"currentLongitude"];
    [params setObject:@(latitude) forKey:@"currentLatitude"];
    
    NSDictionary *cacheKey = @{ @"userID" : (userId ? userId : @""),
                                @"currentLongitude": @(longitude),
                                @"currentLatitude": @(latitude) };
    
    [self httpPostPriorUseCacheRequest:Parking_Home_URL params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) pushToOperatorWithToken:(NSString *)token siteId:(NSString *)siteId tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(siteId? siteId : @"") forKey:@"siteId"];
    
    [self httpPostRequest:PushToOperator_URL params:params requestModel:model];
}

- (void) selectSiteListWithSitename:(NSString *)sitename longitude:(double)longitude latitude:(double)latitude page:(int)currentPage tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(sitename ? sitename : @"") forKey:@"sitename"];
    [params setObject:[NSString stringWithFormat:@"%.6lf", longitude] forKey:@"currentLongitude"];
    [params setObject:[NSString stringWithFormat:@"%.6lf", latitude] forKey:@"currentLatitude"];
    [params setObject:@(currentPage) forKey:@"currentPage"];
    
    NSDictionary *cacheKey = @{ @"currentLongitude": @(longitude),
                                @"currentLatitude": @(latitude),
                                @"currentPage" : @(currentPage) };
    
    [self httpPostCacheRequest:SelectSiteList_URL params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) selectAllSiteListWithSitename:(NSString *)sitename longitude:(double)longitude latitude:(double)latitude tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(sitename ? sitename : @"") forKey:@"sitename"];
    [params setObject:[NSString stringWithFormat:@"%.6lf", longitude] forKey:@"currentLongitude"];
    [params setObject:[NSString stringWithFormat:@"%.6lf", latitude] forKey:@"currentLatitude"];
    
    NSDictionary *cacheKey = @{ @"currentLongitude": @(longitude),
                                @"currentLatitude": @(latitude) };
    
    [self httpPostPriorUseCacheRequest:Select_All_Site_List params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) selectAreaGroupListWithCityName:(NSString *)cityName tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.successIden = @"100";
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(cityName ? cityName : @"") forKey:@"cityName"];
    
    [self httpPostPriorUseCacheRequest:SelectAreaGroupList_URL params:params paramsForCacheKey:params requestModel:model];
}

// 查询附近列表页 SelectSiteList_URL
- (void) selectSiteListWithSiteID:(NSString *)siteID siteName:(NSString *)siteName areacode:(NSString *)areacode
                         sorttype:(NSString *)sorttype longitude:(double)longitude latitude:(double)latitude
                             page:(int)currentPage tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%.6lf", longitude] forKey:@"currentLongitude"];
    [params setObject:[NSString stringWithFormat:@"%.6lf", latitude] forKey:@"currentLatitude"];
    [params setObject:(areacode ? areacode : @"") forKey:@"areacode"];
    [params setObject:(siteID ? siteID : @"") forKey:@"siteid"];
    [params setObject:(siteName ? siteName : @"") forKey:@"sitename"];
    [params setObject:(sorttype ? sorttype : @"") forKey:@"sorttype"];
    [params setObject:@(currentPage) forKey:@"currentPage"];
    
    [self httpPostPriorUseCacheRequest:SelectSiteList_URL params:params paramsForCacheKey:params requestModel:model];
}

- (void)getSiteByIdWithSiteID:(NSString *)siteID longitude:(double)longitude latitude:(double)latitude tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(siteID ? siteID : @"") forKey:@"id"];
    [params setObject:[NSString stringWithFormat:@"%.6lf", longitude] forKey:@"currentLongitude"];
    [params setObject:[NSString stringWithFormat:@"%.6lf", latitude] forKey:@"currentLatitude"];
    
    [self httpPostPriorUseCacheRequest:Get_Site_By_Id params:params paramsForCacheKey:params requestModel:model];
}

- (void) immediatePaymentFinishWithToken:(NSString *)token orderNum:(NSString *)orderNum tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(orderNum ? orderNum : @"") forKey:@"orderNum"];
    
    [self httpPostRequest:ImmediatePaymentFinish_URL params:params requestModel:model];
}

- (void) selectOdueWithToken:(NSString *)token tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    
    [self httpPostRequest:SelectOdue_URL params:params requestModel:model];
}

@end
