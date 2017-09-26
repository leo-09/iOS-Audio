//
//  WalletDialogView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "WalletDialogView.h"
#import "AppDelegate.h"

@implementation WalletDialogView

- (instancetype) init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        
        [self addItemView];
    }
    
    return self;
}

- (void) addItemView {
    UIImage *image = [UIImage imageNamed:@"wallet_dialog"];
    imageWidth = image.size.width;
    imageHeight = image.size.height;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    [_bgView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.center);
        make.width.equalTo(imageWidth);
        make.height.equalTo(imageHeight);
    }];
    
    UIImageView *bgIV = [[UIImageView alloc] initWithImage:image];
    [_bgView addSubview:bgIV];
    [bgIV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bgView);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.backgroundColor = UIColorFromRGB(0xD2D2D2);
    CTXViewBorderRadius(cancelBtn, 4.0, 0, [UIColor clearColor]);
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:cancelBtn];
    [cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-24));
        make.right.equalTo(@(-24));
        make.width.equalTo(@(imageWidth / 2 - 28));
        make.height.equalTo(@((imageWidth / 2 - 28) * 25.0 / 68.0));
    }];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.backgroundColor = UIColorFromRGB(CTXThemeColor);
    CTXViewBorderRadius(sureBtn, 4.0, 0, [UIColor clearColor]);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    [sureBtn addTarget:self action:@selector(hideAnimation) forControlEvents:UIControlEventTouchDown];
    [_bgView addSubview:sureBtn];
    [sureBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cancelBtn.centerY);
        make.left.equalTo(@24);
        make.width.equalTo(@(imageWidth / 2 - 28));
        make.height.equalTo(@((imageWidth / 2 - 28) * 25.0 / 68.0));
    }];
    
    UILabel *updateContentLabel = [[UILabel alloc] init];
    updateContentLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    updateContentLabel.textColor = UIColorFromRGB(0x555555);
    updateContentLabel.numberOfLines = 0;
    updateContentLabel.text = @"钱包功能目前仅支持蚌埠停车业务的缴费支付，请谨慎充值使用！";
    [_bgView addSubview:updateContentLabel];
    [updateContentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@24);
        make.right.equalTo(@(-24));
        make.bottom.equalTo(cancelBtn.top).offset(-40);
    }];
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

- (void) back {
    if (self.backListener) {
        [self hideAnimation];
        self.backListener();
    }
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
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bgView.center.x, self.bgView.center.y - imageHeight)];
    
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
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(appDelegate.window.center.x, -imageHeight)];
    animation.toValue = [NSValue valueWithCGPoint:appDelegate.window.center];
    
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
    
    [self.bgView.layer removeAnimationForKey:@"jamp"];
}

@end
