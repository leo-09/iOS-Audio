//
//  SignDialogView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SignDialogView.h"

@implementation SignDialogView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    CTXViewBorderRadius(_bgView, 5.0, 0, [UIColor clearColor]);
    [self addSubview:_bgView];
    [_bgView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(CTXScreenWidth - 80);
        make.height.equalTo(@125);
    }];
    
    _closeBtn = [[UIButton alloc] init];
    [_closeBtn setImage:[UIImage imageNamed:@"shut-down"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(hideAnimation) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:_closeBtn];
    [_closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    _titleLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.left.equalTo(@12);
        make.right.equalTo(@(-12));
    }];
    
    _bottomBtn = [[UIButton alloc] init];
    _bottomBtn.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    CTXViewBorderRadius(_bottomBtn, 3.0, 0, [UIColor clearColor]);
    [_bottomBtn addTarget:self action:@selector(bottomBtnClickListener) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:_bottomBtn];
    [_bottomBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@(-20));
        make.top.equalTo(_titleLabel.bottom).offset(@20);
        make.height.equalTo(@35);
    }];
}

- (void) bottomBtnClickListener {
    if (self.bottomBtnListener) {
        [self hideAnimation];
        
        self.bottomBtnListener();
    }
}

- (void) setTitle:(NSString *)title btnTitle:(NSString *)btnTitle {
    _titleLabel.text = title;
    [_bottomBtn setTitle:btnTitle forState:UIControlStateNormal];
}

- (void) showViewWithSuperView:(UIView *)superView {
    self.superView = superView;
    
    [superView addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superView);
    }];
    
    [self showAnimation];
}

#pragma mark - 动画

- (void) hideAnimation {
    if (self.bgView.isHidden) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.2; // 持续时间
    animation.delegate = self;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:self.bgView.center];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bgView.center.x, self.bgView.center.y + CTXScreenHeight / 2)];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.bgView.layer removeAllAnimations];
    [self.bgView.layer addAnimation:animation forKey:@"hide-layer"];
}

- (void) showAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.3;
    animation.delegate = self;
    // 起始帧和终了帧的设定
    CGPoint center = CGPointMake(self.superView.center.x, self.superView.center.y - 64);
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(center.x, center.y + CTXScreenHeight / 2)];
    animation.toValue = [NSValue valueWithCGPoint:center];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.bgView.layer removeAllAnimations];
    [self.bgView.layer addAnimation:animation forKey:@"show-layer"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim.duration == 0.2) {
        [self removeFromSuperview];
    }
}

@end
