//
//  ParkingViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ParkingViewController.h"
#import "SearchParkingViewController.h"
#import "ParkingRecordViewController.h"
#import "ParkingMapViewController.h"
#import "ArrearageViewController.h"
#import "RechargeViewController.h"
#import "CTXWKWebViewController.h"
#import "ScanCodeViewController.h"
#import "GarageViewController.h"
#import "ParkingDialogView.h"
#import "OYCountDownManager.h"
#import <MAMapKit/MAMapKit.h>
#import "ParkingHomeModel.h"
#import "ServiceNetData.h"
#import "ParkingNetData.h"
#import "HomeLocalData.h"

@interface ParkingViewController ()

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, retain) ParkingHomeModel *model;

@property (nonatomic, retain) ParkingDialogView *parkingDialogView;

@property (nonatomic, retain) ParkingNetData *parkingNetData;

@end

@implementation ParkingViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.parkingView];
    [self.parkingView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _parkingNetData = [[ParkingNetData alloc] init];
    _parkingNetData.delegate = self;
    
    [self getAdvListById];
    [self locationManager];
    
    // 车辆更新的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPackinfoByCard) name:BindOrDeleteCarNotificationName object:nil];
    // 缴费成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPackinfoByCard) name:ParkingPaySuccessNotificationName object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 重新开启定时器
    for (int i = 0; i < self.model.carList.count; i++) {
        ParkingCarModel *model = self.model.carList[i];
        // 如果有车正在停车，则启动倒计时管理
        if (model.isbusy) {
            [kCountDownManager start];
        }
    }
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [kCountDownManager invalidate];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    // 获取轮播图
    if ([tag isEqualToString:@"getAdvListTag"]) {
        NSArray *advArray = [AdvertisementModel convertFromArray:(NSArray *) result];
        if (advArray) {
            self.parkingView.advArray = advArray;
        }
    }
    
    // 获取停车首页数据
    if ([tag isEqualToString:@"selectPackinfoByCardTag"]) {
        [self hideHub];
        
        self.model = [ParkingHomeModel convertFromDict:result];
        self.parkingView.model = self.model;
    }
    
    // 通知收费管理员收费
    if ([tag isEqualToString:@"pushToOperatorTag"]) {
        [self showTextHubWithContent:@"已通知收费管理员"];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    // 获取停车首页数据
    if ([tag isEqualToString:@"selectPackinfoByCardTag"]) {
        self.parkingView.model = nil;
    }
}

#pragma mark - network

// 获取轮播图
- (void) getAdvListById {
    ServiceNetData *serviceNetData = [[ServiceNetData alloc] init];
    serviceNetData.delegate = self;
    [serviceNetData getAdvListById:@"29" tag:@"getAdvListTag"];
}

// 获取停车首页数据
- (void)selectPackinfoByCard {
    [_parkingNetData selectPackinfoByCardWithToken:self.loginModel.token
                                            userId:self.loginModel.loginID
                                         longitude:self.coordinate.longitude
                                          latitude:self.coordinate.latitude
                                               tag:@"selectPackinfoByCardTag"];
}

#pragma mark - getter/setter

- (CParkingView *) parkingView {
    if (!_parkingView) {
        _parkingView = [[CParkingView alloc] initWithMyFrame:self.view.bounds];
        
        @weakify(self)
        
        // 去车库
        [_parkingView setToGarageViewListener:^ {
            @strongify(self)
            
            GarageViewController *controller = [[GarageViewController alloc] init];
            [self basePushViewController:controller];
        }];
        
        // 收费标准
        [_parkingView setShowParkingStandardListener:^ {
            @strongify(self)
            
            CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
            controller.name = @"停车收费标准";
            controller.url = @"http://ah122.cn/zhuanti/parking/pricefeetype/";
            [self basePushViewController:controller];
        }];
        
        // 当时整五分钟的时候，重新请求停车数据
        [_parkingView setSelectPackinfoByCardListener:^ {
            @strongify(self)
            
            [self selectPackinfoByCard];
        }];
        
        // 开启定时器
        [_parkingView setStartCountDownManagerListener:^ {
            [kCountDownManager start];
        }];
        
        // 停车记录
        [_parkingView setToParkingRecordViewListener:^(id result) {
            @strongify(self)
            
            ParkingRecordViewController *controller = [[ParkingRecordViewController alloc] init];
            if (result) {
                controller.isPay = @"";
            }
            [self basePushViewController:controller];
        }];
        
        // 搜索界面
        [_parkingView setToSearchParkingViewListener:^ {
            @strongify(self)
            
            SearchParkingViewController *controller = [[SearchParkingViewController alloc] init];
            controller.coordinate = self.coordinate;
            controller.cityName = self.cityName;
            [self basePushViewController:controller];
        }];
        
        // 充值
        [_parkingView setToRechargeViewListenern:^ {
            @strongify(self)
            
            RechargeViewController *controller = [[RechargeViewController alloc] initWithStoryboard];
            [self basePushViewController:controller];
        }];
        
        // 欠费补缴
        [_parkingView setToArrearageViewListener:^ {
            @strongify(self)
            
            ArrearageViewController *controller = [[ArrearageViewController alloc] initWithStoryboard];
            [self basePushViewController:controller];
        }];
        
        // 通知收费员
        [_parkingView setNoticeManagerListener:^(id result) {
            @strongify(self)
            
            [self showNoticeViewWithSiteID:result];
        }];
        
        [_parkingView setBackListener:^ {
            @strongify(self)
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        // 扫码支付
        [_parkingView setToScanCodeViewListener:^ {
            @strongify(self)
            
            ScanCodeViewController *controller = [[ScanCodeViewController alloc] initWithStoryboard];
            [self basePushViewController:controller];
        }];
        
        [_parkingView setToParkingMapViewListener:^ {
            @strongify(self)
            
            ParkingMapViewController *controller = [[ParkingMapViewController alloc] init];
            [self basePushViewController:controller];
        }];
        
        // 轮播图
        [_parkingView setToAdvertisementListener:^(id result) {
            @strongify(self)
            
            AdvertisementModel * model = (AdvertisementModel *)result;
            
            CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
            controller.name = model.name;
            controller.url = [model getActualURLWithToken:self.loginModel.token userID:self.loginModel.loginID];
            controller.desc = model.desc;
            [self basePushViewController:controller];
        }];
    }
    
    return _parkingView;
}

// 地区判断
- (void) showAddressView {
    if (![self.cityName containsString:@"蚌埠"]) {
        
        if (!self.parkingDialogView) {
            self.parkingDialogView = [[ParkingDialogView alloc] init];
            [self.parkingDialogView setTitle:@"提示" content:@"停车收费服务尚未在本区域开通，不支持在线支付等功能。（仅蚌埠部分地区）" btnTitle:@"确认"];
            [self.parkingDialogView setBtnListener:^ {
                // 确定了
            }];
        }
        
        [self.parkingDialogView showView];
    }
}

// 收费提醒
- (void) showNoticeViewWithSiteID:(NSString *)siteId {
    ParkingDialogView *dialog = [[ParkingDialogView alloc] init];
    [dialog setTitle:@"收费提醒" content:@"已通知收费管理员，若5分钟内管理员未来，可自行离开。" btnTitle:@"确认"];
    [dialog setBtnListener:^ {
        // 通知收费管理员收费
        [self.parkingNetData pushToOperatorWithToken:self.loginModel.token siteId:siteId tag:@"pushToOperatorTag"];
    }];
    
    [dialog showView];
}

#pragma mark - 定位

// 定位获取经纬度，然后获取首页数据
- (void) locationManager {
    if ([[AppDelegate sharedDelegate].aMapLocationModel isExistenceValue]) {
        [self request];
    } else {
        AMapLocationManager *manager = [[AMapLocationManager alloc] init];
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        [manager setDesiredAccuracy:kCLLocationAccuracyBest];
        // 定位超时时间，最低2s
        [manager setLocationTimeout:6];
        // 逆地理请求超时时间，最低2s
        [manager setReGeocodeTimeout:6];
        
        // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
        [manager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            if (error) {
                CTXLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
                
                // 定位失败,如果没有缓存，则保存默认值
                if (![[HomeLocalData sharedInstance] getAMapLocationModel]) {
                    // 默认值
                    AMapLocationModel *model = [AMapLocationModel defaultValue];
                    
                    [[HomeLocalData sharedInstance] saveAMapLocationModel:model];
                    [AppDelegate sharedDelegate].aMapLocationModel = model;
                } else {
                    [AppDelegate sharedDelegate].aMapLocationModel = [[HomeLocalData sharedInstance] getAMapLocationModel];
                }
            } else {
                //逆地理信息
                AMapLocationModel *model = [[AMapLocationModel alloc] init];
                model.province = regeocode.province;
                model.city = regeocode.city;
                model.district = regeocode.district;
                model.formattedAddress = regeocode.formattedAddress;
                model.latitude = location.coordinate.latitude;
                model.longitude = location.coordinate.longitude;
                
                [AppDelegate sharedDelegate].aMapLocationModel = model;
            }
            
            [self request];
        }];
    }
}

// 获取定位后，再做请求
- (void) request {
    self.cityName = [AppDelegate sharedDelegate].aMapLocationModel.city;
    double longitude = [AppDelegate sharedDelegate].aMapLocationModel.longitude;
    double latitude = [AppDelegate sharedDelegate].aMapLocationModel.latitude;
    self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    [self showHub];
    [self selectPackinfoByCard];
    
    [self showAddressView];
}

@end
