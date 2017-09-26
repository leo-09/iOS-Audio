//
//  CarFriendTrafficViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendTrafficViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "PublishInfoViewController.h"
#import "CarFriendViewController.h"
#import "HighRoadTrafficViewController.h"
#import "SubscribeEventViewController.h"
#import "TrafficEventModel.h"

@implementation CarFriendTrafficViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"车友路况";
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"订阅" style:UIBarButtonItemStyleDone target:self action:@selector(subscribe)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:CTXTextFont] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.view.backgroundColor = UIColorFromRGB(CTXBaseViewColor);
    
    //地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    [self addMapView];
    [self addItemView];
    
    _serviceNetData = [[CoreServeNetData alloc] init];
    _serviceNetData.delegate = self;
    
    [self showHub];
    
    // 定位
    [self startUpdatingLocationWithBlock:^{
        NSString *city =  [AppDelegate sharedDelegate].aMapLocationModel.city;
        NSString *province =  [AppDelegate sharedDelegate].aMapLocationModel.province;
        
        // 只需要请求一次
        [_serviceNetData getNewTrafficListWithCity:city province:province tag:@"getNewTrafficListTag"];
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

// 订阅
- (void) subscribe {
    if (!self.loginModel.token) {// 先登录
        [self loginFirstWithBlock:^(id newToken) {
            [self subscribe];
        }];
    } else {
        SubscribeEventViewController *controller = [[SubscribeEventViewController alloc] initWithStoryboard];
        [self basePushViewController:controller];
    }
}

#pragma mark - MAMapViewDelegate

// 根据overlay生成对应的Renderer
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[ MAPolyline class]]) {
        MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.lineWidth = 3.0;
        renderer.lineDash = true;
        renderer.strokeColor = [UIColor redColor];
        
        return renderer;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    /*
     注意：5.1.0后由于定位蓝点增加了平滑移动功能，如果在开启定位的情况先添加annotation，需要在此回调方法中判断annotation是否为MAUserLocation，从而返回正确的View。
     */
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[NearByMAPointAnnotation class]]) {
        MAPinAnnotationView *annotationView;
        NearByMAPointAnnotation *anno = (NearByMAPointAnnotation *) annotation;
        
        if ([anno.tag isEqualToString:@"MapSearchView"]) {
            static NSString *pointReuseIndetifier = @"MapSearchViewIndetifier";
            annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil) {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
            annotationView.image = [UIImage imageNamed:@"dingwei"];
            annotationView.canShowCallout = YES;
        }
        
        annotationView.imageView.contentMode = UIViewContentModeCenter;
        CGFloat wh = 40;
        annotationView.frame = CGRectMake((annotationView.frame.size.width-wh)/2, (annotationView.frame.size.height-wh)/2, wh, wh);
        
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[CarTrafficMAPointAnnotation class]]) {
        CarTrafficMAPointAnnotation *anno = (CarTrafficMAPointAnnotation *) annotation;
        static NSString *pointReuseIndetifier = @"CarTrafficIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:anno.imageName];
        annotationView.canShowCallout = NO;
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;
        
        annotationView.imageView.contentMode = UIViewContentModeCenter;
        CGFloat wh = 40;
        annotationView.frame = CGRectMake((annotationView.frame.size.width-wh)/2, (annotationView.frame.size.height-wh)/2, wh, wh);
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    if ([view.annotation isKindOfClass:[CarTrafficMAPointAnnotation class]]) {
        self.currnetAnnotation = (CarTrafficMAPointAnnotation *) view.annotation;
        [self.serviceNetData getNewTrafficDetailInfoWithEventId:self.currnetAnnotation.model.trafficID tag:@"getNewTrafficDetailInfoTag"];
    }
}

- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {
    [self.mapSearchView textFieldResignFirstResponder];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getNewTrafficListTag"]) {
        self.trafficModels = [CarFriendTrafficModel convertFromArray:result];
        [self drawAllLocationCoordinate2D];
    }
    
    if ([tag isEqualToString:@"getNewTrafficDetailInfoTag"]) {
        TrafficEventModel *model = [TrafficEventModel convertFromDict:result];
        // 显示事件详情
        [self addEventInfoViewWithModel:model];
    }
    
    if ([tag isEqualToString:@"addTrafficCountTag"]) {
        [self.eventInfoView updateBtnTitle];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    [self showTextHubWithContent:tint];
}

#pragma mark - private method

