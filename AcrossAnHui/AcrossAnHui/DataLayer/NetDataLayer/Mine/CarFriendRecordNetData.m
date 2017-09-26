//
//  CarFriendNetData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendRecordNetData.h"

@implementation CarFriendRecordNetData

- (void)getallkindsofcountNewWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @"") };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *cacheKey = @{ @"userId" : (userId ? userId : @"") };
                                
    [self httpPostCacheRequest:Getallkindsofcount_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) getmyrecommendcardlistWithToken:(NSString *)token userId:(NSString *)userId currentPage:(int)page tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"pageSize" : @"5",
                            @"offset" : @(page)};
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *cacheKey = @{ @"userId" : (userId ? userId : @""),
                                @"pageSize" : @"5",
                                @"offset" : @(page)};
    
    [self httpPostPriorUseCacheRequest:Topic_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) deleteusercommenorcardtlistWithToken:(NSString *)token topicID:(NSString *)topicID tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"id" : (topicID ? topicID : @""),
                            @"type" : @"1"};
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:DelectComment_Url params:params requestModel:model];
}

- (void) getusercommentlistWithToken:(NSString *)token userId:(NSString *)userId type:(int)type currentPage:(int)page tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"type" : [NSString stringWithFormat:@"%d", type],
                            @"pageSize" : @"5",
                            @"offset" : @(page)};
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *cacheKey = @{ @"userId" : (userId ? userId : @""),
                                @"pageSize" : @"5",
                                @"offset" : @(page)};
    
    [self httpPostPriorUseCacheRequest:CommendAndCollect_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) deleteusercommenorcardtlistWithToken:(NSString *)token commentID:(NSString *)commentID tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"id" : (commentID ? commentID : @""),
                            @"type" : @"0"};
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:DeleteCommenorcardtlist_Url params:params requestModel:model];
}

- (void) operatinghourseWithToken:(NSString *)token userID:(NSString *)userID cardID:(NSString *)cardID recordID:(NSString *)recordID tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"id" : (recordID ? recordID : @""),
                            @"type" : @"2",
                            @"user_id" : (userID ? userID : @""),
                            @"card_id" : (cardID ? cardID : @"")
                            };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:DelectCollect_Url params:params requestModel:model];
}

- (void)getTrafficCountWithToken:(NSString *)token userId:(NSString *)userId currentPage:(int)page date:(NSString *)date tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.nilDataIden = @"0";// 没有记录，result=0
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"date" : (date ? date : @""),
                            @"offset" : @(page)};
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *cacheKey = @{ @"userId" : (userId ? userId : @""),
                                @"date" : (date ? date : @""),
                                @"offset" : @(page) };
    
    [self httpPostPriorUseCacheRequest:RoadRecode_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

@end
