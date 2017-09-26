//
//  HighRoadTrafficViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "CHighRoadTrafficView.h"

/**
 高速路况
 */
@interface HighRoadTrafficViewController : CTXBaseViewController

@property (nonatomic, retain) CHighRoadTrafficView *highRoadTrafficView;

@property (nonatomic, assign) int currentPage;

@end
