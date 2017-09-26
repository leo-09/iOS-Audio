//
//  CarFriendDialogView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendDialogView.h"
#import "AppDelegate.h"

@interface CarFriendDialogView()

@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, assign) CGFloat bgViewWidth;
@property (nonatomic, assign) CGFloat bgViewHeight;

@end

@implementation CarFriendDialogView

- (instancetype) init {
    if (self = [super init]) {
        
        self.bgViewWidth = 98;
        self.bgViewHeight = 86;
        
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.05);
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    _bgView = [[UIView alloc] init];
    [self addSubview:_bgView];
    [_bgView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.top.equalTo(@64);
        make.width.equalTo(self.bgViewWidth);
        make.height.equalTo(self.bgViewHeight);
    }];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tan_kuang"]];
    [_bgView addSubview:iv];
    [iv makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bgView);
    }];
    
    UIButton *collectionBtn = [[UIButton alloc] init];
    [collectionBtn setImage:[UIImage imageNamed:@"shoucnag_1"] forState:UIControlStateNormal];
    [collectionBtn setTitle:@"   收藏" forState:UIControlStateNormal];
    [collectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    collectionBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [collectionBtn addTarget:self action:@selector(collection) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:collectionBtn];
    [collectionBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgView.centerX);
        make.bottom.equalTo(@0);
        make.height.equalTo(@38);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(collectionBtn.left);
        make.right.equalTo(collectionBtn.right);
        make.height.equalTo(@1);
        make.bottom.equalTo(collectionBtn.top);
    }];
    
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn setImage:[UIImage imageNamed:@"carFriendfenxiang_1"] forState:UIControlStateNormal];
    [shareBtn setTitle:@"   分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:shareBtn];
    [shareBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgView.centerX);
        make.bottom.equalTo(lineView.top);
        make.height.equalTo(@38);
    }];
}

#pragma mark - event response

- (void) collection {
    [self hideAnimation];
    
    if (self.collectionListener) {
        self.collectionListener();
    }
}

- (void) share {
    [self hideAnimation];
    
    if (self.shareListener) {
        self.shareListener();
    }
}

#pragma mark - public method

- (void) showView {
    UIWindow *window = [AppDelegate sharedDelegate].window;
    [window addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [self showAnimation];
}

#pragma mark - UITouch事件

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideAnimation];
}

#pragma mark - 动画

- (void) showAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项的设定
    animation.duration = 0.3;
    animation.delegate = self;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.bgView.layer removeAllAnimations];
    [self.bgView.layer addAnimation:animation forKey:@"show-layer"];
}

- (void) hideAnimation {
    if (self.bgView.isHidden) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项的设定
    animation.duration = 0.2; // 持续时间
    animation.delegate = self;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.bgView.layer removeAllAnimations];
    [self.bgView.layer addAnimation:animation forKey:@"hide-layer"];
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
