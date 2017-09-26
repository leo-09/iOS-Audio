//
//  ParkDetailView.m
//  IntelligentParkingManagement
//
//  Created by liyy on 2017/5/8.
//  Copyright © 2017年 ahctx. All rights reserved.
//

#import "MapParkDetailView.h"

@implementation MapParkDetailView

- (instancetype) initWithMyFrame:(CGRect)frame {
    NSArray* nibArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self = [nibArray objectAtIndex:0];
    if (self) {
        self.frame = frame;
        CTXViewBorderRadius(_parkLabel, 5, 0, [UIColor clearColor]);
        CTXViewBorderRadius(_timeLabel, 5, 1, UIColorFromRGB(CTXThemeColor));
    }
    return self;
}

- (void) setParkInfo:(SiteModel *)parkInfo {
    _parkInfo = parkInfo;
    
    _titleLabel.text = _parkInfo.sitename;
    _parkLabel.text = @"停车场";// 固定
    
    if (![_parkInfo.workTimeNumber isEqualToString:@"0"]) {
        _timeLabel.text = [NSString stringWithFormat:@"%@H", _parkInfo.workTimeNumber];//24H
        _timeLabel.hidden = NO;
    } else {
        _timeLabel.hidden = YES;
    }
    
    _distanceLabel.text = [NSString stringWithFormat:@"距离目的地%.2lf公里", _parkInfo.distance];
    _freeLabel.text = [NSString stringWithFormat:@"%d", _parkInfo.siteFreeNumber];
    _freeTimeLabel.text = [NSString stringWithFormat:@"免%@分钟", _parkInfo.freeTimeSeg];
    _chargeLabel.text = [NSString stringWithFormat:@"%@元/小时", _parkInfo.minPayment];
}

- (IBAction)navi:(id)sender {
    if (self.naviListener) {
        self.naviListener();
    }
}

- (IBAction)pickUp:(id)sender {
    [self hide];
    
    if (self.showInfoListnener) {
        self.showInfoListnener(_parkInfo.sitename, _parkInfo.siteID);
    }
}

- (void) hide {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.2; // 持续时间
    animation.delegate = self;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:self.center];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y + self.frame.size.height)];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.layer addAnimation:animation forKey:@"hide-layer"];
}

- (void) show {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 动画选项的设定
    animation.duration = 0.3;
    animation.delegate = self;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y + self.frame.size.height)];
    animation.toValue = [NSValue valueWithCGPoint:self.center];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    // 添加动画
    [self.layer addAnimation:animation forKey:@"show-layer"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    if (anim.duration == 0.3) {
        self.hidden = NO;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim.duration == 0.2) {
        self.hidden = YES;
    }
}

@end
