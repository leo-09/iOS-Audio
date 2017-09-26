//
//  CarInspectAgencyOrderDetailView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarInspectAgencyOrderModel.h"
#import "CWStarRateView.h"
#import "CarInspectAgencyStatusView.h"
#import "CarInspectAgencyOrderInfoView.h"
#import "CarInspectAgencyWaitDriverView.h"
#import "CarInspectAgencyWaitCustomerView.h"
#import "CarInspectAgencyDriverView.h"
#import "CarInspectAgencyOperationView.h"
#import "CarInspectAgencyCommentView.h"

/**
 车险代办 订单详情 View
 */
@interface CarInspectAgencyOrderDetailView : CTXBaseView

@property (nonatomic, retain) CarInspectAgencyOrderModel *orderModel;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *contentView;

@property (nonatomic, retain) CarInspectAgencyStatusView *statusView;               // 待支付、等待接单、已接单。订单跟踪
@property (nonatomic, retain) CarInspectAgencyOrderInfoView *orderInfoView;         // 订单详情
@property (nonatomic, retain) CarInspectAgencyWaitDriverView *waitDriverView;       // 等待司机接单
@property (nonatomic, retain) CarInspectAgencyWaitCustomerView *waitCustomerView;   // 等待客服派单
@property (nonatomic, retain) CarInspectAgencyDriverView *driverView;               // 司机信息
@property (nonatomic, retain) CarInspectAgencyOperationView *operationView;         // 按钮：支付、取消订单、确认订单、申请售后
@property (nonatomic, retain) CarInspectAgencyCommentView *commentView;             // 评价View

@property (nonatomic, assign) CGFloat statusViewHeight;
@property (nonatomic, assign) CGFloat orderInfoViewHeight;
@property (nonatomic, assign) CGFloat waitDriverViewHeight;
@property (nonatomic, assign) CGFloat waitCustomerViewHeight;
@property (nonatomic, assign) CGFloat driverViewHeight;
@property (nonatomic, assign) CGFloat operationViewHeight;
@property (nonatomic, assign) CGFloat commentViewHeight;

@property (nonatomic, copy) SelectCellModelListener orderTrackListener;

@property (nonatomic, copy) SelectCellModelListener callPhoneListener;
@property (nonatomic, copy) SelectCellModelListener driverPostionListener;

@property (nonatomic, copy) SelectCellModelListener cancelOrderListener;
@property (nonatomic, copy) SelectCellModelListener applyRefundListener;
@property (nonatomic, copy) SelectCellModelListener applyServiceListener;
@property (nonatomic, copy) SelectCellModelListener commitOrderListener;
@property (nonatomic, copy) SelectCellModelListener commentOrderListener;
@property (nonatomic, copy) SelectCellModelListener paymentListener;
@property (nonatomic, copy) SelectCellModelListener contactCustomerListener;
@property (nonatomic, copy) SelectCellModelListener orderAgainListener;

- (void) setWaitPayTime:(NSString *)time;
- (void) setWaitDriveTime:(NSString *)time;

@end
