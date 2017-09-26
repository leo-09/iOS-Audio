//
//  PublishRecordView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/8.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "PublishRecordView.h"
#import "AppDelegate.h"

@implementation PublishRecordView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.2);
        [self addItemView];
        
        // 添加手势
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
    
    return self;
}

- (void) tapGesture {
    [self hideAnimation];
    
    if (self.hideViewListener) {
        self.hideViewListener();
    }
}

- (void) addItemView {
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = UIColorFromRGB(0xBFEFFF);
    [self addSubview:_contentView];
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@101);
    }];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fasan_1"]];
    [_contentView addSubview:_imageView];
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentView.centerX);
        make.centerY.equalTo(_contentView.centerY).offset(-10);
    }];
    
    _label = [[UILabel alloc] init];
    _label.text = @"正在录音，点击取消";
    _label.textColor = UIColorFromRGB(CTXTextBlackColor);
    _label.font = [UIFont systemFontOfSize:CTXTextFont];
    [_contentView addSubview:_label];
    [_label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentView.centerX);
        make.bottom.equalTo(@(-20));
    }];
}

#pragma mark - public method

- (void) showViewWithTopHeight:(CGFloat)height {
    
    // 语音图的高度,默认跟“语音\图片 按钮” top对其
    contentViewHeight = CTXScreenHeight - CTXNavigationBarHeight - CTXBarHeight - height + 1;
    [_contentView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(contentViewHeight);
    }];
    [self setNeedsLayout];
    
    UIWindow *window = [AppDelegate sharedDelegate].window;
    [window addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    self.hidden = NO;
    [self showAnimation];
}

- (void) hideView {
    [self hideAnimation];
}

#pragma mark - 动画

- (void) showAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.2;
    animation.delegate = self;
    // 起始帧和终了帧的设定
    CGPoint center = CGPointMake(CTXScreenWidth / 2, CTXScreenHeight - contentViewHeight / 2);
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(center.x, center.y + contentViewHeight)];
    animation.toValue = [NSValue valueWithCGPoint:center];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.contentView.layer removeAllAnimations];
    [self.contentView.layer addAnimation:animation forKey:@"show-layer"];
}

- (void) hideAnimation {
    if (self.isHidden) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.1; // 持续时间
    animation.delegate = self;
    // 起始帧和终了帧的设定
    CGPoint center = self.contentView.center;
    animation.fromValue = [NSValue valueWithCGPoint:center];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(center.x, center.y + contentViewHeight)];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.contentView.layer removeAllAnimations];
    [self.contentView.layer addAnimation:animation forKey:@"hide-layer"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim.duration == 0.1) {
        self.hidden = YES;
    }
}

@end
