//
//  ParkingMapViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingMapViewController.h"
#import "SearchParkingViewController.h"
#import "ParkingListViewController.h"
#import "ParkingInfoViewController.h"
#import "GPSNaviViewController.h"
#import "ParkingViewController.h"
#import "FilterAlertView.h"
#import "SelectView.h"
#import "ParkingSiteModel.h"
#import "FastDealInfoModel.h"
#import "ParkingNetData.h"

@interface ParkingMapViewController ()

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) NSMutableArray *parkAnnos;
@property (nonatomic, retain) ParkingSiteModel *model;

@end

@implementation ParkingMapViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initMapView];
    [self addItemView];
    
    _aMapSearchAPI = [[AMapSearchAPI alloc] init];
    _aMapSearchAPI.delegate = self;
    
    [self startUpdatingLocationWithBlock:^{
        self.cityName = [AppDelegate sharedDelegate].aMapLocationModel.city;
        double longitude = [AppDelegate sharedDelegate].aMapLocationModel.longitude;
        double latitude = [AppDelegate sharedDelegate].aMapLocationModel.latitude;
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        if (!self.siteModel) {// siteModel是从路边停车详情页带过来的，则直接显示
            // 查找合作的停车位(默认显示可支付的停车场)
            [self selectAllSiteList];
        }
    }];
    
    if (self.siteModel) {// siteModel是从路边停车详情页带过来的，则直接显示
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.siteModel.latitude, self.siteModel.longitude)];
        
        MAPointAnnotation *annotaiton = [[MAPointAnnotation alloc] init];
        annotaiton.coordinate = CLLocationCoordinate2DMake(self.siteModel.latitude, self.siteModel.longitude);
        annotaiton.title = @"-1";    // 标记第几个
        annotaiton.subtitle = @"parking";
        [self.mapView addAnnotation:annotaiton];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"selectAllSiteListTag"]) {
        self.model = [ParkingSiteModel convertFromDict:result];
        
        [self.mapView removeAnnotations:_mapView.annotations];// 清空所有的点
        [self addParkgingAnnotations];  // 描点
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
}

#pragma mark - netWork

// 查询所有路段信息
- (void)selectAllSiteList {
    [self showHub];
    
    ParkingNetData *parkingNetData = [[ParkingNetData alloc] init];
    parkingNetData.delegate = self;
    [parkingNetData selectAllSiteListWithSitename:@"" longitude:_coordinate.longitude latitude:_coordinate.latitude tag:@"selectAllSiteListTag"];
}

#pragma mark - 在地图上描点

// 描点
- (void) addParkgingAnnotations {
    if (!self.model) {  // model为空，需要请求数据
        [self selectAllSiteList];
        
        return;
    }
    
    NSMutableArray *annos = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.model.siteList.count; i++) {
        SiteModel *model = self.model.siteList[i];
        
        MAPointAnnotation *annotaiton = [[MAPointAnnotation alloc] init];
        annotaiton.coordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude);
        annotaiton.title = [NSString stringWithFormat:@"%d", i];    // 标记第几个
        annotaiton.subtitle = @"parking";
        [annos addObject:annotaiton];
    }
    
    [self.mapView addAnnotations:annos];
    [self.mapView showAnnotations:annos animated:YES];
    
    MAPointAnnotation *centerAnno = [[MAPointAnnotation alloc] init];
    centerAnno.coordinate = self.coordinate;
    centerAnno.subtitle = @"centerAnno";
    [self.mapView addAnnotation:centerAnno];
    
    // 设置当前点
//    [self.mapView setCenterCoordinate:self.coordinate animated:YES];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.model.averageLatitude, self.model.averageLongitude) animated:YES];
    self.mapView.zoomLevel = 16;
}

- (void) addAMapParkAnnotations {
    [self.mapView addAnnotations:self.parkAnnos];
    [self.mapView showAnnotations:self.parkAnnos animated:YES];
    
    self.mapView.zoomLevel = 13; 
}

