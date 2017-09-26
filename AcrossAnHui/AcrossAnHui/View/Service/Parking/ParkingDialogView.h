//
//  ParkingDialogView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

@interface ParkingDialogView : CTXBaseView<CAAnimationDelegate>

@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UIButton *button;

@property (nonatomic, copy) LoadDataListener btnListener;

- (void) setTitle:(NSString *)title content:(NSString *)content btnTitle:(NSString *)btnTitle;
- (void) showView;

@end
