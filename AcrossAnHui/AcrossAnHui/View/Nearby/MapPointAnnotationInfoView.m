//
//  MapPointAnnotationInfoView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "MapPointAnnotationInfoView.h"
#import "UILabel+lineSpace.h"

@implementation MapPointAnnotationInfoView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.top.equalTo(@0);
    }];
    
    UIButton *hideBtn = [[UIButton alloc] init];// 高40
    [hideBtn setImage:[UIImage imageNamed:@"icon_hs"] forState:UIControlStateNormal];
    [hideBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchDown];
    [_contentView addSubview:hideBtn];
    [hideBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.top.equalTo(@0);
        make.height.equalTo(@40);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    _nameLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    _nameLabel.numberOfLines = 2;
    [_contentView addSubview:_nameLabel];
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.top.equalTo(hideBtn.bottom);
    }];
    
    _addrLabel = [[UILabel alloc] init];
    _addrLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    _addrLabel.font = [UIFont systemFontOfSize:14];
    _addrLabel.numberOfLines = 2;
    [_contentView addSubview:_addrLabel];
    [_addrLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@28);
        make.right.equalTo(@(-12));
        make.top.equalTo(_nameLabel.bottom).offset(@10);
    }];
    
    UIImageView *addrIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"near_add"]];
    [_contentView addSubview:addrIcon];
    [addrIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_addrLabel.centerY);
        make.left.equalTo(@12);
    }];
    
    _phoneLabel = [[UILabel alloc] init];
    _phoneLabel.textColor = UIColorFromRGB(CTXBaseFontColor);
    _phoneLabel.font = [UIFont systemFontOfSize:14];
    [_contentView addSubview:_phoneLabel];
    [_phoneLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@28);
        make.right.equalTo(@(-12));
        make.top.equalTo(_addrLabel.bottom).offset(@10);
    }];
    
    _phoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dianhua"]];
    [_contentView addSubview:_phoneIcon];
    [_phoneIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_phoneLabel.centerY);
        make.left.equalTo(@12);
    }];
    
    _phoneBtn = [[UIButton alloc] init];
    [_phoneBtn setImage:[UIImage imageNamed:@"bodadianhua"] forState:UIControlStateNormal];
    [_phoneBtn setTitle:@" 拨打电话" forState:UIControlStateNormal];
    _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_phoneBtn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
    [_phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchDown];
    [_contentView addSubview:_phoneBtn];
    [_phoneBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@40);
        make.width.equalTo(CTXScreenWidth / 2);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
    [_contentView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@0.8);
        make.centerY.equalTo(_phoneBtn.centerY);
        make.right.equalTo(_phoneBtn.right);
    }];
    
    UIButton *naviBtn = [[UIButton alloc] init];
    [naviBtn setImage:[UIImage imageNamed:@"neardaohang"] forState:UIControlStateNormal];
    [naviBtn setTitle:@" 开始导航" forState:UIControlStateNormal];
    naviBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [naviBtn setTitleColor:UIColorFromRGB(CTXBaseFontColor) forState:UIControlStateNormal];
    [naviBtn addTarget:self action:@selector(startNavi) forControlEvents:UIControlEventTouchDown];
    [_contentView addSubview:naviBtn];
    [naviBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phoneBtn.right);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@40);
    }];
    
    UIView *vLineView = [[UIView alloc] init];
    vLineView.backgroundColor = UIColorFromRGB(CTXBLineViewColor);
    [_contentView addSubview:vLineView];
    [vLineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
        make.height.equalTo(@0.6);
        make.bottom.equalTo(naviBtn.top);
    }];
}

#pragma mark - getter/setter

- (void) setModel:(FastDealInfoModel *)model {
    _model = model;
    
    _nameLabel.text = _model.name;
    _addrLabel.text = _model.addr;
    _phoneLabel.text = _model.tel;
    
    CGFloat nameLabelHeight = [_nameLabel getLabelHeightWithLineSpace:0 WithWidth:(CTXScreenWidth-24) WithNumline:2].height;
    CGFloat addrLabelHeight = [_addrLabel getLabelHeightWithLineSpace:0 WithWidth:(CTXScreenWidth-24) WithNumline:2].height;
    CGFloat distance = (30-nameLabelHeight) + (30-addrLabelHeight);
    
    if (!_model.tel) {
        _phoneLabel.hidden = YES;
        _phoneIcon.hidden = YES;
        
        [_contentView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(35+distance));
        }];
        [_phoneBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    } else {
        _phoneLabel.hidden = NO;
        _phoneIcon.hidden = NO;
        
        [_contentView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(distance);
        }];
        [_phoneBtn updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(CTXScreenWidth / 2);
        }];
    }
}

#pragma mark - event response

- (void) hideView {
    isClickHide = YES;
    [self hide];
}

- (void) call {
    if (self.callPhoneListener) {
        self.callPhoneListener(self.model.tel);
    }
}

- (void) startNavi {
    if (self.startNaviListener) {
        self.startNaviListener(self.model.latitude, self.model.longitude);
    }
}

#pragma mark - public method

- (void) hide {
    if (self.isHidden) {
        return;
    }
    
    isShow = NO;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.3; // 持续时间
    animation.delegate = self;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:self.center];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y + self.frame.size.height)];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.layer removeAllAnimations];
    [self.layer addAnimation:animation forKey:@"hide-layer"];
}

- (void) show {
    isShow = YES;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.4;
    animation.delegate = self;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y + self.frame.size.height)];
    animation.toValue = [NSValue valueWithCGPoint:self.center];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.layer removeAllAnimations];
    [self.layer addAnimation:animation forKey:@"show-layer"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    if (anim.duration == 0.4) {
        self.hidden = NO;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim.duration == 0.3) {
        self.hidden = YES;
        
        if (isShow) {
            isShow = NO;
            [self show];
        }
        
        if (isClickHide) {
            isClickHide = NO;
            if (self.hideListener) {
                self.hideListener();
            }
        }
    }
}

@end
