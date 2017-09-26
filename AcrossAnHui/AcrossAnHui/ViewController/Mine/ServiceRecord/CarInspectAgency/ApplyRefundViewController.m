//
//  ApplyRefundViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ApplyRefundViewController.h"
#import "RefundOrderReasonModel.h"
#import "CApplyRefundView.h"
#import "CarInspectRecordNetData.h"

@interface ApplyRefundViewController ()

@property (nonatomic, retain) CarInspectRecordNetData *carInspectRecordNetData;
@property (nonatomic, retain) CApplyRefundView *applyRefundView;
@property (nonatomic, retain) RefundOrderReasonModel *model;

@end

@implementation ApplyRefundViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"申请退款";
    
    [self.view addSubview:self.applyRefundView];
    [self.applyRefundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _carInspectRecordNetData = [[CarInspectRecordNetData alloc] init];
    _carInspectRecordNetData.delegate = self;
    
    [self showHub];
    [_carInspectRecordNetData getReturnMoneyResonWithToken:self.loginModel.token businessid:self.businessid tag:@"getReturnMoneyResonTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getReturnMoneyResonTag"]) {
        self.model = [RefundOrderReasonModel convertFromDict:(NSDictionary *)result];
        self.applyRefundView.model = self.model;
    }
    
    if ([tag isEqualToString:@"applyDbRefundTag"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getReturnMoneyResonTag"]) {
        self.applyRefundView.model = nil;
    }
    
    if ([tag isEqualToString:@"applyDbRefundTag"]) {
        [self showTextHubWithContent:@"退款申请失败，请稍后重试"];
    }
}

#pragma mark - getter/setter

- (CApplyRefundView *) applyRefundView {
    if (!_applyRefundView) {
        _applyRefundView = [[CApplyRefundView alloc] init];
        
        @weakify(self)
        [_applyRefundView setSubmitReasonListener:^(id result) {
            @strongify(self)
            NSString *reasonid = (NSString *) result;
            
            [self showHubWithLoadText:@"申请退款中..."];
            [self.carInspectRecordNetData applyDbRefundWithToken:self.loginModel.token
                                                      businessid:self.businessid
                                                        reasonid:reasonid
                                                           money:self.model.money
                                                             tag:@"applyDbRefundTag"];
        }];
    }
    
    return _applyRefundView;
}

@end
