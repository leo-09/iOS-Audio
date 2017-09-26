//
//  CarInspectStationMapListViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectStationMapListViewController.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "CarInspectStationHeadView.h"
#import "CarInspectStationInfoViewController.h"
#import "CarStationAnnotationView.h"

@interface CarPointAnnotation : MAPointAnnotation

@property (nonatomic,assign)BOOL isSelect;

@end
@implementation CarPointAnnotation

@end

@interface CarInspectStationMapListViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic,strong)NSMutableArray *sumDicArray;
@property (nonatomic,strong)CarInspectStationHeadView *headerView;
@property (nonatomic,strong)CarPointAnnotation *myApointAnnotation;

@end

@implementation CarInspectStationMapListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initUI];
}

-(void)close:(id)sender{
    [super close:sender];
    [self.mapView removeFromSuperview];
    self.mapView.delegate = nil;
    self.mapView = nil;
}

- (void)initUI{
    self.title = @"车检站地图";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.mapView setShowsScale:NO];
    self.mapView.delegate  = self;
    
    [self.view addSubview:self.mapView];
    _headerView = [[CarInspectStationHeadView alloc]init] ;
    [self.view addSubview:_headerView];
    
     _headerView.stationList = self.stationListArray[0];
    
    if ([_headerView.stationList.isCanOnlinePay isEqualToString:@"1"]) {
        _headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 167);
    } else {
        _headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 110);
    }
    if (_value == 2) {
        UIButton * bu = [UIButton buttonWithType:UIButtonTypeCustom];
        bu.frame = CGRectMake(0, 64, self.view.frame.size.width, 110);
        [bu addTarget:self action:@selector(dianji) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:bu];
    }
    
    CLLocationCoordinate2D coordinates[self.stationListArray.count];
    self.annotations = [NSMutableArray array];
    for(int i = 0;i<self.stationListArray.count;i++){
        CarInspectStationModel * model = self.stationListArray[i];
        CarPointAnnotation *a1 = [[CarPointAnnotation alloc] init];
        coordinates[i].latitude = model.latitude ;
        coordinates[i].longitude = model.longitude;
        
        a1.coordinate = coordinates[i];
        a1.title = [self.stationListArray[i] stationName];
        if (i ==0) {
            a1.isSelect = YES;
        } else {
            a1.isSelect = NO;
        }
        [self.annotations addObject:a1];
    }
    
    [self.mapView addAnnotations:self.annotations];
    [self.mapView setZoomLevel:13];
    [self.mapView showAnnotations:self.annotations  edgePadding:(UIEdgeInsetsMake(20, 20, 20, 80)) animated:YES];
}

-(void)dianji{
    CarInspectStationInfoViewController *controller = [[CarInspectStationInfoViewController alloc]init];
    controller.stationModel = _headerView.stationList;
    [self basePushViewController:controller];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 地图标注事件

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    self.headerView.hidden = NO;
    CarStationAnnotationView *anonaTionView = (CarStationAnnotationView *)view;
    [self.mapView removeAnnotation:self.annotations[0]];
    if (self.myApointAnnotation ==nil) {
        self.myApointAnnotation = [[CarPointAnnotation alloc]init];
        self.myApointAnnotation.title = [self.stationListArray[0] stationName];
        CLLocationCoordinate2D coor ;
        CarInspectStationModel * model = self.stationListArray[0];
        coor.latitude = model.latitude;
        coor.longitude = model.longitude;
        self.myApointAnnotation.coordinate = coor;
        self.myApointAnnotation.isSelect = NO;
        [self.mapView addAnnotation:self.myApointAnnotation];
    }
    [self.mapView setCenterCoordinate:[anonaTionView.annotation coordinate]];
    anonaTionView.imageName = @"chejian_click.png";
    anonaTionView.selected = YES;
    for(int i =0;i<self.stationListArray.count ;i++){
        if ([[self.stationListArray[i] stationName]isEqualToString:[anonaTionView title]]) {
            self.headerView.stationList = self.stationListArray[i];
            
            if ([_headerView.stationList.isCanOnlinePay isEqualToString:@"1"]) {
                _headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 167);
                
            } else{
                _headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 110);
            }
            break;
        }
    }
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    CarStationAnnotationView *anonaTionView = (CarStationAnnotationView *)view;
    if (_value==1) {
        anonaTionView.imageName = @"chejian_6";
        anonaTionView.selected = NO;
        self.headerView.hidden = NO;
    }else{
        anonaTionView.imageName = @"chejian_6";
        anonaTionView.enabled = NO;
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    CarPointAnnotation *myAnnotation = (CarPointAnnotation *)annotation;
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CarStationAnnotationView *annotationView = (CarStationAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CarStationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view. annotationView.canShowCallout = NO;
            annotationView.draggable = NO;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        
        annotationView.title = [annotation title];
        //不显示默认的pop
        annotationView.canShowCallout = NO;
        if (annotationView.title == [self.annotations[0] title]) {
            if ([myAnnotation isSelect]) {
                
                if (_value==1) {
                } else {
                annotationView.enabled = NO;
                }
                annotationView.imageName = @"chejian_click";
                annotationView.title = [self.annotations[0] title];
                [self.mapView setCenterCoordinate:[annotationView.annotation coordinate]];
                [annotationView setSelected:YES];
            } else {
                annotationView.imageName = @"chejian_6";
                annotationView.title = [self.annotations[0] title];
                [annotationView setSelected:NO];
            }
        } else {
            annotationView.imageName = @"chejian_6";
        }
        return annotationView;
    }
    
    return nil;
}

- (BOOL) gestureRecognizerShouldBegin {
    return NO;  // 关闭侧滑
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