- (void)addMapView {
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    [self.view insertSubview:self.mapView atIndex:-10];
    
    // MAMapView属性设置
    self.mapView.delegate = self;
    self.mapView.showTraffic = YES;
    
    self.mapView.zoomLevel = 13;
    self.mapView.showsCompass = NO;
    self.mapView.rotateEnabled = NO;
    self.mapView.rotateCameraEnabled = NO;
    self.mapView.showsScale = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
}

// 添加子View
- (void) addItemView {
    // MapSearchView
    _mapSearchView = [[MapSearchView alloc] init];
    @weakify(self)
    [_mapSearchView setUpdateViewHeightBlock:^(BOOL isMax) {
        @strongify(self)
        if (isMax) {
            [self.mapSearchView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(CTXScreenHeight * 3 / 5);
            }];
            self.operationView.hidden = YES;
        } else {
            [self.mapSearchView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(40);
            }];
            self.operationView.hidden = NO;
        }
    }];
    [_mapSearchView setSelectPointAnnotationListener:^(id result) {
        @strongify(self)
        if (self.searchAnno) {
            [self.mapView removeAnnotation:self.searchAnno];
        }
        
        self.searchAnno = (MAPointAnnotation *) result;
        [self.mapView addAnnotation:self.searchAnno];
        self.mapView.centerCoordinate = self.searchAnno.coordinate;
    }];
    [_mapSearchView setStartSearchBlock:^{
        @strongify(self)
        [self showHub];
    }];
    [_mapSearchView setStopSearchBlock:^(id result) {
        @strongify(self)
        [self hideHub];
        if (result) {
            [self showTextHubWithContent:(NSString *)result];
        }
    }];
    // 添加MapSearchView
    [self.view addSubview:_mapSearchView];
    [_mapSearchView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@18);
        make.right.equalTo(@(-18));
        make.top.equalTo(@20);
        make.height.equalTo(40);
    }];
    
    // 添加operationView
    [self.view addSubview:self.operationView];
    [self.operationView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@60);
        make.right.equalTo(@(-18));
        make.width.equalTo(@42);
        make.height.equalTo(4 * (42+15));
    }];
    
    // 报路况
    UIButton *reportedRoadConditionBtn = [[UIButton alloc] init];
    [reportedRoadConditionBtn setImage:[UIImage imageNamed:@"near_shangbao"] forState:UIControlStateNormal];
    [reportedRoadConditionBtn setTitle:@" 报路况" forState:UIControlStateNormal];
    [reportedRoadConditionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reportedRoadConditionBtn.backgroundColor = UIColorFromRGB(CTXThemeColor);
    CTXViewBorderRadius(reportedRoadConditionBtn, 20, 0, [UIColor clearColor]);
    [reportedRoadConditionBtn addTarget:self action:@selector(reportedRoadCondition) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:reportedRoadConditionBtn];
    [reportedRoadConditionBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(18);
        make.right.equalTo(-18);
        make.bottom.equalTo(@(-20));
        make.height.equalTo(40);
    }];
}

- (UIView *) operationView {
    if (!_operationView) {
        _operationView = [[UIView alloc] init];
        _operationView.backgroundColor = [UIColor clearColor];
        
        NSArray *normalImages = @[ @"drawable_djlk", @"shijian_click", @"icon_ssp", @"lukuang" ];
        NSArray *selectedImages = @[ @"drawable_wdjlk", @"shijian", @"icon_ssp", @"lukuang"];
        
        UIButton *lastBtn;
        for (int i = 0; i < normalImages.count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:normalImages[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:selectedImages[i]] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(dealEvent:) forControlEvents:UIControlEventTouchDown];
            [_operationView addSubview:btn];
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@42);
                make.height.equalTo(@42);
                make.left.equalTo(@0);
                if (lastBtn) {
                    make.top.equalTo(lastBtn.bottom).offset(@15);
                } else {
                    make.top.equalTo(@15);
                }
            }];
            
            lastBtn = btn;
        }
    }
    
    return _operationView;
}

