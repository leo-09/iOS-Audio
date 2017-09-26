//
//  ShowImageView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/15.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ShowImageView.h"
#import "AppDelegate.h"

@implementation ShowImageView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    // 添加手势，点击隐藏
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAnimation)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:gesture];
    
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.center);
        make.width.equalTo(CTXScreenWidth - 40);
        make.height.equalTo((CTXScreenWidth - 40) * 18 / 26);
    }];
}

- (void) showViewWithImagePath:(NSString *)path {
    _imageView.image = [UIImage imageNamed:path];
    
    UIWindow *window = [AppDelegate sharedDelegate].window;
    [window addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [self showAnimation];
}

#pragma mark - 动画

- (void) hideAnimation {
    if (self.imageView.isHidden) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.2; // 持续时间
    animation.delegate = self;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:self.imageView.center];
    
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.imageView.center.x, self.imageView.center.y + CTXScreenHeight)];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.imageView.layer removeAllAnimations];
    [self.imageView.layer addAnimation:animation forKey:@"hide-layer"];
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
    [self.imageView.layer removeAllAnimations];
    [self.imageView.layer addAnimation:animation forKey:@"show-layer"];
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
