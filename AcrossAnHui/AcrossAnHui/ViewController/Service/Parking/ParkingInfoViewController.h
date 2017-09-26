//
//  ParkingInfoViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import <MAMapKit/MAMapKit.h>

/**
 路边停车详情
 */
@interface ParkingInfoViewController : CTXBaseViewController

@property (nonatomic, assign) NSString *siteID;
@property (nonatomic, assign) NSString *siteName;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
