//
//  ParkingAreaModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import "ParkingRoadModel.h"

/**
 区域信息
 */
@interface ParkingAreaModel : CTXBaseModel

@property (nonatomic, copy) NSString *areacode;
@property (nonatomic, copy) NSString *areaname;
@property (nonatomic, copy) NSString *linkman;
@property (nonatomic, copy) NSString *linkphone;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *regtime;
@property (nonatomic, retain) NSMutableArray<ParkingRoadModel *> *siteList;

@end
