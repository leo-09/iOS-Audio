//
//  ParkingInfoViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingInfoViewController.h"
#import "ParkingMapViewController.h"
#import "GPSNaviViewController.h"
#import "ParkingDetailView.h"
#import "SiteModel.h"
#import "SitefeeModel.h"
#import "ParkingNetData.h"

@interface ParkingInfoViewController ()

@property (nonatomic, retain) ParkingDetailView *parkDetailView;
@property (nonatomic, retain) SiteModel *siteModel;

@end

@implementation ParkingInfoViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.siteName;
    
    [self addParkDetailView];
    [self getSiteById];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getSiteByIdTag"]) {
        self.siteModel = [SiteModel convertFromDict:result[@"siteData"]];
        NSArray<SitefeeModel *> *sitefeeModels =  [SitefeeModel convertFromArray:result[@"sitefeelist"]];
        
        [_parkDetailView addSiteModel:self.siteModel sitefeeModels:sitefeeModels];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
}

#pragma mark - netWork

// 查询停车详情
- (void) getSiteById {
    [self showHub];
    
    ParkingNetData *parkingNetData = [[ParkingNetData alloc] init];
    parkingNetData.delegate = self;
    [parkingNetData getSiteByIdWithSiteID:self.siteID longitude:self.coordinate.longitude latitude:self.coordinate.latitude  tag:@"getSiteByIdTag"];
}

#pragma mark - getter/setter

- (void) addParkDetailView {
    _parkDetailView = [[ParkingDetailView alloc] init];
    [self.view addSubview:_parkDetailView];
    [_parkDetailView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    @weakify(self)
    [_parkDetailView setShowTrafficListener:^{
        @strongify(self)
        ParkingMapViewController *controller = [[ParkingMapViewController alloc] init];
        controller.siteModel = self.siteModel;
        [self basePushViewController:controller];
    }];
    
    // 导航
    [_parkDetailView setShowNavigationListener:^(double endLatitude, double endLongitude) {
        @strongify(self)
        
        CLLocationDegrees startLatitude = self.coordinate.latitude;
        CLLocationDegrees startLongitude = self.coordinate.longitude;
        
        GPSNaviViewController *controller = [[GPSNaviViewController alloc] init];
        controller.startPoint = [AMapNaviPoint locationWithLatitude:startLatitude longitude:startLongitude];
        controller.endPoint   = [AMapNaviPoint locationWithLatitude:endLatitude longitude:endLongitude];
        controller.strategy = AMapNaviDrivingStrategySingleDefault;
        [self basePushViewController:controller];
    }];
    
    [_parkDetailView setRefreshParkInfoListener:^(BOOL isRequestFailure) {
        @strongify(self)
        [self getSiteById];
    }];
}

@end
