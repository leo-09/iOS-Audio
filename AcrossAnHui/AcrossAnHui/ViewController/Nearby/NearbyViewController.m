//
//  NearbyViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "NearbyViewController.h"
#import "PublishInfoViewController.h"
#import "HomeLocalData.h"
#import "FastDealInfoModel.h"
#import "IllegalDisposalSiteInfoModel.h"
#import "NearByMAPointAnnotation.h"
#import "GPSNaviViewController.h"
#import "NearbyLocalData.h"
#import "ServeTool.h"

@implementation NearbyViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _aMapSearchAPI = [[AMapSearchAPI alloc] init];
    _aMapSearchAPI.delegate = self;
    
    _nearByNetData = [[NearByNetData alloc] init];
    _nearByNetData.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.mapView) {
        [self addMapView];
        [self addItemView];
    }
    
    [self.parentViewController.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.parentViewController.navigationController setNavigationBarHidden:NO animated:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[NearByMAPointAnnotation class]]) {
        MAPinAnnotationView *annotationView;
        NearByMAPointAnnotation *anno = (NearByMAPointAnnotation *) annotation;
        
        if ([anno.tag isEqualToString:@"快处中心"]) {
            static NSString *pointReuseIndetifier = @"FastDealInfoIndetifier";
            annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil) {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
            annotationView.image = [UIImage imageNamed:@"kuaichu"];
            annotationView.canShowCallout = NO;
        } else if ([anno.tag isEqualToString:@"违章处理"]) {
            static NSString *pointReuseIndetifier = @"IllegalDisposalSiteInfoIndetifier";
            annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil) {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
            annotationView.image = [UIImage imageNamed:@"near_weizhang"];
            annotationView.canShowCallout = NO;
        } else if ([anno.tag isEqualToString:@"停车场"]) {
            static NSString *pointReuseIndetifier = @"parkIndetifier";
            annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil) {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
            annotationView.image = [UIImage imageNamed:@"tingche"];
            annotationView.canShowCallout = NO;
        } else if ([anno.tag isEqualToString:@"加油站"]) {
            static NSString *pointReuseIndetifier = @"gasStationIndetifier";
            annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil) {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
            annotationView.image = [UIImage imageNamed:@"jiayouzhan_selected"];
            annotationView.canShowCallout = NO;
        } else if ([anno.tag isEqualToString:@"MapSearchView"]) {
            static NSString *pointReuseIndetifier = @"MapSearchViewIndetifier";
            annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil) {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
            annotationView.image = [UIImage imageNamed:@"dingwei"];
            annotationView.canShowCallout = NO;
        }
        
        annotationView.imageView.contentMode = UIViewContentModeCenter;
        CGFloat wh = 40;
        annotationView.frame = CGRectMake((annotationView.frame.size.width-wh)/2, (annotationView.frame.size.height-wh)/2, wh, wh);
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    // NearByMAPointAnnotation类型
    if ([view.annotation isKindOfClass:[NearByMAPointAnnotation class]]) {
        // 移动中心点
        _mapView.centerCoordinate = view.annotation.coordinate;
        _currnetAnnotation = (NearByMAPointAnnotation *)view.annotation;
        if ([_currnetAnnotation.tag isEqualToString:@"快处中心"]) {
            view.image = [UIImage imageNamed:@"kuaichu_click"];
        } else if ([_currnetAnnotation.tag isEqualToString:@"违章处理"]) {
            view.image = [UIImage imageNamed:@"weizhang_click"];
        } else if ([_currnetAnnotation.tag isEqualToString:@"停车场"]) {
            view.image = [UIImage imageNamed:@"tingche_click"];
        } else if ([_currnetAnnotation.tag isEqualToString:@"加油站"]) {
            view.image = [UIImage imageNamed:@"jiayouzhan_click"];
        } else if ([_currnetAnnotation.tag isEqualToString:@"MapSearchView"]) {
            // 搜索的MAPointAnnotation
        }
        
        FastDealInfoModel *model = [[FastDealInfoModel alloc] init];
        model.name = _currnetAnnotation.title;
        model.addr = _currnetAnnotation.subtitle;
        model.tel = _currnetAnnotation.phone;
        model.latitude = _currnetAnnotation.coordinate.latitude;
        model.longitude = _currnetAnnotation.coordinate.longitude;
        
        // 弹出详情View
        [self showMapPointAnnotationInfoViewWithModel:model];
    }
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    // NearByMAPointAnnotation类型
    if ([view.annotation isKindOfClass:[NearByMAPointAnnotation class]]) {
        NearByMAPointAnnotation *anno = (NearByMAPointAnnotation *)view.annotation;
        if ([anno.tag isEqualToString:@"快处中心"]) {
            view.image = [UIImage imageNamed:@"kuaichu"];
        } else if ([anno.tag isEqualToString:@"违章处理"]) {
            view.image = [UIImage imageNamed:@"near_weizhang"];
        } else if ([anno.tag isEqualToString:@"停车场"]) {
            view.image = [UIImage imageNamed:@"tingche"];
        } else if ([anno.tag isEqualToString:@"加油站"]) {
            view.image = [UIImage imageNamed:@"jiayouzhan_selected"];
        }
        
        [self hideMapPointAnnotationInfoView];
    }
}

- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {
    [self.mapSearchView textFieldResignFirstResponder];
}

#pragma mark - AMapSearchDelegate

- (void)AMapSearchRequest:(AMapPOIKeywordsSearchRequest *)request didFailWithError:(NSError *)error {
    [self hideHub];
    [self.mapSearchView textFieldResignFirstResponder];
    
    // 信息检索错误，则先查询缓存的数据
    NSString * key = [NSString stringWithFormat:@"NearbyLocalData:%@-%@", request.city, request.keywords];
    NSMutableArray *result = [[NearbyLocalData sharedInstance] queryAnnotationsWithKey:key];
    
    if (result && result.count > 0) {
        // 缓存有数据，则直接显示
        [self showMAPointAnnotations:result];
    } else {
        // 缓存没数据，则提示
        [self showTextHubWithContent:@"信息检索错误"];
        [self removeAnnotations];
        [self.mapOperationView deSelectedCurrentBtn];
    }
}

- (void)onPOISearchDone:(AMapPOIKeywordsSearchRequest *)request response:(AMapPOISearchResponse *)response {
    [self hideHub];
    [self.mapSearchView textFieldResignFirstResponder];
    _mapView.showsUserLocation = YES;
    
    NSMutableArray *annos = [[NSMutableArray alloc] init];
    for (AMapPOI *aPOI in response.pois) {
        NearByMAPointAnnotation *anno = [[NearByMAPointAnnotation alloc] init];
        anno.coordinate = CLLocationCoordinate2DMake(aPOI.location.latitude, aPOI.location.longitude);
        anno.title = aPOI.name;
        anno.subtitle = aPOI.address;
        anno.tag = request.types;
        [annos addObject:anno];
    }
    [self showMAPointAnnotations:annos];
    
    // 保存搜索到的结果
    NSString * key = [NSString stringWithFormat:@"NearbyLocalData:%@-%@", request.city, request.keywords];
    [[NearbyLocalData sharedInstance] coverAnnotations:annos key:key];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getAllFastDealInfoTag"]) {
        NSArray *fastDealInfos = [FastDealInfoModel convertFromArray:result];
        
        NSMutableArray *annos = [[NSMutableArray alloc] init];
        for (FastDealInfoModel *fastModel in fastDealInfos) {
            NearByMAPointAnnotation *anno = [[NearByMAPointAnnotation alloc] init];
            anno.coordinate = CLLocationCoordinate2DMake(fastModel.latitude, fastModel.longitude);
            anno.title = fastModel.name;
            anno.subtitle = fastModel.addr;
            anno.phone = fastModel.tel;
            anno.tag = @"快处中心";
            [annos addObject:anno];
        }
        [self showMAPointAnnotations:annos];
    }

    if ([tag isEqualToString:@"getAllIllegalDisposalSiteInfoTag"]) {
        NSArray *illegals = [IllegalDisposalSiteInfoModel convertFromArray:result];
        
        NSMutableArray *annos = [[NSMutableArray alloc] init];
        for (FastDealInfoModel *illegalModel in illegals) {
            NearByMAPointAnnotation *anno = [[NearByMAPointAnnotation alloc] init];
            anno.coordinate = CLLocationCoordinate2DMake(illegalModel.latitude, illegalModel.longitude);
            anno.title = illegalModel.name;
            anno.subtitle = illegalModel.addr;
            anno.phone = illegalModel.tel;
            anno.tag = @"违章处理";
            [annos addObject:anno];
        }
        [self showMAPointAnnotations:annos];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    [self removeAnnotations];
    [self.mapOperationView deSelectedCurrentBtn];
}

