//
//  ParkingListViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import "YZSortViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "SiteModel.h"
#import "ParkingAreaModel.h"

/**
 附近停车列表页
 */
@interface ParkingListViewController : CTXBaseViewController {
    NSArray *titles;
    NSArray *sortTitles;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, retain) YZSortViewController *areaSortController;
@property (nonatomic, retain) YZSortViewController *roadSortController;
@property (nonatomic, retain) YZSortViewController *smartSortController;

@property (nonatomic, retain) ParkingAreaModel *currentArea;
@property (nonatomic, retain) ParkingRoadModel *currentRoad;
@property (nonatomic, retain) ParkingRoadModel *currentSmart;

@end
