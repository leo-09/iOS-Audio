//
//  OrderTrackViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "OrderTrackViewController.h"
#import "CarInspectAgencyOrderTrackModel.h"
#import "COrderTrackView.h"
#import "CarInspectRecordNetData.h"

@interface OrderTrackViewController ()

@property (nonatomic, retain) CarInspectRecordNetData *carInspectRecordNetData;
@property (nonatomic, retain) COrderTrackView *orderTrackView;

@end

@implementation OrderTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单跟踪";
    
    [self.view addSubview:self.orderTrackView];
    [self.orderTrackView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    [self showHub];
    
    _carInspectRecordNetData = [[CarInspectRecordNetData alloc] init];
    _carInspectRecordNetData.delegate = self;
    [_carInspectRecordNetData getOrderRecordWithToken:self.loginModel.token businessid:self.businessid tag:@"getOrderRecordTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getOrderRecordTag"]) {
        NSArray *orderModels = [CarInspectAgencyOrderTrackModel convertFromArray:(NSArray *)result];
        self.orderTrackView.dataSource = orderModels;
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getOrderRecordTag"]) {
        self.orderTrackView.dataSource = nil;
    }
}

#pragma mark - getter/setter

- (COrderTrackView *) orderTrackView {
    if (!_orderTrackView) {
        _orderTrackView = [[COrderTrackView alloc] init];
    }
    
    return _orderTrackView;
}

@end