// 显示事件详情
- (void) addEventInfoViewWithModel:(TrafficEventModel *)model {
    if (!self.eventInfoView) {
        self.eventInfoView = [[TrafficEventInfoView alloc] init];
    }
    
    @weakify(self)
    [self.eventInfoView setTrafficCountListener:^(NSString *eventID, NSString *tagID){
        @strongify(self)
        // 需要先登录，才能点有用／无用
        if (self.loginModel) {
            [self.serviceNetData addTrafficCountWithToken:self.loginModel.token countId:tagID type:eventID tag:@"addTrafficCountTag"];
        } else {
            // 登录前先隐藏
            [self.eventInfoView hideInfoView];
            [self loginFirstWithBlock:^(id newToken) {
                [self addEventInfoViewWithModel:model];
                self.eventInfoView.trafficCountListener(eventID, tagID);
            }];
        }
    }];
    [self.eventInfoView setHideViewListener:^ {
        @strongify(self)
        // 取消选中currnetAnnotation
        [self.mapView deselectAnnotation:self.currnetAnnotation animated:YES];
    }];
    
    self.eventInfoView.model = model;
    [self.eventInfoView showInfoView];
}

// 解析出事件的位置，并画点画线
- (void) drawAllLocationCoordinate2D {
    // 清除地图上的点
    [self removeAllLocationCoordinate2D];
    
    if (!self.trafficModels || self.trafficModels.count == 0) {
        [self showTextHubWithContent:@"暂无事件信息"];
    } else {
        for (CarFriendTrafficModel *model in self.trafficModels) {
            // 解析lnglat而分离出经纬度的集合
            NSArray *lnglatArr = [model.lnglat componentsSeparatedByString:@","];// 取出经纬度
            CLLocationCoordinate2D coords[lnglatArr.count / 2];// 声明一个数组  用来存放画线的点
            NSMutableArray *locations = [[NSMutableArray alloc] init];
            double longitude = 0.0;
            for (int i = 0; i < lnglatArr.count; i++) {
                if (i % 2 == 0) {
                    longitude = [lnglatArr[i] doubleValue];
                } else {
                    double latitude = [lnglatArr[i] doubleValue];
                    coords[i / 2] = CLLocationCoordinate2DMake(latitude, longitude);
                    
                    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                    [locations addObject:location];
                }
            }
            
            [self drawPointWithCLLocationCoordinate2D:locations model:model];
            [self drawLineWithCLLocationCoordinate2D:coords count:lnglatArr.count / 2];
        }
    }
}

- (void) removeAllLocationCoordinate2D {
    if (self.annos) {
        [self.mapView removeAnnotations:self.annos];
        [self.annos removeAllObjects];
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
}

#pragma mark - 标示所有的事件

// 画点
- (void) drawPointWithCLLocationCoordinate2D:(NSMutableArray *)locations model:(CarFriendTrafficModel *)model {
    if (!self.annos) {
        self.annos = [[NSMutableArray alloc] init];
    }
    
    for (CLLocation *location in locations) {
        CarTrafficMAPointAnnotation *anno = [[CarTrafficMAPointAnnotation alloc] init];
        anno.coordinate = location.coordinate;
        anno.model = model;
        anno.imageName = [model imageName];
        [self.annos addObject:anno];
    }
    
    [self.mapView addAnnotations:self.annos];
}

// 划线
- (void) drawLineWithCLLocationCoordinate2D:(CLLocationCoordinate2D *)coords count:(NSUInteger)count {
    MAPolyline *lines = [MAPolyline polylineWithCoordinates:coords count:count];
    [self.mapView addOverlays:@[ lines ]];
}

#pragma mark - event response

- (void) dealEvent:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    switch (btn.tag) {
        case 0:// 路况
            self.mapView.showTraffic = !self.mapView.isShowTraffic;
            break;
        case 1:// 事件
            if (btn.selected) {
                [self removeAllLocationCoordinate2D];
            } else {
                [self drawAllLocationCoordinate2D];
            }
            break;
        case 2:{ // 随手拍
            CarFriendViewController *controller = [[CarFriendViewController alloc] init];
            controller.themeName = @"随手拍";
            [self basePushViewController:controller];
        }
            break;
        case 3: {// 高速路况
            HighRoadTrafficViewController *controller = [[HighRoadTrafficViewController alloc] init];
            [self basePushViewController:controller];
        }
            break;
        default:
            break;
    }
}

// 报路况
- (void) reportedRoadCondition {
    if (!self.loginModel.token) {// 先登录
        [self loginFirstWithBlock:^(id newToken) {
            [self reportedRoadCondition];
        }];
    } else {
        PublishInfoViewController *controller = [[PublishInfoViewController alloc] init];
        controller.publishInfoType = PublishInfoType_TRAFFIC;
        [self basePushViewController:controller];
    }
}

@end
