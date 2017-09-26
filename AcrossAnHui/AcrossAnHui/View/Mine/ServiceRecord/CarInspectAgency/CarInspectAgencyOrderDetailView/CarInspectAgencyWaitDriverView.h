//
//  CarInspectAgencyWaitDriverView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarInspectAgencyOrderModel.h"

/**
 车险代办 订单详情 View---头部的状态（等待司机接单）
 */
@interface CarInspectAgencyWaitDriverView : CTXBaseView

@property (nonatomic, retain) CarInspectAgencyOrderModel *orderModel;

@property (nonatomic, retain) UILabel *waitTimeLabel;           // 等待的时间

- (void) setWaitDriveTime:(NSString *)time;

@end
