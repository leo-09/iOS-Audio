//
//  CarInspectAgencyDetailViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInspectAgencyDetailViewController.h"
#import "OrderTrackViewController.h"
#import "CancelOrderReasonViewController.h"
#import "CarInspectAgancyCommentViewController.h"
#import "CarInspectAgencyOnlinePayViewController.h"
#import "DriverPostionViewController.h"
#import "ApplyRefundViewController.h"
#import "CarInspectAgencyOrderModel.h"
#import "CarInspectAgencyOrderDetailView.h"
#import "CarInspectRecordNetData.h"
#import "HWWeakTimer.h"
#import "ServeTool.h"

@interface CarInspectAgencyDetailViewController ()

@property (nonatomic, retain) CarInspectRecordNetData *carInspectRecordNetData;
@property (nonatomic, retain) CarInspectAgencyOrderModel *currentModel;

@property (nonatomic, retain) CarInspectAgencyOrderDetailView *orderDetailView;

@property (nonatomic, weak) NSTimer* timer;

@end

@implementation CarInspectAgencyDetailViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的订单";
    
    [self.view addSubview:self.orderDetailView];
    [self.orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _carInspectRecordNetData = [[CarInspectRecordNetData alloc] init];
    _carInspectRecordNetData.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.currentModel = nil;
    
    [self showHub];
    [self getOrderDetail];
    
    [self startTimer];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self invalidate];
}

