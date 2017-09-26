//
//  CarAgencyRecordViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/7.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarAgencyRecordViewController.h"
#import "CarInspectRecordNetData.h"
#import "CCarAgencyRecordView.h"
#import "OYCountDownManager.h"
#import "CarInspectAgencyRecordModel.h"
#import "CarInspectAgencyDetailViewController.h"
#import "SelectBindedCarViewController.h"
#import "CarInspectAgencyViewController.h"
#import "SubmitCarInfoViewController.h"
#import "CarInspectAgancyCommentViewController.h"
#import "CarInspectAgencyOnlinePayViewController.h"

#define startPage 0

@interface CarAgencyRecordViewController ()

@property (nonatomic, retain) CarInspectRecordNetData *carInspectRecordNetData;
@property (nonatomic, retain) CCarAgencyRecordView *carAgencyRecordView;

@property (nonatomic, retain) CarInspectAgencyRecordModel *currentModel;

@end

@implementation CarAgencyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"车检代办记录";
    [self.view addSubview:self.carAgencyRecordView];
    [self.carAgencyRecordView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.left.equalTo(@0);
        make.bottom.equalTo(@(-64));
    }];
    
    _carInspectRecordNetData = [[CarInspectRecordNetData alloc] init];
    _carInspectRecordNetData.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 启动倒计时管理
    [kCountDownManager start];
    
    [self showHub];
    
    _currentPage = startPage - 1;
    [self getDaiBanRecord];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [kCountDownManager invalidate];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getDaiBanRecordTag"]) {
        [_carAgencyRecordView endRefreshing];
        [self hideHub];
        
        NSArray *records = [CarInspectAgencyRecordModel convertFromArray:(NSArray *) result];
        
        // 没有回传最新当前页码，重新联网后的请求就会出错
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_carAgencyRecordView refreshDataSource:records];
        } else {// 加载
            [_carAgencyRecordView addDataSource:records];
        }
        
        if (records.count < 10) {// 小于10个记录，则表示是最后一页
            [_carAgencyRecordView removeFooter];// 删除加载提示
        } else {
            [_carAgencyRecordView addFooter];
        }

    }
    
    if ([tag isEqualToString:@"sureOrderTag"]) {
        self.currentModel.orderDetail.status = EOrderStatus_Completed_Order;
        self.currentModel.orderDetail.statusName = @"订单已完成";
        
        [_carAgencyRecordView updateCurrentModel:self.currentModel];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    
    if ([tag isEqualToString:@"getDaiBanRecordTag"]) {
        [self hideHub];
        [_carAgencyRecordView endRefreshing];
        [_carAgencyRecordView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新的时候才能展示nil界面
            [_carAgencyRecordView refreshDataSource:nil];
        } else {// 加载
            [_carAgencyRecordView addDataSource:@[]];
        }
        
        _currentPage--;
    }
    
    if ([tag isEqualToString:@"sureOrderTag"]) {
        [self showTextHubWithContent:@"确认订单失败，请稍后重试"];
    }
}

#pragma mark - getter/setter

- (CCarAgencyRecordView *) carAgencyRecordView {
    if (!_carAgencyRecordView) {
        _carAgencyRecordView = [[CCarAgencyRecordView alloc] init];
        
        @weakify(self)
        [_carAgencyRecordView setSelectAgencyRecordCellListener:^(id result) {
            @strongify(self)
            CarInspectAgencyRecordModel *model = (CarInspectAgencyRecordModel *)result;
            
            CarInspectAgencyDetailViewController *controller = [[CarInspectAgencyDetailViewController alloc] init];
            controller.businessid = model.orderDetail.businessid;
            [self basePushViewController:controller];
        }];
        
        [_carAgencyRecordView setRefreshAgencyRecordDataListener:^(BOOL isRequestFailure) {
            @strongify(self);
            
            // 点击刷新需要显示加载动画
            if (isRequestFailure) {
                [self showHub];
            }
            self.currentPage = startPage - 1;
            [self getDaiBanRecord];
        }];
        
        [_carAgencyRecordView setLoadAgencyRecordDataListener:^ {
            @strongify(self);
            [self getDaiBanRecord];
        }];
        
        [_carAgencyRecordView setToCarAgencyRecordListener:^ {
            @strongify(self)
            [self toCarFreeInspect];
        }];
        
        [_carAgencyRecordView setCommentModelListener:^(id result) {
            @strongify(self)
            
            CarInspectAgencyOrderModel *model = (CarInspectAgencyOrderModel *)result;
            if (model.carInfo && model.carInfo.idCard) {
                CarInspectAgancyCommentViewController *controller = [[CarInspectAgancyCommentViewController alloc] init];
                controller.agencyOrderModel = model.carInfo;
                [self basePushViewController:controller];
            } else {
                [self showTextHubWithContent:@"司机信息丢失，暂不能评价"];
            }
        }];
        
        [_carAgencyRecordView setPayForModelListener:^(id result) {
            @strongify(self)
            
            CarInspectAgencyOnlinePayViewController *controller = [[CarInspectAgencyOnlinePayViewController alloc] init];
            controller.orderModel = (CarInspectAgencyOrderModel *)result;
            controller.isFromRecord = YES;
            [self basePushViewController:controller];
        }];
        
        [_carAgencyRecordView setCompleteModelListener:^(id result) {
            @strongify(self)
            
            self.currentModel = (CarInspectAgencyRecordModel *)result;
            [self alertWithRecordModel:self.currentModel];
        }];
    }
    
    return _carAgencyRecordView;
}

- (void) toCarFreeInspect {
    if ([AppDelegate sharedDelegate].isBindCar) {
        // 绑定车辆则去选择车辆
        SelectBindedCarViewController *controller = [[SelectBindedCarViewController alloc] init];
        controller.fromViewController = NSStringFromClass([CarInspectAgencyViewController class]);
        [self basePushViewController:controller];
    } else {
        // 没有绑定车辆则去添加车辆
        SubmitCarInfoViewController *controller = [[SubmitCarInfoViewController alloc] initWithStoryboard];
        controller.fromViewController = NSStringFromClass([CarInspectAgencyViewController class]);
        [self basePushViewController:controller];
    }
}

- (void) alertWithRecordModel:(CarInspectAgencyRecordModel *)model {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"确认司机已将车辆送回？"
                                                                        message:@""
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.carInspectRecordNetData sureOrderWithToken:self.loginModel.token businessid:model.orderDetail.businessid tag:@"sureOrderTag"];
    }];
    [controller addAction:cancelAction];
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)getDaiBanRecord {
    // 请求下一页数据
    _currentPage++;
    [self.carInspectRecordNetData getDaiBanRecordWithToken:self.loginModel.token
                                                    userId:self.loginModel.loginID
                                                    pageId:_currentPage
                                                       tag:@"getDaiBanRecordTag"];
}

#pragma mark - CTXSegmentedPageViewControllerDelegate

- (NSString *)viewControllerTitle {
    return self.viewTitle ? self.viewTitle : self.title;
}

@end
