//
//  VersionUpdateView.h
//  IntelligentParkingManagement
//
//  Created by liyy on 2017/6/7.
//  Copyright © 2017年 ahctx. All rights reserved.
//

#import "CTXBaseView.h"

typedef void (^ClickListener)();

/**
 版本更新View
 */
@interface VersionUpdateView : CTXBaseView<CAAnimationDelegate>

@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UILabel *updateContentLabel;

@property (nonatomic, strong) ClickListener updateVersionListener;

- (void) showView;
- (void) hideView;

- (void) setContent:(NSString *) content;

@end
