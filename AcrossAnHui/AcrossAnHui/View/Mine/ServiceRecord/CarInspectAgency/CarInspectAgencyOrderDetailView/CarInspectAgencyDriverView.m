//
//  CarInspectAgencyDriverView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyDriverView.h"

@implementation CarInspectAgencyDriverView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void) setOrderModel:(CarInspectAgencyOrderModel *)orderModel {
    _orderModel = orderModel;
    
    [self addDriverView];
}

#pragma mark - driverView

- (void) addDriverView {
    // 头像
    _driverHeaderIV = [[UIImageView alloc] init];
    NSURL *url = [NSURL URLWithString:_orderModel.pictureMiddle];
    [_driverHeaderIV setImageWithURL:url placeholder:[UIImage imageNamed:@"db_head"]];
    [self addSubview:_driverHeaderIV];
    [_driverHeaderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@34);
        make.height.equalTo(@34);
        make.left.equalTo(@12.5);
        make.top.equalTo(@15);
    }];
    
    // 司机的星星
    _starRateView = [[CWStarRateView alloc]initWithFrame:CGRectMake(0, 0, 100, 15) numberOfStars:5 photostr:@"hong"];
    _starRateView.allowIncompleteStar = YES;
    _starRateView.hasAnimation = NO;
    float scorePercent = [(_orderModel.carInfo.carInfoNewLevel ? _orderModel.carInfo.carInfoNewLevel : @"50") intValue];
    
    if (scorePercent / 50.0 < 0) {
        _starRateView.scorePercent = 0;
    } else if (scorePercent / 50.0 < 0.2) {
        _starRateView.scorePercent = 0.2;
    } else if (scorePercent / 50.0 < 0.4) {
        _starRateView.scorePercent = 0.4;
    } else if (scorePercent / 50.0 < 0.6) {
        _starRateView.scorePercent = 0.6;
    } else if (scorePercent / 50.0 < 0.8) {
        _starRateView.scorePercent = 0.8;
    } else if (scorePercent / 50.0 < 1.0) {
        _starRateView.scorePercent = 1.0;
    }
    
    [self addSubview:_starRateView];
    [_starRateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_driverHeaderIV.centerY);
        make.left.equalTo(_driverHeaderIV.right).offset(9);
        make.height.equalTo(15);
        make.width.equalTo(@100);
    }];
    
    // 打电话
    UIButton *driverPhoneBtn = [[UIButton alloc] init];
    [driverPhoneBtn setImage:[UIImage imageNamed:@"driver_phone"] forState:UIControlStateNormal];
    [driverPhoneBtn addTarget:self action:@selector(driverPhone) forControlEvents:UIControlEventTouchDown];
    [self addSubview:driverPhoneBtn];
    [driverPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.right.equalTo(@(-12.5));
    }];
    
    // 司机姓名
    _driverNameLabel = [[UILabel alloc] init];
    _driverNameLabel.font = [UIFont systemFontOfSize:15.0f];
    _driverNameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    _driverNameLabel.text = (_orderModel.carInfo.name ? _orderModel.carInfo.name : @"畅通行");
    [self addSubview:_driverNameLabel];
    [_driverNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.top.equalTo(_driverHeaderIV.mas_bottom).offset(20);
    }];
    
    _driverYearLabel = [[UILabel alloc] init];
    _driverYearLabel.font = [UIFont systemFontOfSize:15.0f];
    _driverYearLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    _driverYearLabel.text = [NSString stringWithFormat:@"驾龄：%@年", (_orderModel.carInfo.year ? _orderModel.carInfo.year : @"0")];
    [self addSubview:_driverYearLabel];
    [_driverYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_driverNameLabel.mas_right).offset(40);
        make.centerY.equalTo(_driverNameLabel.mas_centerY);
    }];
    
    _driverIDCardLabel = [[UILabel alloc] init];
    _driverIDCardLabel.font = [UIFont systemFontOfSize:15.0f];
    _driverIDCardLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    _driverIDCardLabel.text = [NSString stringWithFormat:@"身份证号码：%@", (_orderModel.carInfo.idCard ? _orderModel.carInfo.idCard : @"*******************")];
    [self addSubview:_driverIDCardLabel];
    [_driverIDCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12.5);
        make.right.equalTo(@(-12.5));
        make.top.equalTo(_driverNameLabel.mas_bottom).offset(20);
    }];
    
    UIButton *driverPositionBtn = [[UIButton alloc] init];
    [driverPositionBtn setTitle:@"  查看司机位置" forState:UIControlStateNormal];
    [driverPositionBtn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
    driverPositionBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [driverPositionBtn setImage:[UIImage imageNamed:@"iconfont-sevenbabicon"] forState:UIControlStateNormal];
    [driverPositionBtn addTarget:self action:@selector(driverPosition) forControlEvents:UIControlEventTouchDown];
    [self addSubview:driverPositionBtn];
    [driverPositionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-15));
        make.right.equalTo(@(-12.5));
    }];
}

// 查看司机位置
- (void) driverPosition {
    if (self.driverPostionListener) {
        self.driverPostionListener(_orderModel);
    }
}

// 拨打司机电话
- (void) driverPhone {
    if (self.callPhoneListener) {
        self.callPhoneListener(_orderModel);
    }
}

@end
