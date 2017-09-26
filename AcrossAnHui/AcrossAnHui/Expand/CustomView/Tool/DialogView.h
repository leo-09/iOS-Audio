//
//  DialogView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

/**
 对话框
 */
@interface DialogView : CTXBaseView<CAAnimationDelegate>

@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *topBtn;
@property (nonatomic, retain) UIButton *bottomBtn;

@property (nonatomic, copy) ClickListener topBtnListener;
@property (nonatomic, copy) ClickListener bottomBtnListener;

- (void) setTitle:(NSString *)title topBtnTitle:(NSString *)topBtnTitle bottomBtnTitle:(NSString *)bottomBtnTitle;
- (void) showView;

@end
