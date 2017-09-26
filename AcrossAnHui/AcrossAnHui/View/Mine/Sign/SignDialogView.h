//
//  SignDialogView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

@interface SignDialogView : CTXBaseView<CAAnimationDelegate>

@property (nonatomic, retain) UIView *superView;

@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *closeBtn;
@property (nonatomic, retain) UIButton *bottomBtn;

@property (nonatomic, copy) ClickListener bottomBtnListener;

- (void) setTitle:(NSString *)title btnTitle:(NSString *)btnTitle;
- (void) showViewWithSuperView:(UIView *)superView;

@end