#pragma mark - private method

- (void) showMAPointAnnotations:(NSMutableArray *)annos {
    [self removeAnnotations];
    
    [self.annos addObjectsFromArray:annos];
    [self.mapView addAnnotations:self.annos];
}

- (void) removeAnnotations {
    if (self.annos) {
        [self.mapView removeAnnotations:self.annos];// 清空所有的点
        [self.annos removeAllObjects];
    } else {
        self.annos = [[NSMutableArray alloc] init];
    }
}

- (void) configPOIAcTionWithCity:(NSString *)city keyWords:keywords {
    if (!_keyPOISearRequst) {
        _keyPOISearRequst = [[AMapPOIKeywordsSearchRequest alloc] init];
    }
    _keyPOISearRequst.city = city;
    _keyPOISearRequst.keywords = keywords;
    _keyPOISearRequst.types = keywords;
    _keyPOISearRequst.offset = 50;
    //是否显示扩展信息
    _keyPOISearRequst.requireExtension = YES;
    //只检索本城市的poi数据
    _keyPOISearRequst.requireSubPOIs = YES;
    [_aMapSearchAPI AMapPOIKeywordsSearch:_keyPOISearRequst];
}

- (void)addMapView {
    CGRect frame = CGRectMake(0, 0, CTXScreenWidth, CTXScreenHeight - CTXTabBarHeight);
    self.mapView = [[MAMapView alloc] initWithFrame:frame];
    [self.view addSubview:self.mapView];
    
    self.mapView.zoomLevel = 13;// 缩放尺寸
    self.mapView.delegate = self;
    self.mapView.showTraffic = NO;
    self.mapView.showsCompass = NO;
    self.mapView.rotateEnabled = NO;
    self.mapView.rotateCameraEnabled = NO;
    self.mapView.showsScale = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    // 定位
    [self startUpdatingLocationWithBlock:^{
        CLLocationDegrees latitude = [AppDelegate sharedDelegate].aMapLocationModel.latitude;
        CLLocationDegrees longitude = [AppDelegate sharedDelegate].aMapLocationModel.longitude;
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }];
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
            self.mapOperationView.hidden = YES;
        } else {
            [self.mapSearchView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(40);
            }];
            self.mapOperationView.hidden = NO;
        }
    }];
    [_mapSearchView setSelectPointAnnotationListener:^(id result) {
        @strongify(self)
        
        // 如果之前有搜索的点，则删除原来的点
        if (self.searchAnno) {
            [self.mapView removeAnnotation:self.searchAnno];
        }
        
        self.searchAnno = (MAPointAnnotation *) result;
        
        // 删除原来的点，并显示搜索的点
        [self removeAnnotations];
        [self.mapView addAnnotation:self.searchAnno];
        
        // 设置搜索的点为地图地图中心点
        self.mapView.centerCoordinate = self.searchAnno.coordinate;
        
        // 关闭 快处中心、停车场、加油站、违章处理 的选中状态
        [self.mapOperationView deSelectedCurrentBtn];
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
        make.top.equalTo(@40);
        make.height.equalTo(40);
    }];
    
    // MapOperationView
    _mapOperationView = [[MapOperationView alloc] init];
    NSArray *normalImages = @[ @"kuaichuzhongxin", @"tingchechang", @"near_jiayou", @"weizhangchuli" ];
    NSArray *selectedImages = @[ @"kuaichuzhongxin_click", @"tingchechang_click", @"near_jiayou_click", @"weizhangchuli_click" ];
    [_mapOperationView setNormalImages:normalImages selectedImages:selectedImages];
    // 点击事件
    [_mapOperationView setClickButtonListener:^(int index) {
        @strongify(self)
        [self showHub];
        
        [self startUpdatingLocationWithBlock:^{
            if (index == 0) {// 快处中心
                NSString *city =  [AppDelegate sharedDelegate].aMapLocationModel.city;
                NSString *province =  [AppDelegate sharedDelegate].aMapLocationModel.province;
                [self.nearByNetData getAllFastDealInfoWithCity:city province:province tag:@"getAllFastDealInfoTag"];
            } else if (index == 1) {// 停车场
                NSString *city =  [AppDelegate sharedDelegate].aMapLocationModel.city;
                [self configPOIAcTionWithCity:city keyWords:@"停车场"];
            } else if (index == 2) {// 加油站
                NSString *city =  [AppDelegate sharedDelegate].aMapLocationModel.city;
                [self configPOIAcTionWithCity:city keyWords:@"加油站"];
            } else {// 违章处理
                NSString *city =  [AppDelegate sharedDelegate].aMapLocationModel.city;
                NSString *province =  [AppDelegate sharedDelegate].aMapLocationModel.province;
                [self.nearByNetData getAllIllegalDisposalSiteInfoWithCity:city province:province tag:@"getAllIllegalDisposalSiteInfoTag"];
            }
        }];
    }];
    // 添加MapOperationView
    [self.view addSubview:_mapOperationView];
    [_mapOperationView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@80);
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
        make.top.equalTo(CTXScreenHeight - CTXTabBarHeight - 40 - 20);
        make.height.equalTo(40);
    }];
}

