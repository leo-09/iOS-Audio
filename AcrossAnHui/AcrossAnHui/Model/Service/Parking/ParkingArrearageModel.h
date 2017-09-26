//
//  ParkingArrearageModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

@interface ArrearageInfoModel : CTXBaseModel

@property (nonatomic, copy) NSString *card;       // 车牌号
@property (nonatomic, copy) NSString *carName;    // 汽车类型
@property (nonatomic, copy) NSString *odue;       // 欠款金额
@property (nonatomic, copy) NSString *userId;     // 用户id

@end

/**
 停车服务 欠费余额信息
 */
@interface ParkingArrearageModel : CTXBaseModel

@property (nonatomic, assign) double totalOdue;     // 总欠款
@property (nonatomic, assign) double ubalance;      // 用户帐户余额
@property (nonatomic, copy) NSString *orderNum;   // (欠费)订单编号
@property (nonatomic, retain) NSArray<ArrearageInfoModel *> *odueList;

@end
