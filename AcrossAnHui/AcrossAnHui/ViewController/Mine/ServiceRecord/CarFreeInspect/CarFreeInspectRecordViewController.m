//
//  CarFreeInspectRecordViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/5.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFreeInspectRecordViewController.h"
#import "SelectBindedCarViewController.h"
#import "CarFreeInspectViewController.h"
#import "CarFreeInspectPayViewController.h"
#import "SubmitCarInfoViewController.h"
#import "CCarFreeInspectRecordView.h"
#import "CarInspectLogisticsViewController.h"
#import "SubscribeModel.h"
#import "CarInspectRecordNetData.h"

#define startPage 0

@interface CarFreeInspectRecordViewController ()

@property (nonatomic, retain) CarInspectRecordNetData *carInspectRecordNetData;
@property (nonatomic, retain) CCarFreeInspectRecordView *carFreeInspectRecordView;

@end

@implementation CarFreeInspectRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"申请6年免检记录";
    [self.view addSubview:self.carFreeInspectRecordView];
    [self.carFreeInspectRecordView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.left.equalTo(@0);
        make.bottom.equalTo(@(-64));
    }];
    
    // 当前页
    _currentPage = startPage - 1;
    // 必须在请求数据前，显示加载动画
    [self showHub];
    
    _carInspectRecordNetData = [[CarInspectRecordNetData alloc] init];
    _carInspectRecordNetData.delegate = self;
    [self subscribeList];
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
        [_carFreeInspectRecordView endRefreshing];
        [self hideHub];
        
        NSArray *records = [SubscribeModel convertFromArray:(NSArray *)result];
        
        // 没有回传最新当前页码，重新联网后的请求就会出错
        if (_currentPage <= startPage) {// 刷新, 分页从0开始，_currentPage=1则表示刚刷新数据
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_carFreeInspectRecordView refreshDataSource:records];
        } else {// 加载
            [_carFreeInspectRecordView addDataSource:records page:_currentPage];
        }
        
        if (records.count < 10) {
            // 删除加载提示
            [_carFreeInspectRecordView removeFooter];
        } else {
            [_carFreeInspectRecordView addFooter];
        }
    }
    
    if ([tag isEqualToString:@"cancelSubscribeTag"] ||  // 取消成功
        [tag isEqualToString:@"applyRefundTag"]) {      // 申请退款成功
        self.currentPage = startPage - 1;
        [self subscribeList];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];             // 取消订单失败／申请退款失败，由这句提示用户
    [self hideHub];
    
    if ([tag isEqualToString:@"subscribeListTag"]) {
        [_carFreeInspectRecordView endRefreshing];
        [_carFreeInspectRecordView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新的时候才能展示nil界面
            [_carFreeInspectRecordView refreshDataSource:nil];
        } else {
            [_carFreeInspectRecordView addDataSource:@[] page:_currentPage];
        }
        
        _currentPage--;
    }
}

#pragma mark - getter/setter

- (CCarFreeInspectRecordView *) carFreeInspectRecordView {
    if (!_carFreeInspectRecordView) {
        _carFreeInspectRecordView = [[CCarFreeInspectRecordView alloc] init];
        
        @weakify(self)
        
        // 刷新
        [_carFreeInspectRecordView setRefreshRecordDataListener:^(BOOL isRequestFailure) {
            @strongify(self);
            
            // 点击刷新需要显示加载动画
            if (isRequestFailure) {
                [self showHub];
            }
            self.currentPage = startPage - 1;
            [self subscribeList];
        }];
        
        // 加载
        [_carFreeInspectRecordView setLoadRecordDataListener:^ {
            @strongify(self);
            [self subscribeList];
        }];
        
        // 去申请六年免检
        [_carFreeInspectRecordView setToCarFreeInspectListener:^ {
            @strongify(self)
            
            [self toCarFreeInspect];
        }];
        
        // 支付
        [_carFreeInspectRecordView setPaySubscribeRecordListener:^(id result) {
            @strongify(self)
            
            CarFreeInspectPayViewController *controller = [[CarFreeInspectPayViewController alloc] initWithStoryboard];
            controller.model = (SubscribeModel *) result;
            [self basePushViewController:controller];
        }];
        
        // 申请退款
        [_carFreeInspectRecordView setRefundSubscribeRecordListener:^(id result) {
            @strongify(self)
            SubscribeModel *model = (SubscribeModel *)result;
            
            [self showHubWithLoadText:@"申请退款中..."];
            [self.carInspectRecordNetData applyRefundWithToken:self.loginModel.token businessID:model.businessid tag:@"applyRefundTag"];
        }];
        
        // 取消申请
        [_carFreeInspectRecordView setCancelSubscribeRecordListener:^(id result) {
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
        
        // 查看物流
        [_carFreeInspectRecordView setLogisticsSubscribeRecordListener:^(id result) {
            @strongify(self)
            
            CarInspectLogisticsViewController *controller = [[CarInspectLogisticsViewController alloc] init];
            controller.model = (SubscribeModel *) result;
            [self basePushViewController:controller];
        }];
    }
    
    return _carFreeInspectRecordView;
}

- (void) subscribeList {
    // 请求下一页数据
    _currentPage++;
    [_carInspectRecordNetData subscribeListWithToken:self.loginModel.token
                                              userId:self.loginModel.loginID
                                         currentPage:_currentPage
                                        businessType:@"2"
                                                 tag:@"subscribeListTag"];
}

- (void) toCarFreeInspect {
    if ([AppDelegate sharedDelegate].isBindCar) {
        // 绑定车辆则去选择车辆
        SelectBindedCarViewController *controller = [[SelectBindedCarViewController alloc] init];
        controller.fromViewController = NSStringFromClass([CarFreeInspectViewController class]);
        [self basePushViewController:controller];
    } else {
        // 没有绑定车辆则去添加车辆
        SubmitCarInfoViewController *controller = [[SubmitCarInfoViewController alloc] initWithStoryboard];
        controller.fromViewController = NSStringFromClass([CarFreeInspectViewController class]);
        [self basePushViewController:controller];
    }
}

#pragma mark - CTXSegmentedPageViewControllerDelegate

- (NSString *)viewControllerTitle {
    return self.viewTitle ? self.viewTitle : self.title;
}

@end
