//
//  OrderRoadInfoViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/5.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapNaviKit/AMapNaviRoute.h>
#import "MANaviRoute.h"

/**
 在地图查看 定制路况 的详情，可导航
 */
@interface OrderRoadInfoViewController : CTXBaseViewController<AMapSearchDelegate, MAMapViewDelegate>

@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, retain) AMapSearchAPI *search;
@property (nonatomic, retain) AMapRoute *route;

@property (nonatomic, retain) MANaviRoute *naviRoute;

@property (nonatomic, retain) UILabel *roadInfoLabel;

@end
