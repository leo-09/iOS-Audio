//
//  ParkingMapViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapPointAnnotationInfoView.h"
#import "MapParkDetailView.h"

/**
 停车位地图页
 */
@interface ParkingMapViewController : CTXBaseViewController<MAMapViewDelegate, AMapSearchDelegate, MAMapViewDelegate> {
    NSMutableArray *annotaitons;
    NSArray *parks;
}

@property (nonatomic, retain) SiteModel *siteModel;

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, retain) AMapSearchAPI *aMapSearchAPI;
@property (nonatomic, retain) AMapPOIKeywordsSearchRequest *keyPOISearRequst;

@property (nonatomic, retain) MapParkDetailView *parkDetailView;
@property (nonatomic, retain) MapPointAnnotationInfoView *annoInfoView;

@end