- (void) configPOIAcTion {
    if (self.parkAnnos) {
        [self addAMapParkAnnotations];
        return;
    }
    
    [self showHub];
    
    if (!_keyPOISearRequst) {
        _keyPOISearRequst = [[AMapPOIKeywordsSearchRequest alloc] init];
    }
    
    _keyPOISearRequst.city = (self.cityName ? self.cityName : @"合肥");
    _keyPOISearRequst.keywords = @"停车场";
    _keyPOISearRequst.types = @"停车场";
    _keyPOISearRequst.offset = 50;
    //是否显示扩展信息
    _keyPOISearRequst.requireExtension = YES;
    //只检索本城市的poi数据
    _keyPOISearRequst.requireSubPOIs = YES;
    [_aMapSearchAPI AMapPOIKeywordsSearch:_keyPOISearRequst];
}

#pragma mark - Initialization

- (void)initMapView {
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [self.mapView setShowTraffic:YES];
    [self.mapView setDelegate:self];
    self.mapView.showsCompass = NO;
    [self.view addSubview:self.mapView];
    
    // 定位
    [self startUpdatingLocationWithBlock:^{
        CLLocationDegrees latitude = [AppDelegate sharedDelegate].aMapLocationModel.latitude;
        CLLocationDegrees longitude = [AppDelegate sharedDelegate].aMapLocationModel.longitude;
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(latitude, longitude) animated:YES];
    }];
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
    
    MAPinAnnotationView *annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
    
    annotationView.canShowCallout   = NO;//设置气泡可以弹出，默认为NO
    annotationView.animatesDrop     = NO;//设置标注动画显示，默认为NO
    annotationView.draggable        = NO;//设置标注可以拖动，默认为NO
    
    if ([annotationView.annotation.subtitle isEqualToString:@"centerAnno"]) {
        annotationView.image            = [UIImage imageNamed:@"icon_location"];
    } else if ([annotationView.annotation.subtitle isEqualToString:@"parking"]) {
        annotationView.image            = [UIImage imageNamed:@"icon_tcc"];
    } else {
        annotationView.image            = [UIImage imageNamed:@"icon_tccm"];
    }
    
    annotationView.imageView.contentMode = UIViewContentModeCenter;
    CGFloat wh = 40;
    annotationView.frame = CGRectMake((annotationView.frame.size.width-wh)/2, (annotationView.frame.size.height-wh)/2, wh, wh);
    
    return annotationView;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    MAPointAnnotation *currnetAnnotation = (MAPointAnnotation *)view.annotation;
    
    if ([currnetAnnotation.subtitle isEqualToString:@"centerAnno"]) {
        // 当前中心点
    } else if ([currnetAnnotation.subtitle isEqualToString:@"parking"]) {
        [self showParkDetailViewWithAnnotation:currnetAnnotation];
    } else {
        // 高德地图搜索的停车场
        FastDealInfoModel *model = [[FastDealInfoModel alloc] init];
        model.name = currnetAnnotation.title;
        model.addr = currnetAnnotation.subtitle;
        model.latitude = currnetAnnotation.coordinate.latitude;
        model.longitude = currnetAnnotation.coordinate.longitude;
        
        [self showMapPointAnnotationInfoViewWithModel:model];
    }
}

- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {
    if (_parkDetailView) {
        [_parkDetailView hide];
    }
    if (_annoInfoView) {
        [_annoInfoView hide];
    }
}

#pragma mark - AMapSearchDelegate

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    // 信息检索错误
    [self hideHub];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    [self hideHub];
    
    if (!self.parkAnnos) {
        self.parkAnnos = [[NSMutableArray alloc] init];
    }
    
    for (AMapPOI *aPOI in response.pois) {
        MAPointAnnotation *anno = [[MAPointAnnotation alloc] init];
        anno.coordinate = CLLocationCoordinate2DMake(aPOI.location.latitude, aPOI.location.longitude);
        anno.title = aPOI.name;
        anno.subtitle = aPOI.address;
        [self.parkAnnos addObject:anno];
    }
    
    [self addAMapParkAnnotations];
}

