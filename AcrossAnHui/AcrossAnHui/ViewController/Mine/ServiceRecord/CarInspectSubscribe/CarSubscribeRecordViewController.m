//
//  CarSubscribeRecordViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarSubscribeRecordViewController.h"
#import "SelectBindedCarViewController.h"
#import "CarInspectSubscribeViewController.h"
#import "CarSubscribeEvaluateViewController.h"
#import "SubmitCarInfoViewController.h"
#import "CarInspectOnlinePayViewController.h"
#import "CCarSubscribeRecordView.h"
#import "CarInspectRecordNetData.h"
#import "ShowEvaluateViewController.h"
#import "SubscribeModel.h"
#import "CarInspectNetData.h"

@interface CarSubscribeRecordViewController ()

@property (nonatomic, retain) CarInspectRecordNetData *carInspectRecordNetData;
@property (nonatomic, retain) CCarSubscribeRecordView *carSubscribeRecordView;

@end

#define startPage 0

@implementation CarSubscribeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"车检记录";
    [self.view addSubview:self.carSubscribeRecordView];
    [self.carSubscribeRecordView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.left.equalTo(@0);
        make.bottom.equalTo(@(-64));
    }];
    
    // 必须在请求数据前，显示加载动画
    [self showHub];
    
    _carInspectRecordNetData = [[CarInspectRecordNetData alloc] init];
    _carInspectRecordNetData.delegate = self;
    
    [self refreshSubscribeList];
}

- (void) close:(id)sender {
    if (self.isFromPayResultViewController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"subscribeListTag"]) {
        [_carSubscribeRecordView endRefreshing];
        [self hideHub];
        
        NSArray *records = [SubscribeModel convertFromArray:(NSArray *)result];
        
        // 没有回传最新当前页码，重新联网后的请求就会出错
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_carSubscribeRecordView refreshDataSource:records];
        } else {// 加载
            [_carSubscribeRecordView addDataSource:records page:_currentPage];
        }
        
        if (records.count < 10) {
            [_carSubscribeRecordView removeFooter];// 删除加载提示
        } else {
            [_carSubscribeRecordView addFooter];
        }
    }
    
    if ([tag isEqualToString:@"cancelSubscribeTag"] ||  // 取消成功
        [tag isEqualToString:@"applyRefundTag"]) {      // 申请退款成功
        [self refreshSubscribeList];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];         // 取消订单失败／申请退款失败，由这句提示用户
    [self hideHub];
    
    if ([tag isEqualToString:@"subscribeListTag"]) {
        [_carSubscribeRecordView endRefreshing];
        [_carSubscribeRecordView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新的时候才能展示nil界面
            [_carSubscribeRecordView refreshDataSource:nil];
        } else {
            [_carSubscribeRecordView addDataSource:@[] page:_currentPage];
        }
        
        _currentPage--;
    }
}

#pragma mark - getter/setter

- (CCarSubscribeRecordView *) carSubscribeRecordView {
    if (!_carSubscribeRecordView) {
        _carSubscribeRecordView = [[CCarSubscribeRecordView alloc] init];
        
        @weakify(self)
        [_carSubscribeRecordView setRefreshRecordDataListener:^(BOOL isRequestFailure) {
            @strongify(self);
            
            // 点击刷新需要显示加载动画
            if (isRequestFailure) {
                [self showHub];
            }
            
            [self refreshSubscribeList];
        }];
        
        [_carSubscribeRecordView setLoadRecordDataListener:^ {
            @strongify(self);
            [self subscribeList];
        }];
        
        [_carSubscribeRecordView setToInspectSubscribeListener:^ {
            @strongify(self)
            [self toInspectSubscribe];
        }];
        [_carSubscribeRecordView setPaySubscribeRecordListener:^(id result) {
            // 支付
            @strongify(self)
            
            CarInspectOnlinePayViewController *controller = [[CarInspectOnlinePayViewController alloc] initWithStoryboard];
            controller.model = (SubscribeModel *)result;
            [self basePushViewController:controller];
        }];
        [_carSubscribeRecordView setRefundSubscribeRecordListener:^(id result) {
            // 申请退款
            @strongify(self)
            SubscribeModel *model = (SubscribeModel *)result;
            
            [self showHubWithLoadText:@"申请退款中..."];
            [self.carInspectRecordNetData applyRefundWithToken:self.loginModel.token businessID:model.businessid tag:@"applyRefundTag"];
        }];
        [_carSubscribeRecordView setEvaluateSubscribeRecordListener:^(id result) {
            // 评价
            @strongify(self)
            
            CarSubscribeEvaluateViewController *controller = [[CarSubscribeEvaluateViewController alloc] init];
            controller.model = (SubscribeModel *)result;
            // 评价成功的回调
            [controller setGetbackViewController:^{
                [self showHub];
                [self refreshSubscribeList];
            }];
            [self basePushViewController:controller];
        }];
        [_carSubscribeRecordView setShowEvaluateSubscribeRecordListener:^(id result) {
            // 查看评价
            @strongify(self)
            SubscribeModel *model = (SubscribeModel *)result;
            
            ShowEvaluateViewController *controller = [[ShowEvaluateViewController alloc] init];
            controller.stationID = model.stationid;
            [self basePushViewController:controller];
        }];
        [_carSubscribeRecordView setCancelSubscribeRecordListener:^(id result) {
            // 取消预约
            @strongify(self)
            SubscribeModel *model = (SubscribeModel *)result;
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                                message:@"确定取消该订单吗？"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self showHubWithLoadText:@"取消订单中..."];
                [self.carInspectRecordNetData cancelSubscribeWithToken:self.loginModel.token businessid:model.businessid reasonid:nil tag:@"cancelSubscribeTag"];
            }];
            [controller addAction:cancelAction];
            [controller addAction:okAction];
            
            [self presentViewController:controller animated:YES completion:nil];
        }];
    }
    
    return _carSubscribeRecordView;
}

- (void) refreshSubscribeList {
    _currentPage = startPage - 1;// 当前页
    [self subscribeList];
}

- (void) subscribeList {
    // 请求下一页数据
    _currentPage++;
    [_carInspectRecordNetData subscribeListWithToken:self.loginModel.token
                                              userId:self.loginModel.loginID
                                         currentPage:_currentPage
                                        businessType:@"1"
                                                 tag:@"subscribeListTag"];
}

- (void) toInspectSubscribe {
    if ([AppDelegate sharedDelegate].isBindCar) {
        // 绑定车辆则去选择车辆
        SelectBindedCarViewController *controller = [[SelectBindedCarViewController alloc] init];
        controller.fromViewController = NSStringFromClass([CarInspectSubscribeViewController class]);
        [self basePushViewController:controller];
    } else {
        // 没有绑定车辆则去添加车辆
        SubmitCarInfoViewController *controller = [[SubmitCarInfoViewController alloc] initWithStoryboard];
        controller.fromViewController = NSStringFromClass([CarInspectSubscribeViewController class]);
        [self basePushViewController:controller];
    }
}

#pragma mark - CTXSegmentedPageViewControllerDelegate

- (NSString *)viewControllerTitle {
    return self.viewTitle ? self.viewTitle : self.title;
}

@end
