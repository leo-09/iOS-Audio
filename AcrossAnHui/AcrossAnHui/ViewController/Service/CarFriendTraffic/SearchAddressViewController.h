//
//  SearchAddressViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MapSearchView.h"
#import "NearByMAPointAnnotation.h"

/**
 兴趣点搜索
 */
@interface SearchAddressViewController : CTXBaseViewController<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, retain) MapSearchView *mapSearchView;

@property (nonatomic, copy) NSString *resource;// 来源：起点／终点
@property (nonatomic, retain) NearByMAPointAnnotation *selectedAnnotation;

@end
