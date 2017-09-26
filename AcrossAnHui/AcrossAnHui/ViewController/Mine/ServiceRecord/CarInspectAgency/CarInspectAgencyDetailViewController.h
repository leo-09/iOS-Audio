//
//  CarInspectAgencyDetailViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"

/**
 车险代办 我的订单
 */
@interface CarInspectAgencyDetailViewController : CTXBaseViewController {
    int refreshTime;
}

@property (nonatomic, copy) NSString *businessid;

@property (nonatomic, assign) BOOL isFromDBOnlinePayViewController;// 入口

@end
