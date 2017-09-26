//
//  MagicPushTransition.m
//  HiHome_TMZS
//
//  Created by liyy on 16/11/16.
//  Copyright © 2016年 gxwl. All rights reserved.
//

#import "MagicPushTransition.h"
#import "CarInspectAgencyOnlinePayViewController.h"
//#import "DBOrderDetailViewController.h"

#define duration 0.5f

@implementation MagicPushTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    CarInspectAgencyOnlinePayViewController * fromVC = (CarInspectAgencyOnlinePayViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];// 动画发生的容器
    
    // 把动画前后的两个ViewController加到容器中,顺序很重要,snapShotView在上方
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    [UIView animateWithDuration:duration animations:^{
        fromVC.view.frame = CGRectMake(CTXScreenWidth, 0, CTXScreenWidth, CTXScreenHeight);
    } completion:^(BOOL finished) {
        [fromVC.view removeFromSuperview];
        //告诉系统动画结束
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
