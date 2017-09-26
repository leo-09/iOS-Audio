//
//  ParkingRoadModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

/**
 道路信息
 */
@interface ParkingRoadModel : CTXBaseModel

@property (nonatomic, copy) NSString *roadID;
@property (nonatomic, copy) NSString *areacode;
@property (nonatomic, copy) NSString *sitename;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *balance;

@property (nonatomic, assign) BOOL isBalance;
@property (nonatomic, assign) BOOL isCharge;
@property (nonatomic, assign) BOOL isOpenFence;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, copy) NSString *linkman;
@property (nonatomic, copy) NSString *linkphone;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *regtime;
@property (nonatomic, copy) NSString *flag;

@end
