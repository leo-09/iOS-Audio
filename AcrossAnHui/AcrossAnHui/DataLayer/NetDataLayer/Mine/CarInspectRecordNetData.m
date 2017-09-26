//
//  CarInspectRecordNetData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectRecordNetData.h"

@implementation CarInspectRecordNetData

- (void) subscribeListWithToken:(NSString *)token userId:(NSString *)userId currentPage:(int)page businessType:(NSString *) type tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"pageId": @(page),                         // 起始页(从0开始)
                            @"showCount" : @"10",                       // 每页10条数据
                            @"businessType": (type ? type : @"0") };    // 查询年检类型
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    NSDictionary *cacheKey = @{ @"userId" : (userId ? userId : @""),
                                @"pageId": @(page),
                                @"showCount" : @"10",
                                @"businessType": (type ? type : @"") };
    
    [self httpPostPriorUseCacheRequest:CXYY_Recoard_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) applyRefundWithToken:(NSString *)token businessID:(NSString *)businessid tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{model.tokenKey: (token ? token : @""),
                           @"businessid": (businessid ? businessid : @"") };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostRequest:ApalyTK_Url params:params requestModel:model];
}

- (void)getDaiBanRecordWithToken:(NSString *)token userId:(NSString *)userId pageId:(int)pageId tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @""),
                            @"showCount" : @"10",
                            @"pageId": @(pageId) };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    NSDictionary *cacheKey = @{ @"userId" : (userId ? userId : @""),
                                @"showCount" : @"10",
                                @"pageId": @(pageId) };
    
    [self httpPostCacheRequest:DBRecordList_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void)sureOrderWithToken:(NSString *)token businessid:(NSString *)businessid tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{model.tokenKey : (token ? token : @""),
                           @"businessid" : (businessid ? businessid : @"") };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostRequest:DBSrueOrder_Url params:params requestModel:model];
}

- (void)getOrderDetailWithToken:(NSString *)token businessid:(NSString *)businessid tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{model.tokenKey : (token ? token : @""),
                           @"businessid" : (businessid ? businessid : @"") };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    NSDictionary *cacheKey = @{ @"businessid" : (businessid ? businessid : @"") };
    
    [self httpPostCacheRequest:DBOrderDetail_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) saveOrderAgainWithToken:(NSString *)token businessid:(NSString *)businessid tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{model.tokenKey : (token ? token : @""),
                           @"businessid" : (businessid ? businessid : @"") };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostRequest:SaveOrderAgain_Url params:params requestModel:model];
}

- (void) getOrderRecordWithToken:(NSString *)token businessid:(NSString *)businessid tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{model.tokenKey : (token ? token : @""),
                           @"businessid" : (businessid ? businessid : @"") };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    NSDictionary *cacheKey = @{ @"businessid" : (businessid ? businessid : @"") };
    
    [self httpPostPriorUseCacheRequest:GetOrderRecord_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) findCancelResonListWithTag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    [self httpPostCacheRequest:FindCancelResonList_Url params:nil paramsForCacheKey:nil requestModel:model];
}

- (void) cancelSubscribeWithToken:(NSString *)token businessid:(NSString *)businessid reasonid:(NSString *)reasonid tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(businessid ? businessid : @"") forKey:@"businessid"];
    
    if (reasonid) {
        [params setObject:reasonid forKey:@"reasonid"];
    }
    
    [self httpPostRequest:Cancle_Bussinessid_Url params:params requestModel:model];
}

- (void) getDriverPositionWithOrderID:(NSString *)orderid tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ @"orderid" : (orderid ? orderid : @"") };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostCacheRequest:GetDriverPosition_Url params:params paramsForCacheKey:dict requestModel:model];
}

- (void) getReturnMoneyResonWithToken:(NSString *)token businessid:(NSString *)businessid tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{model.tokenKey : (token ? token : @""),
                           @"businessid" : (businessid ? businessid : @"") };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    NSDictionary *cacheKey = @{ @"businessid" : (businessid ? businessid : @"") };
    
    [self httpPostCacheRequest:GetReturnMoneyReson_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) applyDbRefundWithToken:(NSString *)token businessid:(NSString *)businessid reasonid:(NSString *)reasonid money:(NSString *)money tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(businessid ? businessid : @"") forKey:@"businessid"];
    [params setObject:(reasonid ? reasonid : @"") forKey:@"reasonid"];
    [params setObject:(money ? money : @"") forKey:@"money"];
    
    [self httpPostRequest:DBApplyRefund_Url params:params requestModel:model];
}

