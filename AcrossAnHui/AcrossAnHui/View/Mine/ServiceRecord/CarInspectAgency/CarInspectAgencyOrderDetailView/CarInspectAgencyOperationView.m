//
//  CarInspectAgencyOperationView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyOperationView.h"

@implementation CarInspectAgencyOperationView

- (instancetype) init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void) setOrderModel:(CarInspectAgencyOrderModel *)orderModel {
    _orderModel = orderModel;
    
    if ([_orderModel isWaitDriver] ||
        [_orderModel isOrderWorking] ||
        _orderModel.status == EOrderStatus_Customer_Order) {
        
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    self.viewHeight = 75;// 默认高度
    
    [self addOperationView];
}

#pragma mark - operationView

- (void) addOperationView {
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitleColor:UIColorFromRGB(CTXThemeColor) forState:UIControlStateNormal];
    [_rightBtn setTitleColor:UIColorFromRGB(0x0fafdf) forState:UIControlStateHighlighted];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    CTXViewBorderRadius(_rightBtn, 3.0, 0.6, UIColorFromRGB(CTXThemeColor));
    [_rightBtn addTarget:self action:@selector(rightBtnListener:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(@(-12.5));
        make.height.equalTo(@35);
        make.width.equalTo(@98);
    }];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [_leftBtn setTitleColor:UIColorFromRGB(CTXTextBlackColor) forState:UIControlStateHighlighted];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    CTXViewBorderRadius(_leftBtn, 3.0, 0.6, UIColorFromRGB(0x666666));
    [_leftBtn addTarget:self action:@selector(leftBtnListener:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(_rightBtn.mas_left).offset(-12.5);
        make.height.equalTo(@35);
        make.width.equalTo(@98);
    }];
    
    // 未支付
    if (_orderModel.payStatus == PayStatus_NoPay) {
        
        if (_orderModel.status == EOrderStatus_Cancel_Order) {// 订单取消
            [self notHaveData];
        } else {// 未支付 订单未取消-----等待支付
            [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            
            NSString *title = [NSString stringWithFormat:@"去支付（还剩%@）", [_orderModel firstWaitPayTimeStr]];
            [_rightBtn setTitle:title forState:UIControlStateNormal];
            
            [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@180);
            }];
        }
    } else if (_orderModel.payStatus == PayStatus_Paid) {// 已支付
        if ((_orderModel.status == EOrderStatus_Default) ||
            (_orderModel.status == EOrderStatus_Sure_Order) ||
            (_orderModel.status == EOrderStatus_Waiting_Order) ||
            (_orderModel.status == EOrderStatus_Received_Order)) {
            // 等待司机接单
            [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
            }];
        } else if (_orderModel.status == EOrderStatus_Customer_Order || // 等待客服派单
                   _orderModel.status == EOrderStatus_Open_Order ||
                   _orderModel.status == EOrderStatus_Driver_Arrived ||
                   _orderModel.status == EOrderStatus_Driver_Driving ||
                   _orderModel.status == EOrderStatus_Driver_Destination) {
            // 司机已开启订单／司机已就位／司机开车中
            [_rightBtn setTitle:@"联系客服" forState:UIControlStateNormal];
            [_leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
            }];
        } else if (_orderModel.status == EOrderStatus_Driver_TakeCar) {
            // 司机到达目的地／已收车
            [_rightBtn setTitle:@"确认订单" forState:UIControlStateNormal];
            [_leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
            }];
        } else if (_orderModel.status == EOrderStatus_Completed_Order) {// 订单已完成
            if (_orderModel.comment) {// 已评价
                [_leftBtn setTitle:@"申请售后" forState:UIControlStateNormal];
                [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@0);
                }];
            } else {// 未评价
                [_leftBtn setTitle:@"申请售后" forState:UIControlStateNormal];
                [_rightBtn setTitle:@"去评价" forState:UIControlStateNormal];
            }
        } else if (_orderModel.status == EOrderStatus_Canceling_Order ||
                   _orderModel.status == EOrderStatus_Blocked_Funds) {
            // 订单取消中／资金已冻结
            [_rightBtn setTitle:@"联系客服" forState:UIControlStateNormal];
            [_leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@0);
            }];
        } else if (_orderModel.status == EOrderStatus_Cancel_Order) {// 订单取消
            if (_orderModel.payfee > 0) {
                [_leftBtn setTitle:@"申请退款" forState:UIControlStateNormal];
                [_rightBtn setTitle:@"重新下单" forState:UIControlStateNormal];
            } else {
                [self notHaveData];
            }
        } else {
            [self notHaveData];
        }
    } else {
        // 已退款／未支付／申请退款中
        [self notHaveData];
    }
}

- (void) notHaveData {
    [_leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0);
    }];
    
    [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0);
    }];
    
    self.viewHeight = 0 ;
}

- (void) leftBtnListener:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"取消订单"]) {
        if (self.cancelOrderListener) {
            self.cancelOrderListener(_orderModel);
        }
    } else if ([btn.titleLabel.text isEqualToString:@"申请退款"]) {
        if (self.applyRefundListener) {
            self.applyRefundListener(_orderModel);
        }
    } else {// 申请售后
        if (self.applyServiceListener) {
            self.applyServiceListener(_orderModel);
        }
    }
}

- (void) rightBtnListener:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"确认订单"]) {
        if (self.commitOrderListener) {
            self.commitOrderListener(_orderModel);
        }
    } else if ([btn.titleLabel.text isEqualToString:@"去评价"]) {
        if (self.commentOrderListener) {
            self.commentOrderListener(_orderModel);
        }
    } else if ([btn.titleLabel.text isEqualToString:@"联系客服"]) {
        if (self.contactCustomerListener) {
            self.contactCustomerListener(_orderModel);
        }
    } else if ([btn.titleLabel.text isEqualToString:@"重新下单"]) {
        if (self.orderAgainListener) {
            self.orderAgainListener(_orderModel);
        }
    } else {// 去支付
        if (self.paymentListener) {
            self.paymentListener(_orderModel);
        }
    }
}

- (void) setWaitPayTime:(NSString *)time {
    NSString *title = [NSString stringWithFormat:@"去支付（还剩%@）", time];
    [_rightBtn setTitle:title forState:UIControlStateNormal];
}

@end