- (void) close:(id)sender {
    if (self.isFromDBOnlinePayViewController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - private method

- (void) startTimer {
    if (_timer == nil) {
        refreshTime = 0;
        _timer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)invalidate {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)refreshData {
    // 未支付 未取消 等待支付时间大于0
    if ([self.currentModel isWaitPay]) {
        
        NSString *time = [self.currentModel waitPayTimeStr];
        [_orderDetailView setWaitPayTime:time];
        
        if ([time isEqualToString:@"0秒"]) {
            refreshTime = 8;
        }
    }
    
    // 等待司机接单
    if ([self.currentModel isWaitDriver]) {
        
        NSString *time = [self.currentModel waitDriverTimeStr];
        [_orderDetailView setWaitDriveTime:time];
        
        if ([time isEqualToString:@"00 : 00 : 00"]) {
            refreshTime = 8;
        }
    }
    
    // 每隔8秒刷新数据
    if (refreshTime == 8) {
        refreshTime = 0;
        [self getOrderDetail];
    }
    refreshTime++;
}

- (void) getOrderDetail {
    [_carInspectRecordNetData getOrderDetailWithToken:self.loginModel.token businessid:self.businessid tag:@"getOrderDetailTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getOrderDetailTag"]) {
        [self hideHub];
        
        CarInspectAgencyOrderModel *model = [CarInspectAgencyOrderModel convertFromDict:(NSDictionary *)result];
        
        if (self.currentModel && (self.currentModel.status == model.status)) {
            // 状态没有变，则不需要刷新界面
        } else {
            self.currentModel = model;
            self.orderDetailView.orderModel = self.currentModel;
        }
        
        if (model.status == EOrderStatus_Completed_Order ||
            model.status == EOrderStatus_Cancel_Order ||
            model.status == EOrderStatus_Delete_Order) {
            
            // 以上状态就不需要定时刷新了
            [self invalidate];
        } else {
            [self startTimer];
        }
    }
    
    if ([tag isEqualToString:@"sureOrderTag"] ||
        [tag isEqualToString:@"cancelSubscribeTag"]) {
        // 操作成功,刷新界面
        [self getOrderDetail];
    }
    
    if ([tag isEqualToString:@"saveOrderAgainTag"]) {
        // 操作成功, 获取新的businessid，刷新界面
        NSDictionary *data = (NSDictionary *) result;
        self.businessid = data[@"businessid"];
        [self getOrderDetail];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"cancelSubscribeTag"]) {
        [self showTextHubWithContent:@"确认订单失败，请稍后重试"];
    }
    
    if ([tag isEqualToString:@"sureOrderTag"]) {
        [self showTextHubWithContent:@"取消预约失败，请稍后重试"];
    }
    
    if ([tag isEqualToString:@"saveOrderAgainTag"]) {
        [self showTextHubWithContent:@"重新下单失败，请稍后重试"];
    }
}


#pragma mark - getter/setter

- (CarInspectAgencyOrderDetailView *) orderDetailView {
    if (!_orderDetailView) {
        _orderDetailView = [[CarInspectAgencyOrderDetailView alloc] init];
        
        @weakify(self)
        [_orderDetailView setOrderTrackListener:^(id result) {
            @strongify(self)
            
            // 订单跟踪
            OrderTrackViewController *controller = [[OrderTrackViewController alloc] init];
            CarInspectAgencyOrderModel *model = (CarInspectAgencyOrderModel *)result;
            controller.businessid = model.businessid;
            [self basePushViewController:controller];
        }];
        
        [_orderDetailView setCancelOrderListener:^(id result) {
            @strongify(self)
            
            // 取消订单
            CarInspectAgencyOrderModel *model = (CarInspectAgencyOrderModel *) result;
            
            // 未支付 未取消 等待支付时间大于0
            if ([model isWaitPay]) {
                CancelOrderReasonViewController *controller = [[CancelOrderReasonViewController alloc] init];
                controller.businessid = model.businessid;
                [self basePushViewController:controller];
            } else if ([model isWaitDriver]) {// 等待司机接单
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"确定取消订单吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"保留订单" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self cancelSubscribe];
                }];
                [controller addAction:cancelAction];
                [controller addAction:okAction];
                
                [self presentViewController:controller animated:YES completion:nil];
            } else {
                // 司机只要开启订单，则不支持线上取消
            }
        }];
        [_orderDetailView setApplyRefundListener:^(id result) {
            @strongify(self)
            
            // 申请退款
            CarInspectAgencyOrderModel *model = (CarInspectAgencyOrderModel *) result;
            
            ApplyRefundViewController *controller = [[ApplyRefundViewController alloc] init];
            controller.businessid = model.businessid;
            [self basePushViewController:controller];
        }];
        [_orderDetailView setApplyServiceListener:^(id result) {
            @strongify(self)
            
            // 打电话申请售后
            [self callPhone:@"0551-65315641"];
        }];
        [_orderDetailView setCommitOrderListener:^(id result) {
            @strongify(self)
            
            // 确认订单
            [self sureOrder];
        }];
        [_orderDetailView setCommentOrderListener:^(id result) {
            @strongify(self)
            
            // 去评价
            CarInspectAgencyOrderModel *model = (CarInspectAgencyOrderModel *)result;
            
            if (model.carInfo && model.carInfo.idCard) {
                CarInspectAgancyCommentViewController *controller = [[CarInspectAgancyCommentViewController alloc] init];
                controller.agencyOrderModel = model.carInfo;
                [self basePushViewController:controller];
            } else {
                [self showTextHubWithContent:@"司机信息丢失，暂不能评价"];
            }
        }];
        [_orderDetailView setPaymentListener:^(id result) {
            @strongify(self)
            
            // 支付
            CarInspectAgencyOnlinePayViewController *controller = [[CarInspectAgencyOnlinePayViewController alloc] init];
            controller.orderModel = (CarInspectAgencyOrderModel *)result;
            controller.isFromRecord = YES;
            [self basePushViewController:controller];
        }];
        [_orderDetailView setCallPhoneListener:^(id result) {
            @strongify(self)
            
            // 拨打司机电话
            CarInspectAgencyOrderModel *model = (CarInspectAgencyOrderModel *) result;
            [self callPhone:model.carInfo.driverPhone];
        }];
        [_orderDetailView setDriverPostionListener:^(id result) {
            @strongify(self)
            
            // 查看司机位置
            DriverPostionViewController *controller = [[DriverPostionViewController alloc] init];
            CarInspectAgencyOrderModel *model = (CarInspectAgencyOrderModel *)result;
            controller.orderid = model.orderid;
            [self basePushViewController:controller];
        }];
        
        [_orderDetailView setContactCustomerListener:^(id result) {
            @strongify(self)
            
            // 联系客服
            if (self.currentModel.status == EOrderStatus_Canceling_Order ||
                self.currentModel.status == EOrderStatus_Blocked_Funds) {
                // 订单取消中，联系畅通行客服
                [self callPhone:@"0551-65315641"];
            } else {
                // 联系e代驾客服
                [self callPhone:@"4008345280"];
            }
        }];
        
        [_orderDetailView setOrderAgainListener:^(id result) {
            @strongify(self)
            [self saveOrderAgain];
        }];
    }
    
    return _orderDetailView;
}

- (void) callPhone:(NSString *)phone {
    if (phone) {
        [ServeTool callPhone:phone];
    } else {
        
    }
}

- (void) sureOrder {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"确认司机已将车辆送回？"
                                                                        message:@""
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showHubWithLoadText:@"确认订单中..."];
        [self.carInspectRecordNetData sureOrderWithToken:self.loginModel.token businessid:self.businessid tag:@"sureOrderTag"];
    }];
    [controller addAction:cancelAction];
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

// 取消预约记录接口
- (void)cancelSubscribe {
    [self showHubWithLoadText:@"取消预约中..."];
    
    [self.carInspectRecordNetData cancelSubscribeWithToken:self.loginModel.token businessid:self.businessid reasonid:nil tag:@"cancelSubscribeTag"];
}

// 车检代办重新下单
- (void) saveOrderAgain {
    [self showHubWithLoadText:@"重新下单中..."];
    
    [self.carInspectRecordNetData saveOrderAgainWithToken:self.loginModel.token businessid:self.businessid tag:@"saveOrderAgainTag"];
}

@end
