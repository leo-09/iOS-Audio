//
//  CParkingCarView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CParkingCarView.h"
#import "OYCountDownManager.h"
#import "YYKit.h"

@implementation CParkingCarView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    }
    
    return self;
}

// 显示
- (void) setModel:(ParkingCarModel *)model {
    _model = model;
    
    if (model.parkingCarID) {   // 有停车记录编号，则显示停车信息
        [self showParkingCarInfo];
    } else {                    // 否则显示添加车辆
        [self showAddParkingCar];
    }
}

// 显示停车内容
- (void) showParkingCarInfo {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    CTXViewBorderRadius(bgView, 4.0, 0, [UIColor clearColor]);
    
    [self addSubview:bgView];
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    UIImageView *carIV = [[UIImageView alloc] init];
    NSURL *url = [NSURL URLWithString:_model.imgurl];
    [carIV setImageWithURL:url placeholder:[UIImage imageNamed:@"MY_Car"]];
    // 图标的尺寸 4:3。跟屏幕比640:232
    CGFloat height = 150 - 60;
    CGFloat width = height * 4.0 / 3.0;
    [bgView addSubview:carIV];
    [carIV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@20);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    
    UILabel *magcardLabel = [[UILabel alloc] init];
    magcardLabel.text = [_model formatPlateNumber];
    magcardLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    magcardLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    [bgView addSubview:magcardLabel];
    [magcardLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(carIV.centerX);
        make.bottom.equalTo(@(-10));
    }];
    
    // 根据'isbusy'来判断是否症状停车
    if (_model.isbusy) {
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
        
        // 停车计时
        UIImageView *timeIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"park_sj"]];
        [bgView addSubview:timeIV];
        [timeIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(carIV.right).offset(20);
            make.top.equalTo(@22);
        }];
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.text = @"停车计时：";
        timeLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        timeLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        [bgView addSubview:timeLabel];
        [timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeIV.centerY);
            make.left.equalTo(timeIV.right).offset(6);
        }];
        
        _timeCountLabel = [[UILabel alloc] init];
        _timeCountLabel.text = @"00:00:00";
        _timeCountLabel.backgroundColor = UIColorFromRGB(0xF39800);
        _timeCountLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        _timeCountLabel.textColor = [UIColor whiteColor];
        _timeCountLabel.textAlignment = NSTextAlignmentCenter;
        CTXViewBorderRadius(_timeCountLabel, 3.0, 0, [UIColor clearColor]);
        [bgView addSubview:_timeCountLabel];
        [_timeCountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeIV.bottom).offset(10);
            make.left.equalTo(timeIV.left);
            make.width.equalTo(@110);
            make.height.equalTo(@26);
        }];
        
        UIImageView *moneyIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"park_q"]];
        [bgView addSubview:moneyIV];
        [moneyIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeIV.left);
            make.top.equalTo(_timeCountLabel.bottom).offset(10);
        }];
        UILabel *moneyLabel = [[UILabel alloc] init];
        moneyLabel.text = [NSString stringWithFormat:@"停车费：%.2f元", _model.money];
        moneyLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        moneyLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        [bgView addSubview:moneyLabel];
        [moneyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(moneyIV.centerY);
            make.left.equalTo(moneyIV.right).offset(6);
        }];
    } else {
        // 尚未停车
        UIImageView *noParkingIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_noparking"]];
        [bgView addSubview:noParkingIV];
        [noParkingIV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(carIV.right).offset(40);
            make.centerY.equalTo(bgView.centerY);
        }];
        UILabel *noParkingLabel = [[UILabel alloc] init];
        noParkingLabel.text = @"尚未停车";
        noParkingLabel.font = [UIFont systemFontOfSize:CTXTextFont];
        noParkingLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
        [bgView addSubview:noParkingLabel];
        [noParkingLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(noParkingIV.centerY);
            make.left.equalTo(noParkingIV.right).offset(10);
        }];
    }
    
    UIButton *standardBtn = [[UIButton alloc] init];
    standardBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [standardBtn setTitle:@"  停车收费标准" forState:UIControlStateNormal];
    [standardBtn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
    [standardBtn setImage:[UIImage imageNamed:@"icon_bz"] forState:UIControlStateNormal];
    [standardBtn addTarget:self action:@selector(showParkingStandard) forControlEvents:UIControlEventTouchDown];
    [bgView addSubview:standardBtn];
    [standardBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.bottom.equalTo(@(-16));
    }];
}

// 停车收费标准
- (void) showParkingStandard {
    if (self.showParkingStandardListener) {
        self.showParkingStandardListener();
    }
}

// 显示‘添加停车车辆’
- (void) showAddParkingCar {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    CTXViewBorderRadius(bgView, 4.0, 0, [UIColor clearColor]);
    
    [self addSubview:bgView];
    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"add_car1"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addCar) forControlEvents:UIControlEventTouchDown];
    [bgView addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.centerX).offset(10);
        make.top.equalTo(@20);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"添加绑定车辆";
    label.textColor = UIColorFromRGB(CTXBaseFontColor);
    label.font = [UIFont systemFontOfSize:CTXTextFont];
    [bgView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.centerX);
        make.bottom.equalTo(@(-20));
    }];
}

- (void) addCar {
    if (self.addCarListener) {
        self.addCarListener();
    }
}

#pragma mark - 倒计时通知回调
- (void)countDownNotification {
    if (_timeCountLabel) {
        // 停车的时间(秒)
        int secondCount = [_model parkingTimeInterval];
        // 转化为HH:mm:ss 显示
        _timeCountLabel.text = [_model parkingTimeDescWithSecondCount:secondCount];
        
        // 如果是整五分钟,则重新请求数据，刷新停车金额
        if (secondCount % 300 == 0) {
            if (self.queryParkingDataListener) {
                self.queryParkingDataListener();
            }
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
