//
//  ParkingHomeModel.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseModel.h"
#import "ParkingCarModel.h"

/**
 停车服务首页数据 
 */
@interface ParkingHomeModel : CTXBaseModel

@property (nonatomic, assign) BOOL isOdue;          // 是否欠费
@property (nonatomic, assign) int totalOdue;        // 欠费次数
@property (nonatomic, copy) NSString *packfree;     // 剩余停车位数量
@property (nonatomic, retain) NSMutableArray<ParkingCarModel *> *carList;    // 停车信息

@end
