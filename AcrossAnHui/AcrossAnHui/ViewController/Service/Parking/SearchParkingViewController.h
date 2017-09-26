//
//  SearchParkingViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import <MAMapKit/MAMapKit.h>

/**
 搜索停车位
 */
@interface SearchParkingViewController : CTXBaseViewController

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, assign) int currentPage;

@end
