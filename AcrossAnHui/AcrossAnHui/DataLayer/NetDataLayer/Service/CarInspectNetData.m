//
//  CarInspectNetData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectNetData.h"
#import "BoundCarModel.h"

@implementation CarInspectNetData

- (void) userApiNJWZCXWithPlateNumber:(NSString *)plateNumber frameNumber:(NSString *)frameNumber carType:(NSString *)carType tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"id": @"hyzxjk",
                            @"pwd": @"hyzxjkpwd",
                            @"hpzl": (carType ? carType : Compact_Car_PlateType),
                            @"hphm": (plateNumber ? plateNumber : @""),
                            @"clsbdm": (frameNumber ? frameNumber : @"")
                            };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostRequest:CarSixYear_URl params:params requestModel:model];
}

- (void) userApiMJWZCXWithPlateNumber:(NSString *)plateNumber frameNumber:(NSString *)frameNumber carType:(NSString *)carType date:(NSString *)date tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"hyzxjk" forKey:@"id"];
    [params setObject:@"hyzxjkpwd" forKey:@"pwd"];
    [params setObject:(carType ? carType : Compact_Car_PlateType) forKey:@"hpzl"];
    [params setObject:(plateNumber ? plateNumber : @"") forKey:@"hphm"];
    [params setObject:(frameNumber ? frameNumber : @"") forKey:@"clsbdm"];
    
    if (date) {
        [params setObject:date forKey:@"jqxjsrq"];
    }
    
    [self httpPostRequest:CarMianJian_URl params:params requestModel:model];
}

- (void) stationListWithLatitude:(double)latitude longitude:(double)longitude areaId:(NSString *)areaId pageId:(int)currentPage
                     stationType:(int) stationType showCount:(int)showCount sortKey:(int)sortKey tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"lng": @(longitude),
                            @"lat": @(latitude),
                            @"areaId": (areaId ? areaId : @""),
                            @"sortKey": @(sortKey),             // 排序字段：1：按距离升序；2：按好评数降序
                            @"pageId": @(currentPage),
                            @"stationType": @(stationType),     // 车间站类型；1：年检；2：六年免检；3：全部；
                            @"showCount" :  @(showCount) };     // 当前查询数据长度；
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostPriorUseCacheRequest:LookUpStation_Url params:params paramsForCacheKey:dict requestModel:model];
//    [self httpPostCacheRequest:LookUpStation_Url params:params paramsForCacheKey:dict requestModel:model];
}

-(void) searchStationWithAreaId:(NSString *)areaId stationType:(int)stationType stationName:(NSString *)stationName tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"areaid": (areaId ? areaId : @""),
                            @"stationType": @(stationType),         // 车间站类型；1：年检；2：六年免检；3：全部；
                            @"stationName" :  stationName };        // 当前查询数据长度
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [self httpPostCacheRequest:SSCJZLIST_URL params:params paramsForCacheKey:dict requestModel:model];
// [self httpPostCacheRequest:SSCJZLIST_URL params:params paramsForCacheKey:dict requestModel:model];
}

- (void) saveSubscribeWithToken:(NSString *)token subscribeMode:(SaveSubscribeModel*)subscribeMode cityName:(NSString *)cityName tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    NSMutableDictionary *params = [subscribeMode toDictionary];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    
    if (cityName) {
        [params setObject:cityName forKey:@"cityName"];
    }
    
    [self httpPostRequest:SAVE_RECOARD_URL params:params requestModel:model];
}

- (void) stationDetailWithLatitude:(double)latitude longitude:(double)longitude stationId:(NSString *)stationId tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"lng": @(longitude),
                            @"lat": @(latitude),
                            @"stationId": (stationId ? stationId : @"") };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostCacheRequest:LookUp_StationDetail_Url params:params paramsForCacheKey:dict requestModel:model];
}

- (void) aliPayWithBusinessCode:(NSString *)code desc:(NSString *)desc tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"businessCode": (code ? code : @""),
                            @"desc": (desc ? desc : @"")};
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostRequest:zfbPay_Url params:params requestModel:model];
}

- (void) weChatPayWithBusinessCode:(NSString *)code desc:(NSString *)desc tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"businessCode": (code ? code : @""),
                            @"desc": (desc ? desc : @"")};
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostRequest:wxPay_Url params:params requestModel:model];
}

- (void) orderDetailWithBusinessID:(NSString *)businessID tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"businessid": (businessID ? businessID : @"") };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostRequest:Order_Detail_Url params:params requestModel:model];
}

-(void)queryStationCommentWithStationID:(NSString *)stationID assessStar:(NSString *)assessStar pageId:(NSString *)pageId showCount:(NSString *)showCount isContainImg:(NSString *)isContainImg tag:(NSString *)tag{
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"stationid" : stationID,
                            @"assessStar" : assessStar,
                            @"pageId" : pageId,
                            @"showCount" : showCount,
                            @"isContainImg" : isContainImg
                            };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostRequest:LookUpComment_Info_Url params:params requestModel:model];
}

-(void)quertApptionmentTime:(NSString *)orderDay StationID:(NSString *)stationID tag:(NSString *)tag{
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"orderDay":orderDay,
                            @"stationid":stationID,
                          };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostRequest:YYSJ_URl params:params requestModel:model];
}

-(void)quertStationAlbumStationID:(NSString *)stationID tag:(NSString *)tag{
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{
                           @"stationid":stationID,
                           };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostPriorUseCacheRequest:CXCJZTP_URL params:params paramsForCacheKey:dict requestModel:model];
}

- (void) isCouponCodeWithCouponCode:(NSString *)couponCode tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"couponCode": (couponCode ? couponCode : @"") };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostRequest:DBCouponCode_Url params:params requestModel:model];
}

-(void) queryNearbyStatationWithLatitude:(double)latitude longitude:(double)longitude pageId:(NSString *)pageId from:(NSString *)from showCount:(NSString *)showCount tag:(NSString *)tag{
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"lng" : @(longitude),
                            @"lat" : @(latitude),
                            @"pageId" : pageId,
                            @"from" : from,
                            @"showCount" : showCount
                           };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostPriorUseCacheRequest:NearByStation_Url params:params paramsForCacheKey:dict requestModel:model];
}

-(void) queryCarInspectagencyStationAppintionTimeWithStationID:(NSString *)stationID tag:(NSString *)tag{
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"stationid": stationID};
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostRequest:DBgetStationTimeList_Url params:params requestModel:model];
}

- (void) uploadUserHeaderImageWithData:(NSData *)data tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.imageMimeType = @"image/png";
    model.successIden = @"1";
    model.tag = tag;
    
    [self uploadDataWithUrlStr:UpLoadImage_Url params:nil imageName:@"file" fileName:@"image.jpg" withData:data requestModel:model];
}

-(void)submitStationCommentWithToken:(NSString *)token assessStar:(NSString *)assessStar assessContent:(NSString *)assessContent imgUrl:(NSString *)imgUrl businessid:(NSString *)businessid tag:(NSString *)tag{
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(assessStar ? assessStar : @"5") forKey:@"assessStar"];
    [params setObject:(assessContent ? assessContent : @"") forKey:@"assessContent"];
    [params setObject:(imgUrl ? imgUrl : @"") forKey:@"imgUrl"];
    [params setObject:(businessid ? businessid : @"") forKey:@"businessid"];
    
    [self httpPostRequest:Save_Comment_Url params:params requestModel:model];
}

-(void) queryStationEvaluateCountWithStationID:(NSString *)stationId tag:(NSString *)tag{
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"stationid": stationId};
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostRequest:evaluateCount_Url params:params requestModel:model];
}

@end
