//
//  OrdeDialogView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

@interface OrdeDialogView : CTXBaseView<CAAnimationDelegate>

@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UIButton *leftBtn;
@property (nonatomic, retain) UIButton *rightBtn;

@property (nonatomic, copy) LoadDataListener btnListener;

- (void) setTitle:(NSString *)title content:(NSString *)content;
- (void) setLeftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle;

- (void) showView;

@end
