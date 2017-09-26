//
//  WalletDialogView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"

/**
 钱包功能目前仅支持蚌埠停车业务的缴费支付，请谨慎充值使用！
 */
@interface WalletDialogView : CTXBaseView<CAAnimationDelegate> {
    CGFloat imageWidth;
    CGFloat imageHeight;
}

@property (nonatomic, retain) UIView *bgView;

@property (nonatomic, strong) ClickListener backListener;

- (void) showView;

@end
