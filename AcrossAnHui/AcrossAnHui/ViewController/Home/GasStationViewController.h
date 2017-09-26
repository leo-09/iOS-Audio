//
//  GasStationViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapPointAnnotationInfoView.h"
#import "NearByNetData.h"
#import "NearByMAPointAnnotation.h"

/**
 附近：加油站跳转过来, 跟附近的tab一样
 */
@interface GasStationViewController : CTXBaseViewController<AMapSearchDelegate, MAMapViewDelegate>

@property (nonatomic, copy) NSString *titleName;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, retain) MapPointAnnotationInfoView *annoInfoView;

@property (nonatomic, strong) NearByMAPointAnnotation *currnetAnnotation;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;

@property (nonatomic, retain) AMapSearchAPI *aMapSearchAPI;
@property (nonatomic, retain) AMapPOIKeywordsSearchRequest *keyPOISearRequst;

@property (nonatomic, retain) NearByNetData *nearByNetData;

@property (nonatomic, assign) BOOL isShowParking;               // 显示停车场
@property (nonatomic, assign) BOOL isShowGasStation;            // 显示加油站
@property (nonatomic, assign) BOOL isShowIllegalDisposalSite;   // 显示违章处理
@property (nonatomic, assign) BOOL isShowFastDeal;              // 快处中心

@end
