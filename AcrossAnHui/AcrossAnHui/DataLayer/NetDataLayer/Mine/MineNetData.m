//
//  MineNetData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "MineNetData.h"

@implementation MineNetData

- (void) getCarTypeWithTag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    [self httpPostPriorUseCacheRequest:BandCarTypeList params:nil paramsForCacheKey:nil requestModel:model];
}

- (void)addFeedBackWithToken:(NSString *)token content:(NSString *)content tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.dataKey = @"msg";
    model.tag = tag;
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(token ? token : @"") forKey:model.tokenKey];
    [dict setObject:(content ? content : @"") forKey:@"contents"];
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:Opinion_Url params:params requestModel:model];
}

- (void) getHelpListWithTag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    [self httpPostPriorUseCacheRequest:Help_Url params:nil paramsForCacheKey:nil requestModel:model];
}

- (void) getBoundCarListWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // Dictionary转换为json
    NSDictionary *dict = @{ model.tokenKey: (token ? token : @"") };
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostCacheRequest:BindCarList_Url params:params paramsForCacheKey:@{@"userID" : (userId ? userId : @"")} requestModel:model];
}

- (void) unbindCarWithToken:(NSString *)token carID:(NSString *)carID tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = NO;
    model.tag = tag;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(token ? token : @"") forKey:model.tokenKey];
    [dict setObject:(carID ? carID : @"") forKey:@"id"];
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:JieBindCar_Url params:params requestModel:model];
}

- (void) bindCarWithToken:(NSString *)token boundCarModel:(BoundCarModel *)carModel tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(token ? token : @"") forKey:model.tokenKey];
    [dict setObject:(carModel.plateNumber ? carModel.plateNumber : @"") forKey:@"plateNumber"];
    [dict setObject:(carModel.frameNumber ? carModel.frameNumber : @"") forKey:@"frameNumber"];
    [dict setObject:(carModel.plateType ? carModel.plateType : @"") forKey:@"plateType"];
    [dict setObject:(carModel.inspectionReminder ? carModel.inspectionReminder : @"") forKey:@"inspectionReminder"];
    [dict setObject:(carModel.carType ? carModel.carType : @"") forKey:@"carType"];
    [dict setObject:(carModel.note ? carModel.note : @"") forKey:@"note"];
    
    // 有carid，则表示是编辑车辆
    if (carModel.carID) {
        [dict setObject:carModel.carID forKey:@"id"];
    }
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:BindCar_URl params:params requestModel:model];
}

- (void) setDefaultCarWithToken:(NSString *)token carID:(NSString *)carID tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(token ? token : @"") forKey:model.tokenKey];
    [dict setObject:(carID ? carID : @"") forKey:@"id"];
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:MoRenCar_url params:params requestModel:model];
}

- (void) getMsgCountWithToken:(NSString *)token tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(token ? token : @"") forKey:model.tokenKey];
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:MsgCount_Url params:params requestModel:model];
}

- (void) getMsgListWithToken:(NSString *)token userId:(NSString *)userId type:(NSString *)type offset:(int)offset tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.nilDataIden = @"0";// 数据为空，结果result=0
    model.isRecordOperation = YES;
    model.tag = tag;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(token ? token : @"") forKey:model.tokenKey];
    [dict setObject:(type ? type : @"") forKey:@"type"];
    [dict setObject:@(offset) forKey:@"offset"];
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary * paramsForCacheKey = @{ @"userId" : (userId ? userId : @""),
                                          @"type": (type ? type : @""),
                                          @"offset": @(offset)};
    
    [self httpPostPriorUseCacheRequest:MsgList_URl params:params paramsForCacheKey:paramsForCacheKey requestModel:model];
}

