//
//  GarageViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "GarageViewController.h"
#import "BindCarViewController.h"
#import "MineNetData.h"
#import "CGarageView.h"

@interface GarageViewController () {
    UIBarButtonItem *rightBarButtonItem;
}

@property (nonatomic, retain) MineNetData *mineNetData;

@property (nonatomic, retain) CGarageView *garageView;

@end

@implementation GarageViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的车库";
    // rightBarButtonItem
    rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editGarageCar)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:15.0f] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    [self.view addSubview:self.garageView];
    [self.garageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    self.mineNetData = [[MineNetData alloc] init];
    self.mineNetData.delegate = self;
    
    [self getBoundCarList];
    
    // 添加／删除车辆
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBoundCarList) name:BindOrDeleteCarNotificationName object:nil];
}

// 获取车辆最新数据
- (void) getBoundCarList {
    [self showHub];
    [self.mineNetData getBoundCarListWithToken:self.loginModel.token userId:self.loginModel.loginID tag:@"getBoundCarListTag"];
    [self.mineNetData selectCarParkServiceWithToken:self.loginModel.token
                                             userId:self.loginModel.loginID
                                                tag:@"selectCarParkServiceTag"];
}

// 编辑车辆
- (void) editGarageCar {
    if (!self.navigationItem.rightBarButtonItem) {
        return; // 没有车辆，则不到编辑状态
    }
    
    if ([rightBarButtonItem.title isEqualToString:@"编辑"]) {
        rightBarButtonItem.title = @"取消";
        
        [self.garageView showBottomView];
    } else {
        rightBarButtonItem.title = @"编辑";
        
        [self.garageView hideBottomView];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    // 获取车库的车辆
    if ([tag isEqualToString:@"getBoundCarListTag"]) {
        self.dataSource = [BoundCarModel convertFromArray:(NSArray *)result];
        [self compareDataSource];
        
        self.navigationItem.rightBarButtonItem = nil;
        if (self.dataSource && self.dataSource.count > 0) {
            rightBarButtonItem.title = @"编辑";
            self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        }
    }
    
    // 获取绑定了停车服务的车辆
    if ([tag isEqualToString:@"selectCarParkServiceTag"]) {
        self.parkingCars = [BoundCarModel convertFromArray:result[@"carParkList"]];
        [self compareDataSource];
    }
    
    // 设置停车车辆、解绑车辆、
    if ([tag isEqualToString:@"addCarParkServiceTag"] ||
        [tag isEqualToString:@"unbindCarTag"] ||
        [tag isEqualToString:@"deleteCarParkServiceTag"] ||
        [tag isEqualToString:@"setDefaultCarTag"]) {
        [self hideHub];
        
        // 再次刷新最新车辆数据
        [self getBoundCarList];
        
        // 发出 ‘删除、绑定、编辑车辆’通知
        [[NSNotificationCenter defaultCenter] postNotificationName:BindOrDeleteCarNotificationName object:nil userInfo:nil];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getBoundCarListTag"]) {
        [self showTextHubWithContent:tint];
        self.navigationItem.rightBarButtonItem = nil;
        [_garageView refreshDataSource:nil];
    }
    
    // 获取绑定了停车服务的车辆
    if ([tag isEqualToString:@"selectCarParkServiceTag"]) {
        [self showTextHubWithContent:tint];
    }
    
    // 设置停车车辆、解绑车辆、
    if ([tag isEqualToString:@"addCarParkServiceTag"] ||
        [tag isEqualToString:@"unbindCarTag"] ||
        [tag isEqualToString:@"setDefaultCarTag"]) {
        [self showTextHubWithContent:tint];
    }
}

#pragma mark - getter/setter

- (CGarageView *) garageView {
    if (!_garageView) {
        _garageView = [[CGarageView alloc] init];
        
        @weakify(self)
        
        [_garageView setRefreshCarDataListener:^(BOOL isRequestFailure) {
            @strongify(self)
            [self showHub];
            [self getBoundCarList];
        }];
        
        [_garageView setBindCarListener:^ {
            @strongify(self)
            
            BindCarViewController *controller = [[BindCarViewController alloc] initWithStoryboard];
            controller.naviTitle = @"绑定车辆";
            [self basePushViewController:controller];
        }];
        
        // 编辑
        [_garageView setBindOrDeleteCarListener:^ {
            @strongify(self)
            
            [self editGarageCar];
        }];
        
        [_garageView setEditCarListener:^(id result) {
           @strongify(self)
            
            BindCarViewController *controller = [[BindCarViewController alloc] initWithStoryboard];
            controller.naviTitle = @"编辑车辆";
            controller.carModel = (BoundCarModel *)result;
            [self basePushViewController:controller];
        }];
        
        [_garageView setDefaultCarListener:^(id result) {
            @strongify(self)
            [self showHubWithLoadText:@"正在设置默认车辆"];
            
            BoundCarModel *model = (BoundCarModel *)result;
            [self.mineNetData setDefaultCarWithToken:self.loginModel.token carID:model.carID tag:@"setDefaultCarTag"];
        }];
        
        [_garageView setDeleteCarListener:^(id result) {
            @strongify(self)
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"确认删除该车辆吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 选择的车辆
                NSArray *models = (NSArray *) result;
                
                NSMutableString *carID = [[NSMutableString alloc] init];
                NSMutableString *plateNumber = [[NSMutableString alloc] init];
                
                for (BoundCarModel *model in models) {
                    [carID appendString:[NSString stringWithFormat:@"%@,", (model.carID ? model.carID : @"")]];
                    [plateNumber appendString:[NSString stringWithFormat:@"%@,", (model.plateNumber ? model.plateNumber : @"")]];
                }
                
                [self showHubWithLoadText:@"正在删除该车辆"];
                
                // 删除停车服务的车
                [self.mineNetData deleteCarParkServiceWithToken:self.loginModel.token
                                                    plateNumber:[plateNumber substringToIndex:(plateNumber.length-1)]
                                                            tag:@"deleteCarParkServiceTag"];
                // 删除车库的车
                [self.mineNetData unbindCarWithToken:self.loginModel.token carID:carID tag:@"unbindCarTag"];
                
            }];
            [controller addAction:cancelAction];
            [controller addAction:okAction];
            
            [self presentViewController:controller animated:YES completion:nil];
        }];
        
        [_garageView setParkingCarListener:^(id result) {
            @strongify(self)
            [self showHubWithLoadText:@"正在设置停车车辆"];
            // 选择的车辆
            NSArray *models = (NSArray *) result;
            
            NSString *plateNumber;
            NSString *carname;
            NSString *imgurl;
            
            if (models.count > 0) {
                NSMutableString *plateNumbers = [[NSMutableString alloc] init];
                NSMutableString *carnames = [[NSMutableString alloc] init];
                NSMutableString *imgurls = [[NSMutableString alloc] init];
                
                for (BoundCarModel *model in models) {
                    
                    NSString *name = model.name;
                    if (!model.name || [model.name isEqualToString:@""]) {
                        name = @"";// 为空的时候，必须留个空格
                    }
                    
                    NSString *carImgPath = model.carImgPath;
                    if (!model.carImgPath || [model.carImgPath isEqualToString:@""]) {
                        carImgPath = @"";// 为空的时候，必须留个空格
                    }
                    
                    [plateNumbers appendString:[NSString stringWithFormat:@"%@,", (model.plateNumber ? model.plateNumber : @"")]];
                    [carnames appendString:[NSString stringWithFormat:@"%@,", name]];
                    [imgurls appendString:[NSString stringWithFormat:@"%@,", carImgPath]];
                }
                
                plateNumber = [plateNumbers substringToIndex:(plateNumbers.length-1)];
                carname = [carnames substringToIndex:(carnames.length-1)];
                imgurl = [imgurls substringToIndex:(imgurls.length-1)];
            }
            
            [self.mineNetData addCarParkServiceWithToken:self.loginModel.token
                                             plateNumber:plateNumber
                                                 carname:carname
                                                  imgurl:imgurl
                                                     tag:@"addCarParkServiceTag"];
            
        }];
    }
    
    return _garageView;
}

#pragma mark - private method

// 比较两个车库的数据，并合并
- (void) compareDataSource {
    // 车库有车了，才比较并更新页面
    if (self.dataSource) {
        
        // 停车有车了，才比较
        if (self.parkingCars) {
            [self hideHub];
            
            for (BoundCarModel *garageCar in self.dataSource) {
                garageCar.isShowSelect = NO;
                
                for (BoundCarModel *parkingCar in self.parkingCars) {    
                    // 车架号相同，则就是一辆车
                    if ([garageCar.plateNumber isEqualToString:parkingCar.plateNumber]) {
                        garageCar.isParkingCar = YES;
                        garageCar.isSelected = YES;
                        
                        break;
                    }
                }
            }
        }
        
        [_garageView refreshDataSource:self.dataSource];
    }
}

@end
