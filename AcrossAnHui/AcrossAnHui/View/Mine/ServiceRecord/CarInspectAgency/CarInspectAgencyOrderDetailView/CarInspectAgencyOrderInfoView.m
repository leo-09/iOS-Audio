//
//  CarInspectAgencyOrderInfoView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyOrderInfoView.h"
#import "UILabel+lineSpace.h"

@implementation CarInspectAgencyOrderInfoView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    }
    
    return self;
}

- (void) setOrderModel:(CarInspectAgencyOrderModel *)orderModel {
    _orderModel = orderModel;
    
    [self addOrderInfoView];
}

#pragma mark - statusView

- (void) addOrderInfoView {
    // 订单编号
    UIView *orderIDView = [[UIView alloc] init];
    orderIDView.backgroundColor = [UIColor whiteColor];
    [self addSubview:orderIDView];
    [orderIDView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@45);
    }];
    
    _orderIDLabel = [[UILabel alloc] init];
    _orderIDLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    _orderIDLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    _orderIDLabel.text = [_orderModel businessCodeText];
    [orderIDView addSubview:_orderIDLabel];
    [_orderIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    // 下单时间\n联系人\n联系电话\n车牌号\n车检站\n取车地点\n预约取车时间
    _orderInfoLabel = [[UILabel alloc] init];
    _orderInfoLabel.font = [UIFont systemFontOfSize:15.0f];
    _orderInfoLabel.textColor = UIColorFromRGB(0x333333);
    _orderInfoLabel.text = [_orderModel businessInfoText];
    _orderInfoLabel.numberOfLines = 0;
    CGFloat height = [_orderInfoLabel getLabelHeightWithLineSpace:15 WithWidth:(CTXScreenWidth-24) WithNumline:0].height;
    
    [self addSubview:_orderInfoLabel];
    [_orderInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.top.equalTo(_orderIDLabel.mas_bottom).offset(15);
        make.height.equalTo(@(height));
    }];
    
    self.viewHeight = 45 + height + 35;
}

@end
