//
//  ConsumeRecordModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 消费记录
 */
@interface ConsumeRecordModel : CTXBaseModel

@property (nonatomic, copy) NSString *addTime;            // 充值时间：YYYY-MM-dd
@property (nonatomic, copy) NSString *weekOfDay;          // 星期

@property (nonatomic, copy) NSString *carNumber;          // 车牌号
@property (nonatomic, copy) NSString *carname;            // 车辆类型

@property (nonatomic, assign) int rechargeType;             // 交易方式0:支付宝1:微信支付2:银联支付3.用户余额支付
@property (nonatomic, assign) int tradeType;                // 交易类型 0-充值；1-扣减
@property (nonatomic, assign) double money;                 // 消费金额
@property (nonatomic, copy) NSString *desc;               // 消费描述

@property (nonatomic, copy) NSString *ubalance;           // 余额
@property (nonatomic, copy) NSString *currentPage;        // 当前页数

// 获取年月
- (NSString *) yearMonth;

// 获取月日
- (NSString *) monthDay;

@end


/**
 消费记录 按月分组
 */
@interface ConsumeRecordCollection : CTXBaseModel

@property (nonatomic, copy) NSString *yearMonth;  // MM
@property (nonatomic, retain) NSMutableArray<ConsumeRecordModel *> *records;

- (NSString *) month;

// 充值记录 按照年月 分组
+ (NSMutableArray *) recordCollection:(NSMutableArray *)collection recordModels:(NSArray<ConsumeRecordModel *> *) records;

@end
