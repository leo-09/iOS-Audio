//
//  CarInspectStation.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/29.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

@interface CarInspectWorkTime : CTXBaseModel

@property (nonatomic, copy) NSString *endTime;      // 车检站工作结束时间
@property (nonatomic, copy) NSString *orderDay;     // 车检站预约日期
@property (nonatomic, copy) NSString *startTime;    // 车检站工作开始时间

@end

@interface CarInspectCarType : CTXBaseModel

@property (nonatomic, copy) NSString *carTypeName;      // 车检站检测车辆类型（年检免检）
@property (nonatomic, copy) NSString *origCarTypeId;    // 编号（年检免检）
@property (nonatomic, copy) NSString *dictname;//车检站检测车辆类型(代办)
@property (nonatomic, copy) NSString *remark;    // 编号 (代办)
@end

/**
 车检站
 */
@interface CarInspectStationModel : CTXBaseModel

@property (nonatomic, copy) NSString *adminOffice;
@property (nonatomic, copy) NSString *apperaCheck;          // 外观检测通道
@property (nonatomic, copy) NSString *areaid;               // 地区id
@property (nonatomic, copy) NSString *avgStar;              // 总平均好评星数
@property (nonatomic, copy) NSString *bank;                 // 开户银行
@property (nonatomic, copy) NSString *bankAccount;          // 提现账户
@property (nonatomic, copy) NSString *bankArea;             // 开户地区
@property (nonatomic, copy) NSString *bankBranch;           // 开户支行
@property (nonatomic, copy) NSString *bankCarNo;            // 提现卡号
@property (nonatomic, copy) NSString *bankMobile;           // 开户行预留手机号码
@property (nonatomic, copy) NSString *bankType;             // 账户类型 0-公司 1-个人
@property (nonatomic, retain) NSArray<CarInspectCarType *> *carTypeList;// 保存车辆类型的数组
@property (nonatomic, copy) NSString *checkCarTypes;        // 检测车辆类型
@property (nonatomic, copy) NSString *cjPrice;              // 车检价格
@property (nonatomic, copy) NSString *distance1;            // 根据当前纬度计算的距离
@property (nonatomic, copy) NSString *isCanOnlinePay;       // 是否支持线上支付0-不支持 1-支持
@property (nonatomic, copy) NSString *isdisabled;           // 0:禁用;1:启用
@property (nonatomic, assign) double latitude;              // 车检站纬度
@property (nonatomic, assign) double longitude;             // 车检站经度
@property (nonatomic, assign) double mjPrice;               // 免检价格-顺丰
@property (nonatomic, assign) double mjPrice2;              // 免检价格-邮政
@property (nonatomic, copy) NSString *parkCapacity;         // 停车容量
@property (nonatomic, copy) NSString *personyh;             // 车主优惠金额
@property (nonatomic, copy) NSString *securityCheck;        // 安检检测线
@property (nonatomic, copy) NSString *sixYearInspect;       // 六年免检状态
@property (nonatomic, copy) NSString *sportsyh;             // 平台优惠金额
@property (nonatomic, copy) NSString *stationAddr;          // 车检站地址
@property (nonatomic, copy) NSString *stationCode;          // 车检站编码
@property (nonatomic, copy) NSString *stationContents;      // 车检站介绍
@property (nonatomic, copy) NSString *stationName;          // 车检站名称
@property (nonatomic, copy) NSString *stationPic;           // 车检站照片
@property (nonatomic, copy) NSString *stationTel;           // 车检站电话
@property (nonatomic, copy) NSString *stationWeek;          // 检测周工作时间
@property (nonatomic, copy) NSString *stationWorkTime;      // 车检站工作时间
@property (nonatomic, copy) NSString *stationid;            // 车检站id
@property (nonatomic, copy) NSString *tailGasCheck;         // 尾气检测线
@property (nonatomic, copy) NSString *totalCount;           // 评价总数
@property (nonatomic, copy) NSString *totalStar;            // 评价打星总数
@property (nonatomic, retain) NSArray<CarInspectWorkTime *> *workTimeList;// 保存预约时间段的数组；
@property (nonatomic, copy) NSString *yearInspect;          // 年检状态
@property (nonatomic,copy)NSString *totalFee;//代办总费
@property (nonatomic,copy)NSString *agencyFee;//车检费
@property (nonatomic,copy)NSString *getCarAddress;//取车地址
@property (nonatomic,copy)NSString *yearfee;//检测费,
@property (nonatomic, copy) NSString *distance;//车检代办的车检站距离


//@property (nonatomic, copy) NSString *expressType;          // 快递方式 1-顺丰; 2-EMS;

/**
 dict->实体
 
 @param dict dict
 @param isAgency isAgency 车检预约和六年免检需要转换坐标值
 @return 实体
 */
+ (instancetype) convertFromDict:(NSDictionary *)dict isCarInspectAgency:(BOOL)isAgency;
+ (NSMutableArray *) convertFromArray:(NSArray *)array isCarInspectAgency:(BOOL)isAgency;

@end
