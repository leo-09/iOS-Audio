//
//  CarInspectAgencyStatusView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyStatusView.h"

@implementation CarInspectAgencyStatusView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void) setOrderModel:(CarInspectAgencyOrderModel *)orderModel {
    _orderModel = orderModel;
    
    [self addStatusView];
}

#pragma mark - statusView

- (void) addStatusView {
    // 订单跟踪
    UIButton *orderTrackBtn = [[UIButton alloc] init];
    [orderTrackBtn setTitle:@"订单跟踪" forState:UIControlStateNormal];
    [orderTrackBtn setTitleColor:UIColorFromRGB(CTXTextBlackColor) forState:UIControlStateNormal];
    orderTrackBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [orderTrackBtn setImage:[UIImage imageNamed:@"iconfont-gengduo"] forState:UIControlStateNormal];
    [orderTrackBtn addTarget:self action:@selector(orderTrack) forControlEvents:UIControlEventTouchDown];
    
    // UIButton的titleEdgeInsets和imageEdgeInsets属性 设置
    orderTrackBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    orderTrackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // imageView在右 titleLabel在左
    [orderTrackBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (75-10), 0, 0)];
    [orderTrackBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
    [self addSubview:orderTrackBtn];
    [orderTrackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.right.equalTo(@(-12));
        make.width.equalTo(@75);
    }];
    
    // 待支付／等待接单／司机已接单...
    _waitPayLabel = [[UILabel alloc] init];
    _waitPayLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    _waitPayLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    [self addSubview:_waitPayLabel];
    [_waitPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orderTrackBtn.centerY);
        make.left.equalTo(@12);
    }];
    
    // 未支付 未取消 等待支付时间大于0
    if ([_orderModel isWaitPay]) {
        self.viewHeight = 90;
        
        // 填充内容
        _waitPayLabel.text = @"待支付：";
        _orderPriveLabel = [[UILabel alloc] init];
        _orderPriveLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _orderPriveLabel.textColor = [UIColor orangeColor];
        _orderPriveLabel.text = [NSString stringWithFormat:@"¥%.2f", _orderModel.payfee];
        [self addSubview:_orderPriveLabel];
        [_orderPriveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(orderTrackBtn.centerY);
            make.left.equalTo(_waitPayLabel.right);
        }];
        
        // waitTintLabel
        _waitTintLabel = [[UILabel alloc] init];
        _waitTintLabel.text = @"逾期未支付，订单将自动取消";
        _waitTintLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _waitTintLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        [self addSubview:_waitTintLabel];
        [_waitTintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_waitPayLabel.left);
            make.top.equalTo(_waitPayLabel.bottom).offset(20);
        }];
    } else {// 已支付接着就已下单
        self.viewHeight = 50;
        
        // 填充内容
        _waitPayLabel.text = _orderModel.statusName;
        [_waitPayLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(orderTrackBtn.mas_left).offset(-12.0);
        }];
    }
}

- (void) orderTrack {
    if (self.orderTrackListener) {
        self.orderTrackListener(_orderModel);
    }
}

@end
