//
//  CarFriendDialogView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

/**
 问小畅、随手拍详情 的 分享／收藏弹窗
 */
@interface CarFriendDialogView : CTXBaseView<CAAnimationDelegate>

@property (nonatomic, copy) ClickListener shareListener;        // 分享
@property (nonatomic, copy) ClickListener collectionListener;   // 收藏

// 显示View
- (void) showView;

@end