- (void) clickReadWithToken:(NSString *)token type:(int)type msgID:(NSString *)msgID tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(token ? token : @"") forKey:model.tokenKey];
    [dict setObject:@(type) forKey:@"type"];
    [dict setObject:(msgID ? msgID : @"") forKey:@"id"];
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *cacheKey = @{ @"type" : @(type),
                                @"msgID" : (msgID ? msgID : @"")};
    
    [self httpPostPriorUseCacheRequest:clickRead_URl params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) getUserTipWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.dataFromCacheHint = @"";
    model.queryFailureHint = @"";
    model.offNetHint = @"";
    model.tag = tag;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(token ? token : @"") forKey:model.tokenKey];
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostCacheRequest:GetUserTip_URL params:params paramsForCacheKey:@{@"userId" : (userId ? userId : @"")} requestModel:model];
}

- (void) getRewardListWithToken:(NSString *)token userId:(NSString *)userId state:(NSString *)state tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.nilDataIden = @"0";// 数据为空，结果result=0
    model.isRecordOperation = YES;
    model.tag = tag;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(token ? token : @"") forKey:model.tokenKey];
    [dict setObject:(state ? state : @"") forKey:@"state"];
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *paramsForCacheKey = @{ @"userId" : (userId ? userId : @""),
                                         @"state": (state ? state : @"")};
    
    [self httpPostCacheRequest:Award_URL params:params paramsForCacheKey:paramsForCacheKey requestModel:model];
}

- (void) receivePrizesWithToken:(NSString *)token prideID:(NSString *)prideID
                           name:(NSString *)name phone:(NSString *)phone
                      goodsName:(NSString *)goodsName tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(token ? token : @"") forKey:model.tokenKey];
    [dict setObject:(prideID ? prideID : @"") forKey:@"id"];
    [dict setObject:(name ? name : @"") forKey:@"name"];
    [dict setObject:(phone ? phone : @"") forKey:@"phone"];
    [dict setObject:(goodsName ? goodsName : @"") forKey:@"goodsName"];
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:ReceivePrizes params:params requestModel:model];
}

- (void) shareWayWithToken:(NSString *)token state:(NSString *)state tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(token ? token : @"") forKey:model.tokenKey];
    [dict setObject:(state ? state : @"") forKey:@"state"];
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:User_ShareWay params:params requestModel:model];
}

- (void) signInfoWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.isRecordOperation = YES;
    model.tag = tag;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(token ? token : @"") forKey:model.tokenKey];
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    NSDictionary *cacheKey = @{ @"userId" : (userId ? userId : @"") };
    
    [self httpPostPriorUseCacheRequest:User_Sign_ContentInfo params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) userSignWithToken:(NSString *)token tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(token ? token : @"") forKey:model.tokenKey];
    
    // 参数
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[DES3Util dataTojsonString:dict] forKey:model.paramsKey];
    
    [self httpPostRequest:User_Sign_Url params:params requestModel:model];
}

- (void) deleteCarParkServiceWithToken:(NSString *)token plateNumber:(NSString *)plateNumber tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.nilDataIden = @"-1003";
    model.tag = tag;
    
    // 参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(plateNumber ? plateNumber : @"") forKey:@"plateNumber"];
    
    [self httpPostRequest:DeleteCarParkService_Url params:params requestModel:model];
}

- (void) selectCarParkServiceWithToken:(NSString *)token userId:(NSString *)userId tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    model.tag = tag;
    
    // 参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    
    NSDictionary *cacheKey = @{ @"userId" : (userId ? userId : @"") };
    
    [self httpPostCacheRequest:SelectCarParkService_URl params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) addCarParkServiceWithToken:(NSString *)token plateNumber:(NSString *)plateNumber carname:(NSString *)carname imgurl:(NSString *)imgurl tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.nilDataIden = @"-1003";
    model.tag = tag;
    
    // 参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    
    if (plateNumber) {
        [params setObject:plateNumber forKey:@"plateNumber"];
    }
    
    if (carname) {
        [params setObject:carname forKey:@"carname"];
    }
    
    if (imgurl) {
        [params setObject:imgurl forKey:@"imgurl"];
    }
    
    [self httpPostRequest:AddCarParkService_Url params:params requestModel:model];
}

@end
