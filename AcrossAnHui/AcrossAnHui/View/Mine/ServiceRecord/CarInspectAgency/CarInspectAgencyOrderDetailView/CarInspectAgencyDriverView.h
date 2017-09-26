//
//  CarInspectAgencyDriverView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarInspectAgencyOrderModel.h"
#import "CWStarRateView.h"

typedef void (^SelectCellModelListener)(id result);

/**
 车险代办 订单详情 View---头部的状态（司机信息）
 */
@interface CarInspectAgencyDriverView : CTXBaseView

@property (nonatomic, retain) CarInspectAgencyOrderModel *orderModel;

@property (nonatomic, retain) UIImageView *driverHeaderIV;
@property (nonatomic, retain) CWStarRateView *starRateView;     // 司机的星星
@property (nonatomic, retain) UILabel *driverNameLabel;         // 司机姓名
@property (nonatomic, retain) UILabel *driverYearLabel;         // 司机驾龄
@property (nonatomic, retain) UILabel *driverIDCardLabel;       // 身份证

@property (nonatomic, copy) SelectCellModelListener callPhoneListener;
@property (nonatomic, copy) SelectCellModelListener driverPostionListener;

@end
