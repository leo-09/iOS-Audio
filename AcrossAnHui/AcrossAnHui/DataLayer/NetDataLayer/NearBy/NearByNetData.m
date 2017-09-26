//
//  NearByNetData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/31.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "NearByNetData.h"

@implementation NearByNetData

- (void) getAllFastDealInfoWithCity:(NSString *)city province:(NSString *)province tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"city": (city ? city : defaultCity),
                            @"province": (province ? province : defaultProvice)
                          };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    // paramsForCacheKey：缓存区分城市
    [self httpPostCacheRequest:FasterCenter_URL params:params paramsForCacheKey:dict requestModel:model];
}

- (void) getAllIllegalDisposalSiteInfoWithCity:(NSString *)city province:(NSString *)province tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"city": (city ? city : defaultCity),
                            @"province": (province ? province : defaultProvice)
                          };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    // paramsForCacheKey：缓存区分城市
    [self httpPostCacheRequest:WeiZhangStation_URL params:params paramsForCacheKey:dict requestModel:model];
}

@end
