//
//  CarInspectAgencyOrderInfoView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarInspectAgencyOrderModel.h"

/**
 车险代办 订单详情 View---头部的状态（订单详情）
 */
@interface CarInspectAgencyOrderInfoView : CTXBaseView

@property (nonatomic, retain) CarInspectAgencyOrderModel *orderModel;

@property (nonatomic, retain) UILabel *orderIDLabel;            // 订单编号
// 下单时间\n联系人\n联系电话\n车牌号\n车检站\n取车地点\n预约取车时间
@property (nonatomic, retain) UILabel *orderInfoLabel;

@property (nonatomic, assign) CGFloat viewHeight;

@end
