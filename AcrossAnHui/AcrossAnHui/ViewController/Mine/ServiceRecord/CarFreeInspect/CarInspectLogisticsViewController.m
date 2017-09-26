//
//  CarInspectLogisticsViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectLogisticsViewController.h"
#import "CCarInspectLogisticsView.h"
#import "CarInspectRecordNetData.h"
#import "CarInspectLogisticsInfo.h"
#import "CarInspectLogistics.h"

@interface CarInspectLogisticsViewController()

@property (nonatomic, assign) int type;     // 0表示寄往车检站  1表示寄往用户

@property (nonatomic, retain) CarInspectRecordNetData *carInspectRecordNetData;
@property (nonatomic, retain) CCarInspectLogisticsView *carInspectLogisticsView;
@end

@implementation CarInspectLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"物流信息";
    
    [self.view addSubview:self.carInspectLogisticsView];
    [self.carInspectLogisticsView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _carInspectRecordNetData = [[CarInspectRecordNetData alloc] init];
    _carInspectRecordNetData.delegate = self;
    
    self.type = 0;  // 寄往车检站
    [self querySFBno];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"querySFBnoTag"]) {
        [_carInspectLogisticsView endRefreshing];
        
        NSDictionary *dict = (NSDictionary *) result;
        
        CarInspectLogisticsInfo *info = [CarInspectLogisticsInfo convertFromDict:dict[@"info"]];
        NSMutableArray *models = [CarInspectLogistics convertFromArray:dict[@"data"]];
        
        [_carInspectLogisticsView setCarInspectLogisticsInfo:info];
        [_carInspectLogisticsView refreshDataSource:models];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"querySFBnoTag"]) {
        [_carInspectLogisticsView endRefreshing];
        
        [_carInspectLogisticsView setCarInspectLogisticsInfo:nil];
        [_carInspectLogisticsView refreshDataSource:nil];
    }
}

#pragma mark - getter/setter

- (CCarInspectLogisticsView *) carInspectLogisticsView {
    if (!_carInspectLogisticsView) {
        _carInspectLogisticsView = [[CCarInspectLogisticsView alloc] init];
        
        @weakify(self)
        
        [_carInspectLogisticsView setRefreshDataListener:^(BOOL isRequestFailure) {
            @strongify(self)
            
            if (isRequestFailure) {
                [self showHub];
            }
            
            [self querySFBno];
        }];
        
        [_carInspectLogisticsView setLogisticsListener:^(int index) {
            @strongify(self)
            
            self.type = index;
            [self querySFBno];
        }];
    }
    
    return _carInspectLogisticsView;
}

- (void) querySFBno {
    [self showHub];
    [_carInspectRecordNetData querySFBnoWithBusinessID:self.model.businessid type:self.type tag:@"querySFBnoTag"];
}

@end
