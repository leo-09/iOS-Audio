//
//  DriverPostionViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "DriverPostionViewController.h"
#import "CarInspectRecordNetData.h"
#import "CarInspectAgencyDriverPostionModel.h"

@interface DriverPostionViewController()

@property (nonatomic, retain) CarInspectRecordNetData *carInspectRecordNetData;

@end

@implementation DriverPostionViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"司机位置";
    
    //地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    // 显示地图
    [self addMapView];
    
    _carInspectRecordNetData = [[CarInspectRecordNetData alloc] init];
    _carInspectRecordNetData.delegate = self;
    
    [self showHub];
    [_carInspectRecordNetData getDriverPositionWithOrderID:self.orderid tag:@"getDriverPositionTag"];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
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
    
    //如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getDriverPositionTag"]) {
        NSDictionary *data = [result objectForKey:@"data"];
        CarInspectAgencyDriverPostionModel *model = [CarInspectAgencyDriverPostionModel convertFromDict:data];
        
        // 删除所有的点和线
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView removeOverlays:self.mapView.overlays];
        
        [self drawAllLocationCoordinate2DWithModel:model];
        [self drawPointWithModel:model];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getDriverPositionTag"]) {
        [self showTextHubWithContent:tint];
    }
}

// 画当前位置、画起始点
- (void) drawPointWithModel:(CarInspectAgencyDriverPostionModel *) model {
//    NSMutableArray *annos = [[NSMutableArray alloc] init];
//    
//    PositionModel *acceptPos = model.orderStatesInfo.acceptPos;     // 接单位置
//    MAPointAnnotation *acceptPosAnno = [[MAPointAnnotation alloc] init];
//    acceptPosAnno.coordinate = CLLocationCoordinate2DMake(acceptPos.lat, acceptPos.lng);
//    acceptPosAnno.title = @"开始位置";
//    acceptPosAnno.subtitle = @"position_starting-point";
//    [annos addObject:acceptPosAnno];
//    
//    PositionModel *finishPos = model.orderStatesInfo.finishPos;     // 完成位置
//    MAPointAnnotation *finishPosAnno = [[MAPointAnnotation alloc] init];
//    finishPosAnno.coordinate = CLLocationCoordinate2DMake(finishPos.lat, finishPos.lng);
//    finishPosAnno.title = @"完成位置";
//    finishPosAnno.subtitle = @"position_end";
//    [annos addObject:finishPosAnno];
//    
//    PositionModel *currentPos = model.orderStatesInfo.currentPos;   // 当前位置
//    MAPointAnnotation *currentPosAnno = [[MAPointAnnotation alloc] init];
//    currentPosAnno.coordinate = CLLocationCoordinate2DMake(currentPos.lat, currentPos.lng);
//    currentPosAnno.title = @"当前位置";
//    currentPosAnno.subtitle = @"position_car";
//    [annos addObject:currentPosAnno];
//    
//    [self.mapView addAnnotations:annos];
//    [self.mapView showAnnotations:annos animated:YES];
}

#pragma mark - MAMapViewDelegate

// 根据overlay生成对应的Renderer
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[ MAPolyline class]]) {
        MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.lineWidth = 3.0;
        renderer.lineDash = NO;
        renderer.strokeColor = UIColorFromRGB(CTXThemeColor);
        
        return renderer;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        MAPointAnnotation *anno = (MAPointAnnotation *) annotation;
        
        static NSString *pointReuseIndetifier = @"CarTrafficIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout = NO;
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;
        annotationView.image = [UIImage imageNamed:anno.subtitle];
        
        return annotationView;
    }
    
    return nil;
}

// 解析出事件的位置，并画点画线
- (void) drawAllLocationCoordinate2DWithModel:(CarInspectAgencyDriverPostionModel *)model  {
    if (!model.arrive || model.arrive.count == 0) {
        [self showTextHubWithContent:@"暂无司机位置信息"];
        return;
    }
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    if (model.arrive && model.arrive.count > 0) {
        [mutableArray addObjectsFromArray:model.arrive];
    }
    if (model.await && model.await.count > 0) {
        [mutableArray addObjectsFromArray:model.await];
    }
    if (model.drive && model.drive.count > 0) {
        [mutableArray addObjectsFromArray:model.drive];
    }
    
    CLLocationCoordinate2D coords[mutableArray.count];// 声明一个数组  用来存放画线的点
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    
    // 接单到就位间的坐标点集合
    for (int i = 0; i < mutableArray.count; i++) {
        PositionModel *posi = mutableArray[i];
        
        coords[i] = CLLocationCoordinate2DMake(posi.lat, posi.lng);
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coords[i].latitude longitude:coords[i].longitude];
        [locations addObject:location];
    }
    
    [self drawPointWithCLLocationCoordinate2D:locations];
    [self drawLineWithCLLocationCoordinate2D:coords count:mutableArray.count];
    
    // 画当前点
    NSMutableArray *annos = [[NSMutableArray alloc] init];
    MAPointAnnotation *currentPosAnno = [[MAPointAnnotation alloc] init];
    currentPosAnno.coordinate = coords[mutableArray.count - 1];
    currentPosAnno.title = @"当前位置";
    currentPosAnno.subtitle = @"position_car";
    [annos addObject:currentPosAnno];
    
    [self.mapView addAnnotations:annos];
    [self.mapView showAnnotations:annos animated:YES];
}

#pragma mark - 标示所有的事件

// 画点
- (void) drawPointWithCLLocationCoordinate2D:(NSMutableArray *)locations {
    NSMutableArray *annos = [[NSMutableArray alloc] init];
    
    for (CLLocation *location in locations) {
        MAPointAnnotation *anno = [[MAPointAnnotation alloc] init];
        anno.coordinate = location.coordinate;
        [annos addObject:anno];
    }
    
    [self.mapView addAnnotations:annos];
    [self.mapView showAnnotations:annos animated:YES];
    self.mapView.zoomLevel = 13;
}

// 划线
- (void) drawLineWithCLLocationCoordinate2D:(CLLocationCoordinate2D *)coords count:(NSUInteger)count {
    MAPolyline *lines = [MAPolyline polylineWithCoordinates:coords count:count];
    [self.mapView addOverlays:@[ lines ]];
}

@end
