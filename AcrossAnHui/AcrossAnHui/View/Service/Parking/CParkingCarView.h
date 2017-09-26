//
//  CParkingCarView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CTXBaseModel.h"
#import "ParkingCarModel.h"

/**
 停车服务首页的车辆信息View
 */
@interface CParkingCarView : CTXBaseView

@property (nonatomic, retain) ParkingCarModel * model;

@property (nonatomic, retain) UILabel * timeCountLabel;

@property (nonatomic, copy) LoadDataListener showParkingStandardListener;
@property (nonatomic, copy) LoadDataListener addCarListener;
@property (nonatomic, copy) LoadDataListener queryParkingDataListener;        // 当时整五分钟的时候，重新请求停车数据

@end
