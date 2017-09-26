//
//  VersionUpdateView.m
//  IntelligentParkingManagement
//
//  Created by liyy on 2017/6/7.
//  Copyright © 2017年 ahctx. All rights reserved.
//

#import "VersionUpdateView.h"
#import "AppDelegate.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"

@implementation VersionUpdateView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    UIImage *image = [UIImage imageNamed:@"update_bg"];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    [_bgView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.center);
        make.width.equalTo(image.size.width);
        make.height.equalTo(image.size.height);
    }];
    
    UIImageView *bgIV = [[UIImageView alloc] initWithImage:image];
    [_bgView addSubview:bgIV];
    [bgIV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bgView);
    }];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:closeBtn];
    [closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.width.equalTo(@50);
        make.height.equalTo(@56);
    }];
    
    UIButton *updateBtn = [[UIButton alloc] init];
    [updateBtn addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:updateBtn];
    [updateBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-16));
        make.centerX.equalTo(_bgView.centerX);
        make.width.equalTo(@150);
        make.height.equalTo(@40);
    }];
    
    _updateContentLabel = [[UILabel alloc] init];
    _updateContentLabel.font = [UIFont systemFontOfSize:12.0f];
    _updateContentLabel.textColor = UIColorFromRGB(0x555555);
    _updateContentLabel.numberOfLines = 0;
    [_bgView addSubview:_updateContentLabel];
    [_updateContentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(image.size.width * (84.0 / 562.0));
        make.right.equalTo(-(image.size.width * (84.0 / 562.0)));
        make.top.equalTo(image.size.height * (508.0 / 897.0));
        make.bottom.equalTo(-(image.size.height * (170.0 / 897.0)));
    }];
}

- (void) updateVersion {
    if (self.updateVersionListener) {
        [self hideView];
        self.updateVersionListener();
    }
}

- (void) setContent:(NSString *) content {
    self.updateContentLabel.text = content;
    [UILabel changeLineSpaceForLabel:self.updateContentLabel WithSpace:2];
}

- (void) showView {
    UIWindow *window = [AppDelegate sharedDelegate].window;
    [window addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [self showAnimation];
}

- (void) hideView {
    [self hideAnimation];
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
