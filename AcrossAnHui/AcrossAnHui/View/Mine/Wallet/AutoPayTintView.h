//
//  AutoPayTintView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

typedef void (^ClickListener)();

/**
 自动付款的提示 View
 */
@interface AutoPayTintView : CTXBaseView<CAAnimationDelegate> {
    CGFloat imageWidth;
    CGFloat imageHeight;
}

@property (nonatomic, retain) UIView *bgView;

@property (nonatomic, copy) ClickListener openAutoPayListener;
@property (nonatomic, copy) ClickListener cancelAutoPayListener;

- (void) showView;
- (void) hideView;

@end
