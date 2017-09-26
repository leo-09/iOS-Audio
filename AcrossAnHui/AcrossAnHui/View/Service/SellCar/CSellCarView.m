//
//  CSellCarView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CSellCarView.h"

@implementation CSellCarView

- (instancetype) init {
    if (self = [super init]) {
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    // 背景图
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj_1"]];
    [self addSubview:iv];
    [iv makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 我要卖车拿返利
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"我要卖车拿返利" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:UIColorFromRGB(CTXTextBlackColor) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    CTXViewBorderRadius(btn, 5, 0, [UIColor clearColor]);
    [btn addTarget:self action:@selector(sellCar) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-50));
        make.centerX.equalTo(self);
        make.height.equalTo(@45);
        make.width.equalTo(CTXScreenWidth-94);
    }];
    
    // 最高返利金额达到车辆成交价1%
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"最高返利金额达到车辆成交价1%";
    descLabel.textColor = [UIColor whiteColor];
    descLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:descLabel];
    [descLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(btn.top).offset(@(-20));
    }];
    
    // 你卖车，我返利
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"你卖车，我返利";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:30];
    [self addSubview:nameLabel];
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(descLabel.top).offset(@(-15));
    }];
}

- (void) sellCar {
    if (self.sellCarListener) {
        self.sellCarListener();
    }
}

@end
