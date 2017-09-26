//
//  DriverPostionViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import <MAMapKit/MAMapKit.h>

/**
 司机位置
 */
@interface DriverPostionViewController : CTXBaseViewController<MAMapViewDelegate>

@property (nonatomic, copy) NSString *orderid;

@property (nonatomic, strong) MAMapView *mapView;

@end
