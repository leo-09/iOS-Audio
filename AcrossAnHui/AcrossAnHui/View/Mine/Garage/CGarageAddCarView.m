//
//  CGarageAddCarView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CGarageAddCarView.h"
#import "AppDelegate.h"

static CGFloat btnHeight = 50;

@implementation CGarageAddCarView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGBA(0x000000, 0.4);;
    [self addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _bindParkingBtn = [[UIButton alloc] init];
    _bindParkingBtn.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [_bindParkingBtn setTitleColor:UIColorFromRGB(CTXTextBlackColor) forState:UIControlStateNormal];
    [_bindParkingBtn setTitle:@"绑定停车服务" forState:UIControlStateNormal];
    _bindParkingBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [_bindParkingBtn addTarget:self action:@selector(bindParkingClick) forControlEvents:UIControlEventTouchDown];
    [view addSubview:_bindParkingBtn];
    [_bindParkingBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(btnHeight);
    }];
    
    _addCarBtn = [[UIButton alloc] init];
    _addCarBtn.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [_addCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addCarBtn setTitle:@"添加新车辆" forState:UIControlStateNormal];
    _addCarBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    CTXViewBorderRadius(_addCarBtn, 3.0, 0, [UIColor clearColor]);
    [_addCarBtn addTarget:self action:@selector(addCarClick) forControlEvents:UIControlEventTouchDown];
    [view addSubview:_addCarBtn];
    [_addCarBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(btnHeight);
        make.bottom.equalTo(_bindParkingBtn.top);
    }];
}

- (void) addCarClick {
    [self hideAnimation];
    
    if (self.addCarListener) {
        self.addCarListener();
    }
}

- (void) bindParkingClick {
    [self hideAnimation];
    
    if (self.bindParkingListener) {
        self.bindParkingListener();
    }
}

- (void) showView {
    UIWindow *window = [AppDelegate sharedDelegate].window;
    [window addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [self showAnimation];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideAnimation];
}

#pragma mark - 动画

- (void) showAnimation {
    // addCarAnimation
    CABasicAnimation *addCarAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    addCarAnimation.duration = 0.3;
    addCarAnimation.delegate = self;
    addCarAnimation.fillMode = kCAFillModeForwards;
    addCarAnimation.removedOnCompletion = NO;
    // 起始帧和终了帧的设定
    addCarAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-CTXScreenWidth / 2, CTXScreenHeight - btnHeight * 3 / 2)];
    addCarAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CTXScreenWidth / 2, CTXScreenHeight - btnHeight * 3 / 2)];
    // 添加动画
    [self.addCarBtn.layer removeAllAnimations];
    [self.addCarBtn.layer addAnimation:addCarAnimation forKey:@"show-layer"];
    
    // bindParkingCarAnimation
    CABasicAnimation *bindParkingCarAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    bindParkingCarAnimation.duration = 0.3;
    bindParkingCarAnimation.delegate = self;
    bindParkingCarAnimation.fillMode = kCAFillModeForwards;
    bindParkingCarAnimation.removedOnCompletion = NO;
    // 起始帧和终了帧的设定
    bindParkingCarAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(CTXScreenWidth * 3 / 2, CTXScreenHeight - btnHeight / 2)];
    bindParkingCarAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CTXScreenWidth / 2, CTXScreenHeight - btnHeight / 2)];
    // 添加动画
    [self.bindParkingBtn.layer removeAllAnimations];
    [self.bindParkingBtn.layer addAnimation:bindParkingCarAnimation forKey:@"show-layer"];
}

- (void) hideAnimation {
    // addCarAnimation
    CABasicAnimation *addCarAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    addCarAnimation.duration = 0.2; // 持续时间
    addCarAnimation.delegate = self;
    addCarAnimation.fillMode = kCAFillModeForwards;
    addCarAnimation.removedOnCompletion = NO;
    // 起始帧和终了帧的设定
    addCarAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(-CTXScreenWidth / 2, CTXScreenHeight - btnHeight * 3 / 2)];
    addCarAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(CTXScreenWidth / 2, CTXScreenHeight - btnHeight * 3 / 2)];
    // 添加动画
    [self.addCarBtn.layer removeAllAnimations];
    [self.addCarBtn.layer addAnimation:addCarAnimation forKey:@"hide-layer"];
    
    // bindParkingCarAnimation
    CABasicAnimation *bindParkingCarAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    bindParkingCarAnimation.duration = 0.2; // 持续时间
    bindParkingCarAnimation.delegate = self;
    bindParkingCarAnimation.fillMode = kCAFillModeForwards;
    bindParkingCarAnimation.removedOnCompletion = NO;
    // 起始帧和终了帧的设定
    bindParkingCarAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CTXScreenWidth * 3 / 2, CTXScreenHeight - btnHeight / 2)];
    bindParkingCarAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(CTXScreenWidth / 2, CTXScreenHeight - btnHeight / 2)];
    // 添加动画
    [self.bindParkingBtn.layer removeAllAnimations];
    [self.bindParkingBtn.layer addAnimation:bindParkingCarAnimation forKey:@"hide-layer"];
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
