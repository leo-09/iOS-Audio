//
//  DialogView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "DialogView.h"
#import "AppDelegate.h"

@implementation DialogView

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
        make.width.equalTo(CTXScreenWidth - 90);
        make.height.equalTo(@190);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    _titleLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@14);
        make.right.equalTo(@(-14));
        make.top.equalTo(@13);
    }];
    
    _topBtn = [[UIButton alloc] init];
    _topBtn.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [_topBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _topBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    CTXViewBorderRadius(_topBtn, 3.0, 0, [UIColor clearColor]);
    [_topBtn addTarget:self action:@selector(topBtnClickListener) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:_topBtn];
    [_topBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@14);
        make.right.equalTo(@(-14));
        make.top.equalTo(_titleLabel.bottom).offset(@15);
        make.height.equalTo(@35);
    }];
    
    _bottomBtn = [[UIButton alloc] init];
    _bottomBtn.backgroundColor = UIColorFromRGB(0xfe6e00);
    [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    CTXViewBorderRadius(_bottomBtn, 3.0, 0, [UIColor clearColor]);
    [_bottomBtn addTarget:self action:@selector(bottomBtnClickListener) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:_bottomBtn];
    [_bottomBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@14);
        make.right.equalTo(@(-14));
        make.top.equalTo(_topBtn.bottom).offset(@15);
        make.height.equalTo(@35);
    }];
}

- (void) topBtnClickListener {
    [self hideAnimation];
    
    if (self.topBtnListener) {
        self.topBtnListener();
    }
}

- (void) bottomBtnClickListener {
    [self hideAnimation];
    
    if (self.bottomBtnListener) {
        self.bottomBtnListener();
    }
}

- (void) setTitle:(NSString *)title topBtnTitle:(NSString *)topBtnTitle bottomBtnTitle:(NSString *)bottomBtnTitle {
    _titleLabel.text = title;
    [_topBtn setTitle:topBtnTitle forState:UIControlStateNormal];
    [_bottomBtn setTitle:bottomBtnTitle forState:UIControlStateNormal];
}

- (void) showView {
    UIWindow *window = [AppDelegate sharedDelegate].window;
    [window addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
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
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bgView.center.x, self.bgView.center.y + CTXScreenHeight)];
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
    CGPoint center = [AppDelegate sharedDelegate].window.center;
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
