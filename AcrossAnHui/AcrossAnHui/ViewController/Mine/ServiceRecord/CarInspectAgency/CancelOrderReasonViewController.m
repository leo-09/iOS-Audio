//
//  CancelOrderReasonViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CancelOrderReasonViewController.h"
#import "CCancelOrderReasonView.h"
#import "CancelOrderReasonModel.h"
#import "CarInspectRecordNetData.h"

@interface CancelOrderReasonViewController ()

@property (nonatomic, retain) CarInspectRecordNetData *carInspectRecordNetData;
@property (nonatomic, retain) CCancelOrderReasonView *cancelOrderReasonView;

@end

@implementation CancelOrderReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"取消原因";
    
    [self.view addSubview:self.cancelOrderReasonView];
    [self.cancelOrderReasonView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _carInspectRecordNetData = [[CarInspectRecordNetData alloc] init];
    _carInspectRecordNetData.delegate = self;
    
    [self showHub];
    [_carInspectRecordNetData findCancelResonListWithTag:@"findCancelResonListTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"findCancelResonListTag"]) {
        NSArray *reasons = [CancelOrderReasonModel convertFromArray:(NSArray *) result];
        self.cancelOrderReasonView.dataSource = reasons;
    }
    
    if ([tag isEqualToString:@"cancelSubscribeTag"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"findCancelResonListTag"]) {
        self.cancelOrderReasonView.dataSource = nil;
    }
    
    if ([tag isEqualToString:@"cancelSubscribeTag"]) {
        [self showTextHubWithContent:@"订单取消失败，请稍后重试"];
    }
}

#pragma mark - getter/setter

- (CCancelOrderReasonView *) cancelOrderReasonView {
    if (!_cancelOrderReasonView) {
        _cancelOrderReasonView = [[CCancelOrderReasonView alloc] init];
        
        @weakify(self)
        [_cancelOrderReasonView setSubmitReasonListener:^(id result) {
            @strongify(self)
            
            [self showHubWithLoadText:@"取消中..."];
            [self.carInspectRecordNetData cancelSubscribeWithToken:self.loginModel.token businessid:self.businessid reasonid:(NSString *) result tag:@"cancelSubscribeTag"];
        }];
    }
    
    return _cancelOrderReasonView;
}

@end
