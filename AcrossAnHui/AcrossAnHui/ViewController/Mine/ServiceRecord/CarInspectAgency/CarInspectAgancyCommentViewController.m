//
//  CarInspectAgancyCommentViewController.m
//  AcrossAnHui
//
//  Created by ztd on 2017/8/9.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgancyCommentViewController.h"
#import "DrivervaluateView.h"
#import "CarInspectRecordNetData.h"

@interface CarInspectAgancyCommentViewController ()

@property (nonatomic ,retain)CarInspectRecordNetData *  carInspectRecordNetData;

@end

@implementation CarInspectAgancyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评价";
    
    _carInspectRecordNetData = [[CarInspectRecordNetData alloc]init];
    _carInspectRecordNetData.delegate = self;
    
    [self addView];
}

- (void)addView {
    DrivervaluateView * ervaluateView = [[DrivervaluateView alloc] init];
    ervaluateView.agencyOrderModel = self.agencyOrderModel;
    
    [self.view addSubview:ervaluateView];
    [ervaluateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(CTXScreenWidth));
        make.height.equalTo(@(CTXScreenHeight-64));
    }];
    
    [ervaluateView setSubmitListener:^(DBCarInfoModel *agencyOrderModel, NSString *textViewStr, CGFloat speed, CGFloat server) {
        [self showHubWithLoadText:@"正在提交"];
        [_carInspectRecordNetData driverEvaluateWithToken:self.loginModel.token orderid:agencyOrderModel.orderId driverPhone:agencyOrderModel.driverPhone attitude:server speed:speed content:textViewStr tag:@"driverErvaluateTag"];
    }];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"driverErvaluateTag"]) {
        [self showTextHubWithContent:tint];
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [self hideHub];
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
}

@end