#pragma mark - event response

- (BOOL) gestureRecognizerShouldBegin {
    return NO;  // 关闭侧滑
}

// 清空地图
- (void) back {
    [self.mapView removeFromSuperview];
    self.mapView.delegate = nil;
    self.mapView = nil;
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ParkingViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void) parkingList {
    ParkingListViewController *controller = [[ParkingListViewController alloc] init];
    controller.coordinate = self.coordinate;
    controller.cityName = self.cityName;
    [self basePushViewController:controller];
}

// 路况
- (void) traffic:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {// 不显示路况
        [self.mapView setShowTraffic:NO];
    } else {
        [self.mapView setShowTraffic:YES];
    }
}

// 筛选
- (void) filter {
    FilterAlertView *alertView = [[FilterAlertView alloc] init];
    [alertView show];
    
    [alertView setFilterRoadListener:^{// 路边
        [self.mapView removeAnnotations:_mapView.annotations];// 清空所有的点
        [self addParkgingAnnotations];
    }];
    [alertView setFilterParkListener:^{// 停车场
        [self.mapView removeAnnotations:_mapView.annotations];// 清空所有的点
        [self addParkgingAnnotations];
    }];
    [alertView setFilterAllListener:^{// 全部
        [self.mapView removeAnnotations:_mapView.annotations];// 清空所有的点
        [self addParkgingAnnotations];
        [self configPOIAcTion];
    }];
}

// 可支付
- (void) payEnable:(UIButton *)btn {
    [self.mapView removeAnnotations:_mapView.annotations];// 清空所有的点
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [self addParkgingAnnotations];
    } else {
        [self configPOIAcTion];
    }
}

#pragma mark - 子View

