//
//  CoreServeNetData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CoreServeNetData.h"
#import "UseInfoLocalData.h"

@implementation CoreServeNetData

- (void) getNewTrafficListWithCity:(NSString *)city province:(NSString *)province tag:(NSString *)tag {
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
    
    [self httpPostRequest:TrafficList_Url params:params requestModel:model];
}

- (void) getNewTrafficDetailInfoWithEventId:(NSString *) eventId tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"id": (eventId ? eventId : @"") };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostCacheRequest:TrafficDetailInfoById params:params paramsForCacheKey:dict requestModel:model];
}

- (void) addTrafficCountWithToken:(NSString *)token countId:(NSString *)countId type:(NSString *)type tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;// 保留对 路况反馈 的记录
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"countId": (countId ? countId : @""),
                            @"type":(type ? type : @"")
                          };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:addTrafficCount_URL params:params requestModel:model];
}

- (void) getHighSpeedWithPage:(int)page tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"0";
    model.isRecordOperation = YES;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"type": @"highSpeed",
                            @"offset": @(page) };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostPriorUseCacheRequest:HighRoad_Url params:params paramsForCacheKey:dict requestModel:model];
}

- (void) bindingJpushUrlWithToken:(NSString *)token tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // 注册ID
    NSString *regId = [[UseInfoLocalData sharedInstance] getRegistrationID];
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"regId": (regId ? regId : @""),
                            @"type": @"ios" };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:Jpush_BindingUrl params:params requestModel:model];
}

- (void) getJpushStateWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.isRecordOperation = YES;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"type": @"ios" };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *cacheKey = @{@"userID":(userId ? userId : @"")};
    
    [self httpPostCacheRequest:getJpushState_URl params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) updateJpushStateWithToken:(NSString *)token eventState:(BOOL)eventState raodState:(BOOL)raodState tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"type": @"ios",
                            @"eventState": (eventState ? @"1" : @"2"),
                            @"raodState": (raodState ? @"1" : @"2")
                            };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:updateJpushState_Url params:params requestModel:model];
}

- (void) getUserCustomRoadListWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.isRecordOperation = YES;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @"") };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *cacheKey = @{@"userID":(userId ? userId : @"")};
    
    [self httpPostPriorUseCacheRequest:GetCusTomRoad_URL params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) delCustomRoadWithRoadID:(NSString *)roadID token:(NSString *)token tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"id": (roadID ? roadID : @"")};
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:DeleteCusTomroad_URL params:params requestModel:model];
}

- (void) addCustomRoadWithToken:(NSString *)token orderRoadModel:(OrderRoadModel *)roadModel tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;// 保留对 增加定制路况 的记录
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"origin": (roadModel.origin ? roadModel.origin : @""),
                            @"destination": (roadModel.destination ? roadModel.destination : @""),
                            @"originAddr": (roadModel.originAddr ? roadModel.originAddr : @""),
                            @"destinationAddr": (roadModel.destinationAddr ? roadModel.destinationAddr : @""),
                            @"week": (roadModel.week ? roadModel.week : @""),
                            @"time": (roadModel.time ? roadModel.time : @""),
                            @"state": @"1"
                          };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:CustomRoad_URL params:params requestModel:model];
}

- (void) updateCustomRoadWithToken:(NSString *)token orderRoadModel:(OrderRoadModel *)roadModel tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;// 保留对 编辑定制路况 的记录
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"origin": (roadModel.origin ? roadModel.origin : @""),
                            @"destination": (roadModel.destination ? roadModel.destination : @""),
                            @"originAddr": (roadModel.originAddr ? roadModel.originAddr : @""),
                            @"destinationAddr": (roadModel.destinationAddr ? roadModel.destinationAddr : @""),
                            @"week": (roadModel.week ? roadModel.week : @""),
                            @"time": (roadModel.time ? roadModel.time : @""),
                            @"state": @"1",
                            @"id": (roadModel.orderRoadID ? roadModel.orderRoadID : @"")
                          };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:EditeCusTomRoad_URL params:params requestModel:model];
}

