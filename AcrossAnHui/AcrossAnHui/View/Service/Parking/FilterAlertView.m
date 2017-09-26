//
//  FilterAlertView.m
//  IntelligentParkingManagement
//
//  Created by liyy on 2017/5/3.
//  Copyright © 2017年 ahctx. All rights reserved.
//

#import "FilterAlertView.h"

@implementation FilterAlertView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    // contentView
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    CTXViewBorderRadius(contentView, 5, 0, [UIColor whiteColor]);
    [self addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@123);
        make.width.equalTo(@238);
        make.center.equalTo(self);
    }];
    
    // 停车场
    UIButton *parkBtn = [[UIButton alloc] init];
    [parkBtn setImage:[UIImage imageNamed:@"iconfont_tcc"] forState:UIControlStateNormal];
    [parkBtn addTarget:self action:@selector(park) forControlEvents:UIControlEventTouchDown];
    [contentView addSubview:parkBtn];
    [parkBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.center.equalTo(contentView).centerOffset(CGPointMake(0, -8));
    }];
    UILabel *parkLabel = [[UILabel alloc] init];
    parkLabel.text = @"停车场";
    parkLabel.textColor = [UIColor blackColor];
    parkLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:parkLabel];
    [parkLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(parkBtn);
        make.top.equalTo(parkBtn.bottom).offset(10);
    }];
    
    // 路边
    UIButton *roadBtn = [[UIButton alloc] init];
    [roadBtn setImage:[UIImage imageNamed:@"iconfont_lb"] forState:UIControlStateNormal];
    [roadBtn addTarget:self action:@selector(road) forControlEvents:UIControlEventTouchDown];
    [contentView addSubview:roadBtn];
    [roadBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.centerY.equalTo(parkBtn);
        make.right.equalTo(parkBtn.left).offset(-25);
    }];
    UILabel *roadLabel = [[UILabel alloc] init];
    roadLabel.text = @"路边";
    roadLabel.textColor = [UIColor blackColor];
    roadLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:roadLabel];
    [roadLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(roadBtn);
        make.top.equalTo(roadBtn.bottom).offset(10);
    }];
    
    // 全部
    UIButton *allBtn = [[UIButton alloc] init];
    [allBtn setImage:[UIImage imageNamed:@"iconfont_qb"] forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(all) forControlEvents:UIControlEventTouchDown];
    [contentView addSubview:allBtn];
    [allBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.centerY.equalTo(parkBtn);
        make.left.equalTo(parkBtn.right).offset(25);
    }];
    UILabel *allLabel = [[UILabel alloc] init];
    allLabel.text = @"全部";
    allLabel.textColor = [UIColor blackColor];
    allLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:allLabel];
    [allLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(allBtn);
        make.top.equalTo(allBtn.bottom).offset(10);
    }];
    
    // close button
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"iconfont_sc"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchDown];
    [self addSubview:closeBtn];
    [closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.right.equalTo(contentView).offset(10);
        make.bottom.equalTo(contentView.top);
    }];
}

- (void) close {
    [self removeFromSuperview];
}

// 路边
- (void) road {
    [self close];
    if (filterRoadListener) {
        filterRoadListener();
    }
}

// 停车场
- (void) park {
    [self close];
    if (filterParkListener) {
        filterParkListener();
    }
}

// 全部
- (void) all {
    [self close];
    if (filterAllListener) {
        filterAllListener();
    }
}

#pragma mark - public method

- (void) show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

- (void) setFilterRoadListener:(void(^)())listener {
    filterRoadListener = listener;
}

- (void) setFilterParkListener:(void(^)())listener {
    filterParkListener = listener;
}

- (void) setFilterAllListener:(void(^)())listener {
    filterAllListener = listener;
}

@end
