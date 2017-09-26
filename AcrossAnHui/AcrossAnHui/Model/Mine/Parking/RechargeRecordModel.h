//
//  RechargeRecordModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/24.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 充值记录Model
 */
@interface RechargeRecordModel : CTXBaseModel

@property (nonatomic, copy) NSString *recordID;           // 充值编号（唯一）
@property (nonatomic, copy) NSString *money;              // 充值金额
@property (nonatomic, assign) int rechargeType;             // 交易方式0:支付宝1:微信支付2:银联支付3.用户余额支付
@property (nonatomic, copy) NSString *tradeType;          // 交易类型 0-充值；1-扣减
@property (nonatomic, copy) NSString *ubalance;           // 用户余额
@property (nonatomic, copy) NSString *userId;             // 用户id
@property (nonatomic, copy) NSString *addTime;            // 充值时间：YYYY-MM-dd HH:mm:ss
@property (nonatomic, copy) NSString *weekOfDay;          // 星期

@property (nonatomic,readonly) int currentPage;

// 获取年月
- (NSString *) yearMonth;

// 获取月日
- (NSString *) monthDay;

// 获取时间
- (NSString *) time;

@end


@interface RechargeRecordCollection : CTXBaseModel

@property (nonatomic, copy) NSString *yearMonth;  // YYYY-MM
@property (nonatomic, retain) NSMutableArray<RechargeRecordModel *> *records;

- (NSString *) month;

// 充值记录 按照年月 分组
+ (NSMutableArray *) recordCollection:(NSMutableArray *)collection recordModels:(NSArray<RechargeRecordModel *> *) records;

@end
