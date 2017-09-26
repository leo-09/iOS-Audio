//
//  WalletNetData.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "WalletNetData.h"

@implementation WalletNetData

- (void)updatePayTypeWithToken:(NSString *)token payType:(NSString *)payType tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(payType? payType : @"") forKey:@"payType"];
    
    [self httpPostRequest:UpdatePayType_URL params:params requestModel:model];
}

- (void) selectBalanceWithToken:(NSString *)token tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    model.tag = tag;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    
    [self httpPostRequest:SelectBalance_URL params:params requestModel:model];
}

- (void) costRecordsWithToken:(NSString *)token userId:(NSString *)userId addTime:(NSString *)addTime endTime:(NSString *)endTime page:(int)page tag:(NSString *)tag {
    
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(page) forKey:@"currentPage"];
    
    if (addTime) {
        [dict setObject:addTime forKey:@"addTime"];
    }
    
    if (endTime) {
        [dict setObject:endTime forKey:@"endTime"];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    
    NSDictionary *cacheKey = @{ @"userId" : (userId ? userId : @""),
                                @"currentPage" : @(page),
                                @"addTime" : (addTime ? addTime : @""),
                                @"endTime" : (endTime ? endTime : @"")};
    
    [self httpPostCacheRequest:CostRecords_URL params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) selectRechargeWithToken:(NSString *)token userId:(NSString *)userId page:(int)page tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(page) forKey:@"currentPage"];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    
    NSDictionary *cacheKey = @{ @"userId" : (userId ? userId : @""),
                                @"currentPage" : @(page)};
    
    [self httpPostCacheRequest:SelectRecharge_URL params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) seleteTicketSendMoneyWithToken:(NSString *)token tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    
    [self httpPostRequest:SeleteTicketSendMoney_URL params:params requestModel:model];
}

- (void)addTicketSendWithToken:(NSString *)token petitionermoney:(NSString *)petitionermoney petitioner:(NSString *)petitioner address:(NSString *)address tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(petitionermoney ? petitionermoney : @"") forKey:@"petitionermoney"];
    [params setObject:(petitioner ? petitioner : @"") forKey:@"petitioner"];
    [params setObject:(address ? address : @"") forKey:@"address"];
    
    [self httpPostRequest:AddTicketSend_URL params:params requestModel:model];
}

- (void) selectTicketSendWithToken:(NSString *)token userId:(NSString *)userId page:(int)page tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    model.isRecordOperation = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(page) forKey:@"currentPage"];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    
    NSDictionary *cacheKey = @{ @"userId" : (userId ? userId : @""),
                                @"currentPage" : @(page)};
    
    [self httpPostCacheRequest:SelectTicketSend_URL params:params paramsForCacheKey:cacheKey requestModel:model];
}

- (void) deleteTicketSendWithToken:(NSString *)token tid:(NSString *)tid tag:(NSString *)tag {
    BaseNetDataRequestModel *model = [[BaseNetDataRequestModel alloc] init];
    model.tag = tag;
    model.nilDataIden = @"-1003";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:(token ? token : @"") forKey:model.tokenKey];
    [params setObject:(tid ? tid : @"") forKey:@"tid"];
    
    [self httpPostRequest:DeleteTicketSend_URL params:params requestModel:model];
}

@end
