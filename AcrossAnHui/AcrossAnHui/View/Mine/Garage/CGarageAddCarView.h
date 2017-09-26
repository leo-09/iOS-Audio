//
//  CGarageAddCarView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

/**
 我的车库的 添加新车辆／绑定停车服务
 */
@interface CGarageAddCarView : CTXBaseView<CAAnimationDelegate>

@property (nonatomic, retain) UIButton *addCarBtn;
@property (nonatomic, retain) UIButton *bindParkingBtn;

@property (nonatomic, copy) ClickListener addCarListener;
@property (nonatomic, copy) ClickListener bindParkingListener;

- (void) showView;

@end
