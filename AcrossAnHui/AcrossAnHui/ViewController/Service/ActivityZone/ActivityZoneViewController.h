//
//  ActivityZoneViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "CActivityZoneView.h"

/**
 活动专区
 */
@interface ActivityZoneViewController : CTXBaseViewController

@property (nonatomic, assign) int currentPage;

@property (nonatomic, retain) CActivityZoneView *activityZoneView;

@end