- (void) getEventWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @"") };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *cacheKey = @{@"userID":(userId ? userId : @"")};
    
    [self httpPostCacheRequest:GetEvent_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) getTrafficLabelWithOnlyCache:(BOOL) isOnlyCache tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    if (isOnlyCache) {
        [self httpPostPriorUseCacheRequest:RoadLabel_Url params:nil isOnlyCache:YES paramsForCacheKey:nil requestModel:model];
    } else {
        [self httpPostCacheRequest:RoadLabel_Url params:nil paramsForCacheKey:nil requestModel:model];
    }
}

- (void) getclassfifytagnameWithOnlyCache:(BOOL) isOnlyCache tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"offset" : @"1",
                            @"pageSize" : @"15",
                            @"pid" : @"538241758052483072" };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    if (isOnlyCache) {
        [self httpPostPriorUseCacheRequest:Get_TakePhoto_Url params:params isOnlyCache:YES paramsForCacheKey:dict requestModel:model];
    } else {
        [self httpPostCacheRequest:Get_TakePhoto_Url params:params paramsForCacheKey:dict requestModel:model];
    }
}

- (void) addEventWithToken:(NSString *)token city:(NSString *)city label:(NSString *)label tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;// 保留对 事件订阅 的记录
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"city": (city ? city : @""),
                            @"label": (label ? label : @""),
                          };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:addEvent_Url params:params requestModel:model];
}

- (void) getClassifyListWithTag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;// 记录网络断开时的请求
    model.tag = tag;
    model.dataFromCacheHint = nil;
    model.offNetHint = nil;
    model.queryFailureHint = nil;
    
    [self httpPostPriorUseCacheRequest:Tiezi_Get_Header_Url params:nil paramsForCacheKey:nil requestModel:model];
}

- (void) getannouncementcardlistWithIsBulletin:(BOOL)isBulletin tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;// 记录网络断开时的请求
    model.tag = tag;
    model.dataFromCacheHint = nil;
    model.offNetHint = nil;
    model.queryFailureHint = nil;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"is_bulletin": (isBulletin ? @"1" : @"0"),
                            @"offset": @"1",        // 页码
                            @"pageSize": @"10" };   // 每页个数
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostPriorUseCacheRequest:Notice_List_Url params:params paramsForCacheKey:params requestModel:model];
}

- (void) getislaudrecommendcardlistWithToken:(NSString *)token userId:(NSString *)userId classifyID:(int)classifyID offset:(int) offset tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;// 记录网络断开时的请求
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"classify_id": @(classifyID),
                            @"offset": @(offset),       // 页码,从1开始
                            @"pageSize": @"10" };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *cacheKey = @{ @"userId" : (userId ? userId : @""),
                                @"classify_id": @(classifyID),
                                @"offset": @(offset) };
    
    [self httpPostPriorUseCacheRequest:Tiezi_List_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) operatingpointlaudWithToken:(NSString *)token laudType:(int)laudType operateID:(NSString *)operateID isRecommend:(NSString *)isRecommend tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // 参数
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(token ? token : @"") forKey:model.tokenKey];
    [dict setObject:@(laudType) forKey:@"laud_type"];
    [dict setObject:(operateID ? operateID : @"") forKey:@"operate_id"];
    
    if (isRecommend) {
        [dict setObject:isRecommend forKey:@"is_recommend"];
    }
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:Tiezi_Good_Cancle_Comment_Url params:params requestModel:model];
}

- (void) operatinghourseWithToken:(NSString *)token cardID:(NSString *)cardID tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // 参数
    NSDictionary* dict = @{ @"id" : @"",
                            @"card_id" : (cardID ? cardID : @""),
                            @"type" : @"1",
                            model.tokenKey : (token ? token : @"") };
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:Collec_Cancle_Favrite params:params requestModel:model];
}

- (void) publishreplyWithToken:(NSString *)token cardID:(NSString *)cardID contents:(NSString *)contents tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // 参数
    NSDictionary* dict = @{ @"card_id" : (cardID ? cardID : @""),
                            model.tokenKey : (token ? token : @""),
                            @"contents" : (contents ? contents : @""),
                            @"city_name" : @"",
                            @"address" : @"" };
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:Tiezi_Detail_Commit_Url params:params requestModel:model];
}

