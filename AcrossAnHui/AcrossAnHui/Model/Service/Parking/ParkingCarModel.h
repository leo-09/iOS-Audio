//
//  ParkingCarModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 停车服务车辆信息
 */
@interface ParkingCarModel : CTXBaseModel {
    NSTimeInterval startTimeInterval;//(秒)
}

@property (nonatomic, copy) NSString *parkingCarID;               // 停车记录编号
@property (nonatomic, copy) NSString *plateNumber;                // 车牌号
@property (nonatomic, copy) NSString *cardType;                   // 车辆类型
@property (nonatomic, copy) NSString *imgurl;                     // 车图标
@property (nonatomic, copy) NSString *carname;                    //
@property (nonatomic, copy) NSString *credenceSnr;                // 流水号
@property (nonatomic, copy) NSString *backByte;                   // 车位号
@property (nonatomic, copy) NSString *startTime;                  // 进场时间 如2017-06-19 12:11:57
@property (nonatomic, copy) NSString *datetime;                   // 记录时间 如2017-06-19 12:59:01
@property (nonatomic, assign) double giving;                        // 押金
@property (nonatomic, assign) double balance;                       // 余额
@property (nonatomic, copy) NSString *btype;                      // 欠费状态:0:欠费 1:不欠费

@property (nonatomic, assign) double maxPayment;                    // 最高收费/元
@property (nonatomic, assign) double minPayment;                    // 起步价
@property (nonatomic, copy) NSString *fisrtChargingTimes;
@property (nonatomic, assign) int firstChargingTimeSeg;             // 起步时间/分
@property (nonatomic, assign) int freeTimeSeg;                      // 免费停车时间
@property (nonatomic, assign) BOOL chargeByTimes;                   // 是否按次收费

@property (nonatomic, assign) double normalChargingPrice;           // 超时费用/元
@property (nonatomic, assign) int normalChargingTimeSeg;            // 间隔时间/分
@property (nonatomic, copy) NSString *mode;                       // 交易类型
@property (nonatomic, assign) double money;                         // 停车费用
@property (nonatomic, assign) double realMoney;                     // 实缴金额
@property (nonatomic, assign) int sumMins;                          // 累计时长／分

@property (nonatomic, copy) NSString *userid;                     // 操作员号
@property (nonatomic, copy) NSString *pname;                      // 收费名称
@property (nonatomic, copy) NSString *posSnr;                     // 终端机号
@property (nonatomic, copy) NSString *siteId;                     // 所在路段编号
@property (nonatomic, copy) NSString *sitename;                   // 所在路段名称

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, assign) BOOL isbusy;                          // 是否正在停车

@property (nonatomic, assign) BOOL isFullTiming;

// 欠费状态:0:欠费 1:不欠费
- (BOOL) isArrearage;

// 获取停车时间的 时间戳
- (int) parkingTimeInterval;
// 获取停车时间的 HH:MM:SS
- (NSString *) parkingTimeDescWithSecondCount:(int) secondCount;

// 格式化车牌
- (NSString *) formatPlateNumber;

@end
