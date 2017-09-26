//
//  SitefeeModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/20.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 路段收费标准
 */
@interface SitefeeModel : CTXBaseModel

@property (nonatomic, copy) NSString *startWorkTime;              // 开始收费时间
@property (nonatomic, copy) NSString *endWorkTime;                // 结束收费时间
@property (nonatomic, copy) NSString *firstChargingTimeSeg;       // 起步时长
@property (nonatomic, copy) NSString *freeTimeSeg;                // 免费时段
@property (nonatomic, assign) double maxPayment;                    // 最高缴费
@property (nonatomic, assign) double minPayment;                    // 起步价
@property (nonatomic, assign) double normalChargingPrice;           // 超出缴费
@property (nonatomic, copy) NSString *normalChargingTimeSeg;      // 间隔时长
@property (nonatomic, copy) NSString *pid;                        // 收费标准编号
@property (nonatomic, copy) NSString *pname;                      // 收费标准名称

@end
