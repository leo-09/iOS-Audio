//
//  CarInspectAgencyWaitCustomerView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyWaitCustomerView.h"
#import "UILabel+lineSpace.h"

@implementation CarInspectAgencyWaitCustomerView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void) setOrderModel:(CarInspectAgencyOrderModel *)orderModel {
    _orderModel = orderModel;
    
    [self addWaitCustomerView];
}

#pragma mark - WaitCustomerView

- (void) addWaitCustomerView {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.textColor = UIColorFromRGB(CTXThemeColor);
    titleLabel.text = @"等待客服派单";
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@15);
    }];
    
    UILabel *tintLabel = [[UILabel alloc] init];
    tintLabel.font = [UIFont systemFontOfSize:14.0f];
    tintLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    tintLabel.numberOfLines = 0;
    tintLabel.text = @"没有司机抢单,正在由e代驾客服进行派单,请耐心等待,如有疑问,可拨打e代驾客服电话咨询";
    [tintLabel getLabelHeightWithLineSpace:15.0 WithWidth:(CTXScreenWidth-24) WithNumline:0];
    
    [self addSubview:tintLabel];
    [tintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.top.equalTo(titleLabel.bottom).offset(@15);
    }];
}

@end
