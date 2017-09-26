//
//  CarInspectAgencyWaitDriverView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyWaitDriverView.h"

@implementation CarInspectAgencyWaitDriverView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void) setOrderModel:(CarInspectAgencyOrderModel *)orderModel {
    _orderModel = orderModel;
    
    [self addWaitDriverView];
}

#pragma mark - WaitDriverView

- (void) addWaitDriverView {
    UILabel *waitDriverTitleLabel = [[UILabel alloc] init];
    waitDriverTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    waitDriverTitleLabel.textColor = UIColorFromRGB(CTXThemeColor);
    waitDriverTitleLabel.text = @"等待司机接单";
    [self addSubview:waitDriverTitleLabel];
    [waitDriverTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(@15);
    }];
    
    UILabel *waitDriverTintLabel = [[UILabel alloc] init];
    waitDriverTintLabel.font = [UIFont systemFontOfSize:14.0f];
    waitDriverTintLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    waitDriverTintLabel.text = @"推送至附近的司机";
    [self addSubview:waitDriverTintLabel];
    [waitDriverTintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(waitDriverTitleLabel.mas_bottom).offset(10);
    }];
    
    UIImageView *driverIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wait_driver_order"]];
    [self addSubview:driverIV];
    [driverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(waitDriverTintLabel.mas_bottom).offset(10);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    _waitTimeLabel = [[UILabel alloc] init];
    _waitTimeLabel.font = [UIFont systemFontOfSize:15.0f];
    _waitTimeLabel.textColor = UIColorFromRGB(0x00aaff);
    _waitTimeLabel.backgroundColor = [UIColor whiteColor];
    _waitTimeLabel.textAlignment = NSTextAlignmentCenter;
    CTXViewBorderRadius(_waitTimeLabel, 3, 0.6, UIColorFromRGB(0x00aaff));
    [self addSubview:_waitTimeLabel];
    [_waitTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(driverIV.mas_bottom).offset(10);
        make.width.equalTo(@150);
        make.height.equalTo(@36);
    }];
}

- (void) setWaitDriveTime:(NSString *)time {
    _waitTimeLabel.text = time;
}

@end
