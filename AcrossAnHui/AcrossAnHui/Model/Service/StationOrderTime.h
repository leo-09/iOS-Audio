//
//  StationOrderTime.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"

@interface StationOrderTime : CTXBaseModel

@property (nonatomic,copy) NSString *startTime;//开始时间
@property (nonatomic,copy) NSString *timeid;//时间段id
@property (nonatomic,copy) NSString *stationid;//车检站id
@property (nonatomic,copy) NSString *isdisabled;
@property (nonatomic,copy) NSString *endTime;//结束时间
@property (nonatomic,copy) NSString *checkCount;//检测车辆数
@property (nonatomic,copy) NSString *ordertimeid;//预约时间段id;

@end
