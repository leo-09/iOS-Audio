//
//  SearchAddressViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SearchAddressViewController.h"

@implementation SearchAddressViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"兴趣点搜索";
    
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(submitAddress)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:CTXTextFont] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.mapView) {
        [self initMapView];
        [self addItemView];
    }
    
    if (self.selectedAnnotation) {
        [self showMAPointAnnotations:@[ self.selectedAnnotation ]];
        self.mapView.centerCoordinate = self.selectedAnnotation.coordinate;
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 清空地图
    if (self.mapView) {
        [self.mapView removeFromSuperview];
        self.mapView.delegate = nil;
        self.mapView = nil;
    }
}

- (void) submitAddress {
    if (self.selectedAnnotation) {
        NSDictionary *userInfo = @{ @"selectedAnnotation": self.selectedAnnotation,
                                    @"resource": self.resource};
        [[NSNotificationCenter defaultCenter] postNotificationName:SearchAddressNotificationName object:nil userInfo:userInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showTextHubWithContent:@"请选择一个兴趣点"];
    }
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
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
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {
    [self.mapSearchView textFieldResignFirstResponder];
}

#pragma mark - private method

- (void) showMAPointAnnotations:(NSArray *)annos {
    // 清空所有的点
    [self.mapView removeAnnotations:_mapView.annotations];
    
    [self.mapView addAnnotations:annos];
    [self.mapView showAnnotations:annos animated:YES];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:NO];
}

- (void)initMapView {
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    
    self.mapView.delegate = self;
    self.mapView.showTraffic = NO;
    self.mapView.showsCompass = NO;
    self.mapView.rotateEnabled = NO;
    self.mapView.rotateCameraEnabled = NO;
    self.mapView.showsScale = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.zoomLevel = 13;
    
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
        } else {
            [self.mapSearchView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(40);
            }];
        }
    }];
    [_mapSearchView setSelectPointAnnotationListener:^(id result) {
        @strongify(self)
        self.selectedAnnotation = (NearByMAPointAnnotation *) result;
        [self showMAPointAnnotations:[NSMutableArray arrayWithObject:self.selectedAnnotation]];
        self.mapView.centerCoordinate = self.selectedAnnotation.coordinate;
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
}

@end
