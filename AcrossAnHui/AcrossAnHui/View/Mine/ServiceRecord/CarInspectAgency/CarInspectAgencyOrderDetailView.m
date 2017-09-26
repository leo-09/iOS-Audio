//
//  CarInspectAgencyOrderDetailView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyOrderDetailView.h"
#import "UILabel+lineSpace.h"
#import "Masonry.h"

@implementation CarInspectAgencyOrderDetailView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
        [self addScrollView];
    }
    
    return self;
}

// 添加UIScrollView
- (void) addScrollView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(@(CTXScreenWidth));
    }];
}

#pragma mark - 设置订单值, 根据订单值来布局

- (void) setOrderModel:(CarInspectAgencyOrderModel *)orderModel {
    _orderModel = orderModel;
    
    // 删除所有的子View
    while (_contentView.subviews.count) {
        [_contentView.subviews.lastObject removeFromSuperview];
    }
    
    [self addStatusView];
    [self addOrderInfoView];
    [self addWaitDriverView];
    [self addWaitCustomerView];
    [self addDriverView];
    [self addOperationView];
    [self addCommentView];
    
    // 布局完  计算contentSize
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_commentView.bottom);
    }];
    
    // contentSize小于scrollView的height，则加1
    CGFloat height = _statusViewHeight + _orderInfoViewHeight + _waitDriverViewHeight + _waitCustomerViewHeight +
                _driverViewHeight + _operationViewHeight + _commentViewHeight;
    
    if (height <= _scrollView.frame.size.height) {
        CGFloat bottomViewHeight = (_scrollView.frame.size.height - height) + 100;
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor redColor];
        [_contentView addSubview:bottomView];
        [bottomView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.top.equalTo(_commentView.bottom);
            make.height.equalTo(bottomViewHeight);
        }];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bottomView.bottom);
        }];
    }
}

#pragma mark - statusView

- (void) addStatusView {
    _statusView = [[CarInspectAgencyStatusView alloc] init];
    _statusView.orderModel = _orderModel;
    _statusViewHeight = _statusView.viewHeight;
    
    [_contentView addSubview:_statusView];
    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(_statusViewHeight);
    }];
    
    @weakify(self)
    [_statusView setOrderTrackListener:^(id result) {
        @strongify(self)
        
        if (self.orderTrackListener) {
            self.orderTrackListener(result);
        }
    }];
}

#pragma mark - orderInfoView

- (void) addOrderInfoView {
    _orderInfoView = [[CarInspectAgencyOrderInfoView alloc] init];
    _orderInfoView.orderModel = _orderModel;
    _orderInfoViewHeight = _orderInfoView.viewHeight;
    
    [_contentView addSubview:_orderInfoView];
    [_orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(_statusView.bottom).offset(10);
        make.height.equalTo(_orderInfoViewHeight);
    }];
}

#pragma mark - waitDriverView

- (void) addWaitDriverView {
    _waitDriverView = [[CarInspectAgencyWaitDriverView alloc] init];
    
    if ([_orderModel isWaitDriver]) {
        
        _waitDriverView.orderModel = _orderModel;
        _waitDriverViewHeight = 160;
    } else {
        _waitDriverViewHeight = 0;
    }
    
    [_contentView addSubview:_waitDriverView];
    [_waitDriverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(_orderInfoView.mas_bottom);
        make.height.equalTo(_waitDriverViewHeight);
    }];
}

- (void) addWaitCustomerView {
    _waitCustomerView = [[CarInspectAgencyWaitCustomerView alloc] init];
    
    if (_orderModel.status == EOrderStatus_Customer_Order) {
        _waitCustomerView.orderModel = _orderModel;
        _waitCustomerViewHeight = 120;
    } else {
        _waitCustomerViewHeight = 0;
    }
    
    [_contentView addSubview:_waitCustomerView];
    [_waitCustomerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(_waitDriverView.mas_bottom);
        make.height.equalTo(_waitCustomerViewHeight);
    }];
}

#pragma mark - driverView

// 司机已接单 ---> 订单完成
- (void) addDriverView {
    _driverView = [[CarInspectAgencyDriverView alloc] init];
    
    if ([_orderModel isOrderWorking]) {
        _driverView.orderModel = _orderModel;
        _driverViewHeight = 170;
    } else {
        _driverViewHeight = 0;
    }
    
    [_contentView addSubview:_driverView];
    [_driverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(_waitCustomerView.mas_bottom);
        make.height.equalTo(_driverViewHeight);
    }];
    
    @weakify(self)
    
    [_driverView setCallPhoneListener:^(id result) {
        @strongify(self)
        
        if (self.callPhoneListener) {
            self.callPhoneListener(result);
        }
    }];
    [_driverView setDriverPostionListener:^(id result) {
        @strongify(self)
        
        if (self.driverPostionListener) {
            self.driverPostionListener(result);
        }
    }];
}

#pragma mark - operationView

- (void) addOperationView {
    _operationView = [[CarInspectAgencyOperationView alloc] init];
    _operationView.orderModel = _orderModel;
    _operationViewHeight = _operationView.viewHeight;
    
    [_contentView addSubview:_operationView];
    [_operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(_operationViewHeight);
        make.top.equalTo(_driverView.mas_bottom);
    }];
    
    @weakify(self)
    
    [_operationView setCancelOrderListener:^(id result) {
        @strongify(self)
        
        if (self.cancelOrderListener) {
            self.cancelOrderListener(result);
        }
    }];
    [_operationView setApplyRefundListener:^(id result) {
        @strongify(self)
        
        if (self.applyRefundListener) {
            self.applyRefundListener(result);
        }
    }];
    [_operationView setApplyServiceListener:^(id result) {
        @strongify(self)
        
        if (self.applyServiceListener) {
            self.applyServiceListener(result);
        }
    }];
    [_operationView setCommitOrderListener:^(id result) {
        @strongify(self)
        
        if (self.commitOrderListener) {
            self.commitOrderListener(result);
        }
    }];
    [_operationView setCommentOrderListener:^(id result) {
        @strongify(self)
        
        if (self.commentOrderListener) {
            self.commentOrderListener(result);
        }
    }];
    [_operationView setPaymentListener:^(id result) {
        @strongify(self)
        
        if (self.paymentListener) {
            self.paymentListener(result);
        }
    }];
    [_operationView setContactCustomerListener:^(id result) {
        @strongify(self)
        
        if (self.contactCustomerListener) {
            self.contactCustomerListener(result);
        }
    }];
    [_operationView setOrderAgainListener:^(id result) {
        @strongify(self)
        
        if (self.orderAgainListener) {
            self.orderAgainListener(result);
        }
    }];
}

#pragma mark - commentView

- (void)addCommentView {
    _commentView = [[CarInspectAgencyCommentView alloc] init];
    
    if ((_orderModel.status == EOrderStatus_Completed_Order) && _orderModel.comment) {// 订单已完成且已评价
        _commentView.orderModel = _orderModel;
        _commentViewHeight = _commentView.viewHeight;
    } else {
        _commentViewHeight = 0;
    }
    
    [_contentView addSubview:_commentView];
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(_operationView.mas_bottom);
        make.height.equalTo(_commentViewHeight);
    }];
}

- (void) setWaitPayTime:(NSString *)time {
    if (self.operationView) {
        [self.operationView setWaitPayTime:time];
    }
}

- (void) setWaitDriveTime:(NSString *)time {
    if (self.waitDriverView) {
        [self.waitDriverView setWaitDriveTime:time];
    }
}

@end
