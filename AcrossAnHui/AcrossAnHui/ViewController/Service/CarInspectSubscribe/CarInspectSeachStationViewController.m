//
//  CarInspectSeachStationViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/7/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectSeachStationViewController.h"
#import "CarInspectStationInfoViewController.h"
#import "NewsInfoViewController.h"
#import "CarInspectNetData.h"
#import "CarInspectStationModel.h"
#import "StationSearchLocalData.h"

@interface CarInspectSeachStationViewController ()

@property (nonatomic, retain) CarInspectNetData *carInspectNetData;

@end

@implementation CarInspectSeachStationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _carInspectNetData = [[CarInspectNetData alloc] init];
    _carInspectNetData.delegate = self;
    
    [self.view addSubview:self.searchNewsInfoView];
    [self.searchNewsInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self queryRecord];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"stationName"]) {
        // 处理数据结果
        NSArray *models = [CarInspectStationModel convertFromArray:(NSArray *)result isCarInspectAgency:NO];
        if (!models || models.count < 1) {
            [self showTextHubWithContent:@"没有搜索结果"];
            [_searchNewsInfoView refreshDataSource:nil];
        } else {
            [_searchNewsInfoView refreshDataSource:models];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    
    if ([tag isEqualToString:@"stationName"]) {
        // 添加 空数据 到View中
        [_searchNewsInfoView setRecords:nil];
    }
}

#pragma mark - getter/setter

- (CJStationInfoView *) searchNewsInfoView {
    if (!_searchNewsInfoView) {
        _searchNewsInfoView = [[CJStationInfoView alloc] init];
        
        @weakify(self)
        
        [_searchNewsInfoView setBackListener:^{
            @strongify(self)
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [_searchNewsInfoView setSearchListener:^(id result) {
            @strongify(self)
            
            [self.carInspectNetData searchStationWithAreaId:@"" stationType:1 stationName:(NSString *)result tag:@"stationName"];
        }];
        
        [_searchNewsInfoView setClearRecordListener:^{
            @strongify(self)
            
            [self clearRecord];
        }];
        
        [_searchNewsInfoView setSelectStationCellListener:^(id result) {
            @strongify(self)
            
            // 保存记录
            [[StationSearchLocalData sharedInstance] addRecord: (CarInspectStationModel *)result];
            
            // 进入车检站详情
            CarInspectStationInfoViewController * controller = [[CarInspectStationInfoViewController alloc]init];
            controller.carModel = self.carModel;
            controller.stationModel = (CarInspectStationModel *)result;
            [self basePushViewController:controller];
        }];
    }
    
    return _searchNewsInfoView;
}

- (void) clearRecord {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                        message:@"确认清空历史搜索记录吗？"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[StationSearchLocalData sharedInstance] removeAllRecord];
        [self queryRecord];
    }];
    [controller addAction:cancelAction];
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

// 获取历史搜索记录
- (void) queryRecord {
    NSArray *records = (NSArray *)[[StationSearchLocalData sharedInstance] queryAllRecord];
    // 添加搜索记录
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!records || records.count < 1) {
            [_searchNewsInfoView setRecords:nil];
        } else {
            [_searchNewsInfoView setRecords:records];
        }
    });
}

@end
