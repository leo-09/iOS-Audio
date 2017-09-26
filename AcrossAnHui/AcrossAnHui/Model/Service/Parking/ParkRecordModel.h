//
//  ParkRecordModel.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

@interface ParkRecordModel : CTXBaseModel

@property (nonatomic, assign) double afterBalance;//离场余额
@property (nonatomic, assign) double balance;//账户余额
@property (nonatomic, assign) double giving;//押金
@property (nonatomic, assign) double money;//应收费用
@property (nonatomic, assign) double realMoney;//实付费用
@property (nonatomic, assign) double returnMoney;//退还押金
@property (nonatomic, copy) NSString *endTime;//离场时间
@property (nonatomic, copy) NSString *isPay;//付款状态
@property (nonatomic, copy) NSString *magCard;//车牌号
@property (nonatomic, copy) NSString *sitename;//路段名称
@property (nonatomic, copy) NSString *startTime;//进场时间
@property (nonatomic, assign) int noPayCount;//未付款次数
@property (nonatomic, assign) int sumMins;//停车时间/分钟
@property (nonatomic, copy) NSString * parkTime;//停车时间段
@property (nonatomic, copy) NSString * orderNum;//产生的未付款订单号
@property (nonatomic, copy) NSString * carname;//汽车品牌
@property (nonatomic, copy) NSString * carid;//停车记录id（唯一）

@end