- (void) addItemView {
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"iconfont_fh_blank"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backBtn];
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.left.equalTo(@0);
        make.top.equalTo(@24);
    }];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"icon_lb"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(parkingList) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.right.equalTo(@0);
        make.top.equalTo(@24);
    }];
    
    // 搜索框
    SelectView *view = [[SelectView alloc] init];
    CTXViewBorderRadius(view, 5.0, 0.8, UIColorFromRGB(CTXBLineViewColor));
    [view setClickListener:^(id sender) {
        SearchParkingViewController *controller = [[SearchParkingViewController alloc] init];
        controller.coordinate = self.coordinate;
        controller.cityName = self.cityName;
        [self basePushViewController:controller];
    }];
    [self.view addSubview:view];
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backBtn.right);
        make.right.equalTo(btn.left);
        make.top.equalTo(@24);
        make.height.equalTo(@40);
    }];
    
    UIImageView *searchIV = [[UIImageView alloc] init];
    searchIV.image = [UIImage imageNamed:@"icon_sous"];
    searchIV.contentMode = UIViewContentModeCenter;
    [view addSubview:searchIV];
    [searchIV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.left.equalTo(@0);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"请输入您要查询的地点";
    label.font = [UIFont systemFontOfSize:CTXTextFont];
    label.textColor = UIColorFromRGB(CTXBaseFontColor);
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIV.right).offset(@0);
        make.centerY.equalTo(view.centerY);
    }];
    
    UIButton *trafficBtn = [[UIButton alloc] init];
    [trafficBtn setImage:[UIImage imageNamed:@"icon_lkd"] forState:UIControlStateNormal];
    [trafficBtn setImage:[UIImage imageNamed:@"icon_lkw"] forState:UIControlStateSelected];
    [trafficBtn addTarget:self action:@selector(traffic:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:trafficBtn];
    [trafficBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.top.equalTo(view.bottom).offset(5);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    UIButton *filterBtn = [[UIButton alloc] init];
    [filterBtn setImage:[UIImage imageNamed:@"icon_djsx"] forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:filterBtn];
    [filterBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.top.equalTo(trafficBtn.bottom);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    UIButton *payBtn = [[UIButton alloc] init];
    [payBtn setImage:[UIImage imageNamed:@"icon_bkzf"] forState:UIControlStateNormal];
    [payBtn setImage:[UIImage imageNamed:@"icon_kzf"] forState:UIControlStateSelected];
    [payBtn addTarget:self action:@selector(payEnable:) forControlEvents:UIControlEventTouchDown];
    payBtn.selected = YES;
    [self.view addSubview:payBtn];
    [payBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.top.equalTo(filterBtn.bottom);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
}

- (void) showParkDetailViewWithAnnotation:(MAPointAnnotation *)anno {
    if (!_parkDetailView) {
        CGRect frame = CGRectMake(0, self.view.frame.size.height-170, CTXScreenWidth, 170);
        _parkDetailView = [[MapParkDetailView alloc] initWithMyFrame:frame];
        
        @weakify(self)
        [_parkDetailView setNaviListener:^{
            @strongify(self)
            // 导航
            CLLocationDegrees startLatitude = self.coordinate.latitude;
            CLLocationDegrees startLongitude = self.coordinate.longitude;
            
            CLLocationDegrees endLatitude = anno.coordinate.latitude;
            CLLocationDegrees endLongitude = anno.coordinate.longitude;
            
            GPSNaviViewController *controller = [[GPSNaviViewController alloc] init];
            controller.startPoint = [AMapNaviPoint locationWithLatitude:startLatitude longitude:startLongitude];
            controller.endPoint   = [AMapNaviPoint locationWithLatitude:endLatitude longitude:endLongitude];
            controller.strategy = AMapNaviDrivingStrategySingleDefault;
            [self basePushViewController:controller];
        }];
        [_parkDetailView setShowInfoListnener:^(id name, id siteID) {
            @strongify(self)
            
            ParkingInfoViewController * controller = [[ParkingInfoViewController alloc] init];
            controller.siteID = siteID;
            controller.siteName = name;
            controller.coordinate = self.coordinate;
            [self basePushViewController:controller];
        }];
        
        [self.view addSubview:_parkDetailView];
    }
    
    int index = [anno.title intValue];
    
    if (index == -1) {
        [_parkDetailView setParkInfo:self.siteModel];
    } else if (index < self.model.siteList.count) {
        [_parkDetailView setParkInfo:self.model.siteList[index]];
    }
    
    [_parkDetailView show];
    
    if (_annoInfoView) {
        [_annoInfoView hide];
    }
}

- (void) showMapPointAnnotationInfoViewWithModel:(FastDealInfoModel *)model {
    if (!_annoInfoView) {
        static CGFloat height = 195;// 40 + 30 + 10 + 30 + 10 + 20 + 15 + 40
        CGRect frame = CGRectMake(0, CTXScreenHeight - height, CTXScreenWidth, height);
        _annoInfoView = [[MapPointAnnotationInfoView alloc] initWithFrame:frame];
        
        @weakify(self)
        [_annoInfoView setHideListener:^{
            // 隐藏annoInfoView
        }];
        [_annoInfoView setCallPhoneListener:^(id result) {
            NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", result];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        [_annoInfoView setStartNaviListener:^(double endLatitude, double endLongitude) {
            @strongify(self)
            
            CLLocationDegrees startLatitude = self.coordinate.latitude;
            CLLocationDegrees startLongitude = self.coordinate.longitude;
            
            GPSNaviViewController *controller = [[GPSNaviViewController alloc] init];
            controller.startPoint = [AMapNaviPoint locationWithLatitude:startLatitude longitude:startLongitude];
            controller.endPoint   = [AMapNaviPoint locationWithLatitude:endLatitude longitude:endLongitude];
            controller.strategy = AMapNaviDrivingStrategySingleDefault;
            [self basePushViewController:controller];
        }];
        
        [self.view addSubview:_annoInfoView];
    }
    
    _annoInfoView.model = model;
    [_annoInfoView show];
    
    if (_parkDetailView) {
        [_parkDetailView hide];
    }
}

@end