- (void) getmorecardcommentWithToken:(NSString *)token cardID:(NSString *)cardID currentPage:(int)page tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;// 记录网络断开时的请求
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"offset": @(page),       // 页码,从1开始
                            @"pageSize": @"10",
                            @"id": (cardID ? cardID : @"") };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *cacheKey = @{ @"cardID": (cardID ? cardID : @""),
                                @"offset": @(page) };
    
    [self httpPostPriorUseCacheRequest:Tiezi_Commont_Msg_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) getmycarddetailWithToken:(NSString *)token cardID:(NSString *)cardID tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;// 记录网络断开时的请求
    model.nilDataIden = @"130";
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"id": (cardID ? cardID : @"") };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *cacheKey = @{ @"cardID": (cardID ? cardID : @"") };
    
    [self httpPostPriorUseCacheRequest:Tiezi_Detail_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) getmorecardlauduserphotoWithCardID:(NSString *)cardID currentPage:(int)page tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;// 记录网络断开时的请求
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"offset": @(page),       // 页码,从1开始
                            @"pageSize": @"10",
                            @"id": (cardID ? cardID : @"") };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *cacheKey = @{ @"cardID": (cardID ? cardID : @""),
                                @"offset": @(page) };
    
    [self httpPostCacheRequest:CarFriend_Get_Comment_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) fileUploadswithDataArray:(NSArray *)dataArray tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:@"" forKey:@"flag"];
    [params setObject:@"" forKey:@"userId"];
    
    [self uploadDataWithUrlStr:MoreImage_UPLOAD_URL params:params imageName:@"file" withDataArray:dataArray requestModel:model];
}

- (void)publishpostWithToken:(NSString *)token userID:(NSString *)userID classifyID:(NSString *)classifyID tagID:(NSString *)tagID contents:(NSString *)contents cityName:(NSString *)cityName address:(NSString *)address imgURL:(NSString *)imgURL province:(NSString *)province town:(NSString *)town latitude:(double) latitude longitude:(double) longitude tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.imageMimeType = @"image/png";
    model.fileName = @"image.jpg";
    
    // 参数
    NSDictionary* dict = @{ model.tokenKey : (token ? token : @""),
                            @"classify_id" : (classifyID ? classifyID : @""),           // 话题类型
                            @"tag_id" : (tagID ? tagID : @""),                          // 话题标签id
                            @"user_id" : (userID ? userID : @""),                       // 用户id
                            @"contents" : (contents ? contents : @""),                  // 话题内容
                            @"city_name" : (cityName ? cityName : @""),                 // 用户所在城市名
                            @"address" : (address ? address : @""),                     // 用户所在详细地址
                            @"img_url" : (imgURL ? imgURL : @""),                       // 以#将所有图片拼接起来
                            @"province" : (province ? province : @""),                  // 省份
                            @"town" : (town ? town : @""),                              // 区域
                            @"lat" : @(latitude),                                       // 高德维度
                            @"lng" : @(longitude),                                      // 高德经度
                            @"source" : @"app"                                          // 来源
                           };
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:CarFriend_CommitMesg_URL params:params requestModel:model];
}

- (void) addTrafficUpWithToken:(NSString *)token province:(NSString *)province city:(NSString *)city addr:(NSString *)addr
                      latitude:(double) latitude longitude:(double)longitude tagName:(NSString *)tagName
                      contents:(NSString *)contents imgURL:(NSString *)imgURL tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // 参数
    NSDictionary* dict = @{ model.tokenKey : (token ? token : @""),
                            @"province" : (province ? province : @""),
                            @"city" : (city ? city : @""),
                            @"addr" : (addr ? addr : @""),
                            @"type" : (tagName ? tagName : @""),
                            @"latitude" : @(latitude),
                            @"longitude" : @(longitude),
                            @"description" : (contents ? contents : @""),
                            @"scenePhotos" : (imgURL ? imgURL : @"") };
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:RoadInformation_Url params:params requestModel:model];
}

@end