- (void) showMapPointAnnotationInfoViewWithModel:(FastDealInfoModel *)model {
    if (_annoInfoView) {
        [_annoInfoView removeFromSuperview];
        [_annoInfoView removeAllSubviews];
        _annoInfoView = nil;
    }
    
    static CGFloat height = 195;// 40 + 30 + 10 + 30 + 10 + 20 + 15 + 40
    CGRect frame = CGRectMake(0, CTXScreenHeight-CTXTabBarHeight-height, CTXScreenWidth, height);
    _annoInfoView = [[MapPointAnnotationInfoView alloc] initWithFrame:frame];
    [self.view addSubview:_annoInfoView];
    
    @weakify(self)
    [_annoInfoView setHideListener:^{
        @strongify(self)
        
        [self.mapView deselectAnnotation:self.currnetAnnotation animated:YES];
    }];
    [_annoInfoView setCallPhoneListener:^(id result) {
        [ServeTool callPhone:result];
    }];
    [_annoInfoView setStartNaviListener:^(double latitude, double longitude) {
        @strongify(self)
        
        GPSNaviViewController *controller = [[GPSNaviViewController alloc] init];
        CLLocationDegrees startLatitude = [AppDelegate sharedDelegate].aMapLocationModel.latitude;
        CLLocationDegrees startLongitude = [AppDelegate sharedDelegate].aMapLocationModel.longitude;
        controller.startPoint = [AMapNaviPoint locationWithLatitude:startLatitude longitude:startLongitude];
        controller.endPoint   = [AMapNaviPoint locationWithLatitude:latitude longitude:longitude];
        controller.strategy = AMapNaviDrivingStrategySingleDefault;
        [self basePushViewController:controller];
    }];
    
    _annoInfoView.model = model;
    [_annoInfoView show];
}

- (void) hideMapPointAnnotationInfoView {
    if (_annoInfoView) {
        [_annoInfoView hide];
    }
}

#pragma mark - event response

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
