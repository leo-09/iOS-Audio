//
//  NoNetView.m
//  AcrossAnHui
//
//  Created by ztd on 17/6/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "NoNetView.h"
#import "Masonry.h"
#define CTXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@implementation NoNetView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setItemView];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setItemView];
    }
    return self;
}

- (void) setItemView {
    self.backgroundColor = [UIColor whiteColor];
    _btn = [[UIButton alloc] init];
    [_btn setImage:[UIImage imageNamed:@"zanw_tz"] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-30);
    }];
    
    _label = [[UILabel alloc] init];
    _label.font = [UIFont systemFontOfSize:16];
    _label.textColor = CTXColor(108, 108, 108);
    [self addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_btn.mas_bottom).offset(22);
    }];
}

- (void) setTintLabel:(NSString *)content {
    _label.text = content;
    [_btn setImage:[UIImage imageNamed:@"sb_1"] forState:UIControlStateNormal];
}

- (void) setRequestFailureImageView {
    _label.text = @"网络开小差 请点击重试";
    [_btn setImage:[UIImage imageNamed:@"jiazai_Weizhang"] forState:UIControlStateNormal];
}

- (void) refresh {
    if (refreshListener) {
        refreshListener();
    }
}

- (void) setRefreshListener:(void (^)())listener {
    refreshListener = listener;
}


@end
