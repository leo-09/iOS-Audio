//
//  CarInspectAgencyOperationView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "CarInspectAgencyOrderModel.h"

typedef void (^SelectCellModelListener)(id result);

/**
 车险代办 订单详情 View---头部的状态（按钮：支付、取消订单、确认订单、申请售后）
 */
@interface CarInspectAgencyOperationView : CTXBaseView

@property (nonatomic, retain) CarInspectAgencyOrderModel *orderModel;

/*
 等待支付：							取消订单		去支付
 支付后等待接单：						取消订单
 接单后到订单完成：						取消订单		确认订单
 订单完成：							申请售后		没有评价就有 “评价”按钮
 订单取消中：							已支付可显示：	查看状态
 订单取消：							已支付可显示：	申请退款
                                    未支付
                                    申请退款完
                                    申请退款中
 */
@property (nonatomic, retain) UIButton *leftBtn;            // 取消订单、申请售后
@property (nonatomic, retain) UIButton *rightBtn;           // 去支付、确认订单、去评价

@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, copy) SelectCellModelListener cancelOrderListener;
@property (nonatomic, copy) SelectCellModelListener applyRefundListener;
@property (nonatomic, copy) SelectCellModelListener applyServiceListener;
@property (nonatomic, copy) SelectCellModelListener commitOrderListener;
@property (nonatomic, copy) SelectCellModelListener commentOrderListener;
@property (nonatomic, copy) SelectCellModelListener paymentListener;
@property (nonatomic, copy) SelectCellModelListener contactCustomerListener;
@property (nonatomic, copy) SelectCellModelListener orderAgainListener;

- (void) setWaitPayTime:(NSString *)time;

@end
