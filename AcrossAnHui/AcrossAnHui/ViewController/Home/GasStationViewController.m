//
//  GasStationViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "GasStationViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "IllegalDisposalSiteInfoModel.h"
#import "NearByMAPointAnnotation.h"
#import "GPSNaviViewController.h"
#import "FastDealInfoModel.h"
#import "HomeLocalData.h"
#import "NearbyLocalData.h"
#import "ServeTool.h"

@implementation GasStationViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.titleName;
    
    //地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.mapView) {
        [self addMapView];
    }
    
    _aMapSearchAPI = [[AMapSearchAPI alloc] init];
    _aMapSearchAPI.delegate = self;
    
    _nearByNetData = [[NearByNetData alloc] init];
    _nearByNetData.delegate = self;
    
    [self showHub];
    
    [self startUpdatingLocationWithBlock:^{
        // 从首页的油价跳转过来的
        if (self.isShowGasStation) {
            NSString *city =  [AppDelegate sharedDelegate].aMapLocationModel.city;
            [self configPOIAcTionWithCity:city keyWords:@"加油站"];
        }
        
        // 展示违章处理点
        if (self.isShowIllegalDisposalSite) {
            NSString *city =  [AppDelegate sharedDelegate].aMapLocationModel.city;
            NSString *province =  [AppDelegate sharedDelegate].aMapLocationModel.province;
            [self.nearByNetData getAllIllegalDisposalSiteInfoWithCity:city province:province tag:@"getAllIllegalDisposalSiteInfoTag"];
        }
        
        if (self.isShowFastDeal) {
            NSString *city =  [AppDelegate sharedDelegate].aMapLocationModel.city;
            NSString *province =  [AppDelegate sharedDelegate].aMapLocationModel.province;
            [self.nearByNetData getAllFastDealInfoWithCity:city province:province tag:@"getAllFastDealInfoTag"];
        }
        
        if (self.isShowParking) {// 停车场
            NSString *city =  [AppDelegate sharedDelegate].aMapLocationModel.city;
            [self configPOIAcTionWithCity:city keyWords:@"停车场"];
        }
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _aMapSearchAPI.delegate = nil;
    _aMapSearchAPI = nil;
    
    _nearByNetData.delegate = nil;
    _nearByNetData = nil;
    
    // 清空地图
    [self.mapView removeFromSuperview];
    self.mapView.delegate = nil;
    self.mapView = nil;
    
    [_annoInfoView removeAllSubviews];
    [_annoInfoView removeFromSuperview];
    _annoInfoView = nil;
}

#pragma mark - MAMapViewDelegate

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

#pragma mark - AMapSearchDelegate

- (void)AMapSearchRequest:(AMapPOIKeywordsSearchRequest *)request didFailWithError:(NSError *)error {
    [self hideHub];
    
    // 信息检索错误，则先查询缓存的数据
    NSString * key = [NSString stringWithFormat:@"NearbyLocalData:%@-%@", request.city, request.keywords];
    NSMutableArray *result = [[NearbyLocalData sharedInstance] queryAnnotationsWithKey:key];
    
    if (result && result.count > 0) {
        // 缓存有数据，则直接显示
        [self showMAPointAnnotations:result];
    } else {
        // 缓存没数据，则提示
        [self showTextHubWithContent:@"信息检索错误"];
    }
}

- (void)onPOISearchDone:(AMapPOIKeywordsSearchRequest *)request response:(AMapPOISearchResponse *)response {
    [self hideHub];
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
}

#pragma mark - private method

- (void) showMAPointAnnotations:(NSMutableArray *)annos {
    [self.mapView addAnnotations:annos];
}

- (void) configPOIAcTionWithCity:(NSString *)city keyWords:keywords {
    if (!_keyPOISearRequst) {
        _keyPOISearRequst = [[AMapPOIKeywordsSearchRequest alloc] init];
    }
    
    _keyPOISearRequst.city = city;
    _keyPOISearRequst.keywords = keywords;
    _keyPOISearRequst.types = keywords;
    _keyPOISearRequst.offset = 50;
    // 是否显示扩展信息
    _keyPOISearRequst.requireExtension = YES;
    // 只检索本城市的poi数据
    _keyPOISearRequst.requireSubPOIs = YES;
    [_aMapSearchAPI AMapPOIKeywordsSearch:_keyPOISearRequst];
}

- (void)addMapView {
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    
    self.mapView.zoomLevel = 13;
    self.mapView.delegate = self;
    self.mapView.showTraffic = NO;
    self.mapView.showsCompass = NO;
    self.mapView.rotateEnabled = NO;
    self.mapView.rotateCameraEnabled = NO;
    self.mapView.showsScale = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void) showMapPointAnnotationInfoViewWithModel:(FastDealInfoModel *)model {
    if (!_annoInfoView) {
        static CGFloat height = 195;// 40 + 30 + 10 + 30 + 10 + 20 + 15 + 40
        CGRect frame = CGRectMake(0, self.view.frame.size.height - height, CTXScreenWidth, height);
        _annoInfoView = [[MapPointAnnotationInfoView alloc] initWithFrame:frame];
        
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
            [self basePushViewController:controller];
        }];
        
        [self.view addSubview:_annoInfoView];
    }
    
    _annoInfoView.model = model;
    [_annoInfoView show];
}

- (void) hideMapPointAnnotationInfoView {
    if (_annoInfoView) {
        [_annoInfoView hide];
    }
}

@end
