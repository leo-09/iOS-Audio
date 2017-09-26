//
//  SiteModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/20.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 路段详情
 */
@interface SiteModel : CTXBaseModel

@property (nonatomic, copy) NSString *siteID;                 // 路段编号
@property (nonatomic, copy) NSString *sitename;               // 路段名称
@property (nonatomic, copy) NSString *minPayment;             // 起步价
@property (nonatomic, assign) int siteFreeNumber;               // 空闲车位数
@property (nonatomic, assign) int siteTotalNumber;              // 总车位数
@property (nonatomic, copy) NSString *startBillCarNumber;     // 开始计费车辆数
@property (nonatomic, copy) NSString *sumBusy;                // 占用车位数
@property (nonatomic, copy) NSString *sumParkingSites;        // 总车位数
@property (nonatomic, copy) NSString *workTimeNumber;         // 工作时间数
@property (nonatomic, copy) NSString *freeTimeSeg;            // 免费时间段
@property (nonatomic, copy) NSString *balance;                // 余额
@property (nonatomic, copy) NSString *busyrate;               // 占用比率
@property (nonatomic, assign) double distance;                  // 距离当前位置距离

@property (nonatomic, assign) BOOL isBalance;
@property (nonatomic, assign) BOOL isCharge;
@property (nonatomic, assign) BOOL isOpenFence;                 // 是否开启围栏
@property (nonatomic, assign) double latitude;                  // 纬度
@property (nonatomic, assign) double longitude;                 // 经度

@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *currentPage;            // 页码

// 路段详情
@property (nonatomic, copy) NSString *areacode;               // 区域编号
@property (nonatomic, copy) NSString *areaname;               // 区域名称
@property (nonatomic, copy) NSString *category;               // 路段类型
@property (nonatomic, copy) NSString *linkman;
@property (nonatomic, copy) NSString *linkphone;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *regtime;

@end
