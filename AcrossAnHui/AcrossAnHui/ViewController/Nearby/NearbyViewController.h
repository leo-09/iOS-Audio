//
//  NearbyViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapSearchView.h"
#import "MapOperationView.h"
#import "MapPointAnnotationInfoView.h"
#import "NearByNetData.h"

/**
 附近
 */
@interface NearbyViewController : CTXBaseViewController<AMapSearchDelegate, MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, retain) MapSearchView *mapSearchView;
@property (nonatomic, retain) MapOperationView *mapOperationView;
@property (nonatomic, retain) MapPointAnnotationInfoView *annoInfoView;

@property (nonatomic, retain) NSMutableArray *annos;            // 快处中心、停车场、加油站、违章处理的点
@property (nonatomic, retain) MAPointAnnotation *searchAnno;    // 搜索的点

@property (nonatomic, strong) NearByMAPointAnnotation *currnetAnnotation;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;

@property (nonatomic, retain) AMapSearchAPI *aMapSearchAPI;
@property (nonatomic, retain) AMapPOIKeywordsSearchRequest *keyPOISearRequst;

@property (nonatomic, retain) NearByNetData *nearByNetData;

@end