-(void)queryParkingRecordListWithToken:(NSString *)token userId:(NSString *)userId magCard:(NSString *)magCard currentPage:(int)currentPage isPay:(NSString *)isPay tag:(NSString *)tag {
    
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    model.tag = tag;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(magCard ? magCard : @"") forKey:@"magCard"];
    [params setObject:@(currentPage) forKey:@"currentPage"];
    [params setObject:(isPay ? isPay : @"") forKey:@"isPay"];
    
    NSDictionary *cacheKey = @{ @"userId" : (userId ? userId : @""),
                                @"magCard" : (magCard ? magCard : @""),
                                @"currentPage" : @(currentPage),
                                @"isPay" : (isPay ? isPay : @"") };
    
    [self httpPostCacheRequest:SelectParkingRecords_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

-(void)queryParkingDetailRecordWithToken:(NSString *)token carID:(NSString *)CarID isPay:(NSString *)isPay tag:(NSString *)tag{
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    model.tag = tag;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(CarID ? CarID : @"") forKey:@"id"];
    [params setObject:(isPay ? isPay : @"") forKey:@"isPay"];
    
    NSDictionary *cacheKey = @{ @"id" : (CarID ? CarID : @""),
                                @"isPay" : (isPay ? isPay : @"") };
    
    [self httpPostCacheRequest:SelectParkingDetail_Url params:params paramsForCacheKey:cacheKey requestModel:model];
}

-(void)getWalletPayWithToken:(NSString *)token orderNum:(NSString *)orderNum tag:(NSString *)tag{
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.nilDataIden = @"-1003";
    model.tag = tag;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(orderNum ? orderNum : @"") forKey:@"orderNum"];
 
    [self httpPostRequest:ImmediatePaymentFinish_URL params:params requestModel:model];
}

-(void)aliPayWithToken:(NSString *)token BusinessCode:(NSString *)businessCode desc:(NSString *)desc payFee:(NSString *)payFee tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(desc ? desc : @"") forKey:@"desc"];
    [params setObject:(payFee ? payFee : @"") forKey:@"payFee"];
    
    if (businessCode) {
        [params setObject:businessCode forKey:@"businessCode"];
    }
    
    [self httpPostRequest:Parking_AppPay_URL params:params requestModel:model];
}

-(void)weChatPayWithToken:(NSString *)token BusinessCode:(NSString *)businessCode desc:(NSString *)desc payFee:(NSString *)payFee tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(desc ? desc : @"") forKey:@"desc"];
    [params setObject:(payFee ? payFee : @"") forKey:@"payFee"];
    
    if (businessCode) {
        [params setObject:businessCode forKey:@"businessCode"];
    }
    
    [self httpPostRequest:Parking_WxPayForAPP_URL params:params requestModel:model];
}

-(void)driverEvaluateWithToken:(NSString *)token orderid:(NSString *)orderid driverPhone:(NSString *)driverPhone attitude:(CGFloat)attitude speed:(CGFloat )speed content:(NSString *)content tag:(NSString *)tag{
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(orderid ? orderid : @"") forKey:@"orderid"];
    [params setObject:(driverPhone ? driverPhone : @"") forKey:@"driverPhone"];
    [params setObject:(content ? content : @"") forKey:@"content"];
    [params setObject:@(speed) forKey:@"speed"];
    [params setObject:@(attitude) forKey:@"attitude"];
    
    [self httpPostRequest:DBOrderComment params:params requestModel:model];
}

- (void) querySFBnoWithBusinessID:(NSString *)businessID type:(int)type tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.infoKey = @"info";
    model.nilDataIden = @"0";
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{@"type" : @(type),
                           @"businessid" : (businessID ? businessID : @"") };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    [self httpPostPriorUseCacheRequest:ChaWuLiu_Url params:params paramsForCacheKey:dict requestModel:model];
}

@end
