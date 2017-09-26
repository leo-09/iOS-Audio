//
//  ParkingSiteModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/20.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import "SiteModel.h"

/**
 路段信息
 */
@interface ParkingSiteModel : CTXBaseModel

@property (nonatomic, assign) double averageLongitude;      // 所有坐标平均经度
@property (nonatomic, assign) double averageLatitude;       // 所有坐标平均经度
@property (nonatomic, retain) NSArray<SiteModel *> *siteList; // 路段实体

@end
