//
//  ParkingDialogView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingDialogView.h"
#import "AppDelegate.h"

@implementation ParkingDialogView

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
        make.width.equalTo(CTXScreenWidth - 60);
        make.height.equalTo(@160);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    _titleLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@14);
        make.right.equalTo(@(-14));
        make.top.equalTo(@15);
    }];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:14.0];
    _contentLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    _contentLabel.numberOfLines = 0;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_contentLabel];
    [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@14);
        make.right.equalTo(@(-14));
        make.top.equalTo(_titleLabel.bottom).offset(15);
    }];
    
    _button = [[UIButton alloc] init];
    _button.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    CTXViewBorderRadius(_button, 3.0, 0, [UIColor clearColor]);
    [_button addTarget:self action:@selector(btnClickListener) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:_button];
    [_button makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@14);
        make.right.equalTo(@(-14));
        make.bottom.equalTo(@(-15));
        make.height.equalTo(@35);
    }];
    
}

- (void) btnClickListener {
    if (self.btnListener) {
        [self hideAnimation];
        
        self.btnListener();
    }
}

- (void) setTitle:(NSString *)title content:(NSString *)content btnTitle:(NSString *)btnTitle {
    _titleLabel.text = title;
    _contentLabel.text = content;
    [_button setTitle:btnTitle forState:UIControlStateNormal];
}

- (void) showView {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;
    
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
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CGPoint center = appDelegate.window.center;
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
