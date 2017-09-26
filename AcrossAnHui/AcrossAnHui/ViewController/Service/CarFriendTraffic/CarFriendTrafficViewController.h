//
//  CarFriendTrafficViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "MapSearchView.h"
#import "CoreServeNetData.h"
#import "CarFriendTrafficModel.h"
#import "TrafficEventInfoView.h"
#import "CarTrafficMAPointAnnotation.h"

/**
 车友路况
 */
@interface CarFriendTrafficViewController : CTXBaseViewController<MAMapViewDelegate>

@property (nonatomic, retain) NSMutableArray<CarFriendTrafficModel *> *trafficModels;

@property (nonatomic, retain) MAMapView *mapView;
@property (nonatomic, retain) MapSearchView *mapSearchView;

@property (nonatomic, retain) NSMutableArray *annos;
@property (nonatomic, retain) MAPointAnnotation *searchAnno;

@property (nonatomic, retain) UIView *operationView;
@property (nonatomic, retain) TrafficEventInfoView *eventInfoView;

@property (nonatomic, retain) CarTrafficMAPointAnnotation *currnetAnnotation;

@property (nonatomic, retain) CoreServeNetData *serviceNetData;

@end
