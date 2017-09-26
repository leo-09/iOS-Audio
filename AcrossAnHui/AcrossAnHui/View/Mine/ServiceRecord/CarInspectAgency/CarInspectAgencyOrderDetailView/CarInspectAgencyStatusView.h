//
//  CarInspectAgencyStatusView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarInspectAgencyOrderModel.h"

typedef void (^SelectCellModelListener)(id result);

/**
 车险代办 订单详情 View---头部的状态（待支付、等待接单、已接单。订单跟踪）
 */
@interface CarInspectAgencyStatusView : CTXBaseView

@property (nonatomic, retain) CarInspectAgencyOrderModel *orderModel;

@property (nonatomic, retain) UILabel *waitPayLabel;            // 待支付／等待接单／司机已接单...
@property (nonatomic, retain) UILabel *orderPriveLabel;         // ¥888.88
@property (nonatomic, retain) UILabel *waitTintLabel;           // 逾期未支付，订单将自动取消

@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, copy) SelectCellModelListener orderTrackListener;

@end
