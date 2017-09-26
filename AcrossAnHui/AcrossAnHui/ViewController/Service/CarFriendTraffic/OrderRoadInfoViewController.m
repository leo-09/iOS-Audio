//
//  OrderRoadInfoViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/5.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "OrderRoadInfoViewController.h"
#import "GPSNaviViewController.h"

static int bottomViewHeight = 110;

@implementation OrderRoadInfoViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实时路况";
    
    [self addMap];
    
    [self showHub];
    [self calculateRoute];
}

- (void) addMap {
    // mapView
    self.mapView = [[MAMapView alloc] init];
    self.mapView.delegate = self;
    self.mapView.showsScale = NO;
    self.mapView.showsCompass = NO;
    self.mapView.rotateEnabled = NO;
    self.mapView.rotateCameraEnabled = NO;
    
    // 定位
    [self startUpdatingLocationWithBlock:^{
        CLLocationDegrees latitude = [AppDelegate sharedDelegate].aMapLocationModel.latitude;
        CLLocationDegrees longitude = [AppDelegate sharedDelegate].aMapLocationModel.longitude;
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        self.mapView.zoomLevel = 13;
    }];
    
    [self.view addSubview:self.mapView];
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

- (void) close:(id)sender {
    [super close:sender];
    
    // 清空地图
    if (self.mapView) {
        [self.mapView removeFromSuperview];
        self.mapView.delegate = nil;
        self.mapView = nil;
    }
}

- (BOOL) gestureRecognizerShouldBegin {
    return NO;  // 关闭侧滑
}

#pragma mark - private method

// 进行路径规划
- (void) calculateRoute {
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    // 驾车路径规划
    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
    request.origin = [AMapGeoPoint locationWithLatitude:self.startPoint.latitude longitude:self.startPoint.longitude];
    request.destination = [AMapGeoPoint locationWithLatitude:self.endPoint.latitude longitude:self.endPoint.longitude];
    request.requireExtension = YES;
    request.strategy = 2;
    
    [self.search AMapDrivingRouteSearch:request];
}

- (void) addAnnotation {
    MAPointAnnotation *startAnno = [[MAPointAnnotation alloc] init];
    startAnno.coordinate = CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude);
    startAnno.title = @"起点";
    
    MAPointAnnotation *endAnno = [[MAPointAnnotation alloc] init];
    endAnno.coordinate = CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude);
    endAnno.title = @"终点";
    
    NSArray *annos = @[ startAnno, endAnno ];
    [self.mapView addAnnotations:annos];
    [self.mapView showAnnotations:annos animated:YES];
}

// 展示当前路线方案
- (void) presentCurrentCourse {
    AMapGeoPoint *startPoint = [AMapGeoPoint locationWithLatitude:self.startPoint.latitude longitude:self.startPoint.longitude];
    AMapGeoPoint *endPoint = [AMapGeoPoint locationWithLatitude:self.endPoint.latitude longitude:self.endPoint.longitude];
    
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths.firstObject withNaviType:MANaviAnnotationTypeDrive showTraffic:YES startPoint:startPoint endPoint:endPoint];
    [self.naviRoute addToMapView:self.mapView];
    
    [self.mapView showOverlays:self.naviRoute.routePolylines edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        NSString *indetifier = @"pointReuseIndetifier";
        
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:indetifier];
        if (!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:indetifier];
            annotationView.canShowCallout = YES;
            annotationView.draggable = NO;
        }
        
        if ([annotation.title isEqualToString:@"起点"]) {
            annotationView.image = [UIImage imageNamed:@"default_navi_route_startpoint"];
        } else if ([annotation.title isEqualToString:@"终点"]) {
            annotationView.image = [UIImage imageNamed:@"default_navi_route_endpoint"];
        }
        
        return annotationView;
    }
    
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[LineDashPolyline class]]) {
        LineDashPolyline *lineDashPolyline = (LineDashPolyline *) overlay;
        
        MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc] initWithOverlay:lineDashPolyline.polyline];
        renderer.lineWidth = 8.0;
        renderer.strokeColor = [UIColor redColor];
        renderer.lineDash = YES;
        
        return renderer;
    }
    
    if ([overlay isKindOfClass:[MANaviPolyline class]]) {
        MANaviPolyline *maNaviPolyline = (MANaviPolyline *) overlay;
        
        MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc] initWithOverlay:maNaviPolyline.polyline];
        renderer.lineWidth = 8.0;
        
        if (maNaviPolyline.type == MANaviAnnotationTypeWalking) {
            renderer.strokeColor = self.naviRoute.walkingColor;
        } else if (maNaviPolyline.type == MANaviAnnotationTypeRailway) {
            renderer.strokeColor = self.naviRoute.railwayColor;
        } else {
            renderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return renderer;
    }
    
    if ([overlay isKindOfClass:[MAMultiPolyline class]]) {
        MAMultiColoredPolylineRenderer *renderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        renderer.lineWidth = 8.0;
        renderer.strokeColors = self.naviRoute.multiPolylineColors;
        
        return renderer;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    [self hideHub];
    
    if (!response.route) {
        [self.mapView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    } else {
        [self.mapView updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-bottomViewHeight);
        }];
        
        // 解析response获取路径信息
        [self addAnnotation];
        self.route = nil;
        
        if (response.count > 0) {
            NSInteger duration = response.route.paths.firstObject.duration;
            NSInteger distance = response.route.paths.firstObject.distance;
            
            int hour = (int)(duration / 3600);
            int minutes = (duration / 60) % 60;
            
            NSString *roadinfoStr;
            if (hour == 0) {
                roadinfoStr = [NSString stringWithFormat:@"%d分钟  %0.2f公里", minutes, (distance / 1000.0)];
            } else {
                roadinfoStr = [NSString stringWithFormat:@"%d时%d分  %0.2f公里", hour, minutes, (distance / 1000.0)];
            }
            
            [self addBottomView];
            self.roadInfoLabel.text = roadinfoStr;
            
            self.route = response.route;
            [self presentCurrentCourse];
        }
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    [self showTextHubWithContent:@"检索失败"];
    [self hideHub];
}

#pragma mark - view

- (void) addBottomView {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@110);
    }];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [btn setTitle:@"开始导航" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    CTXViewBorderRadius(btn, 5, 0, [UIColor clearColor]);
    [btn addTarget:self action:@selector(navi) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.centerY);
        make.right.equalTo(-12);
        make.width.equalTo(100);
        make.height.equalTo(42);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"全程约";
    titleLabel.font = [UIFont systemFontOfSize:CTXTextFont];
    titleLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    [bottomView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@30);
        make.right.equalTo(btn.left).offset(-12);
    }];
    
    _roadInfoLabel = [[UILabel alloc] init];
    _roadInfoLabel.font = [UIFont systemFontOfSize:18.0];
    _roadInfoLabel.textColor = UIColorFromRGB(CTXTextBlackColor);
    [bottomView addSubview:_roadInfoLabel];
    [_roadInfoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@60);
        make.right.equalTo(btn.left).offset(-12);
    }];
}

#pragma mark - event response

// 开始导航
- (void) navi {
    GPSNaviViewController *controller = [[GPSNaviViewController alloc] init];
    controller.startPoint = self.startPoint;
    controller.endPoint   = self.endPoint;
    controller.strategy = AMapNaviDrivingStrategySinglePrioritiseDistance;
    [self basePushViewController:controller];
}

@end
