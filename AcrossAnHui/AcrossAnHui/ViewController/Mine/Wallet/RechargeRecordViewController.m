//
//  RechargeRecordViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "RechargeRecordViewController.h"
#import "CRechargeRecordView.h"
#import "RechargeRecordModel.h"
#import "WalletNetData.h"

#define startPage 1

@interface RechargeRecordViewController ()

@property (nonatomic, retain) CRechargeRecordView *rechargeRecordView;
@property (nonatomic, retain) WalletNetData *walletNetData;

@end

@implementation RechargeRecordViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值记录";
    
    [self.view addSubview:self.rechargeRecordView];
    [self.rechargeRecordView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _walletNetData = [[WalletNetData alloc] init];
    _walletNetData.delegate = self;
    
    [self showHub];
    
    _currentPage = startPage - 1;
    [self selectRecharge];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"selectRechargeTag"]) {
        [_rechargeRecordView endRefreshing];
        
        int totalPage = [result[@"totalPage"] intValue];
        if ([[result allKeys] containsObject:@"currentPage"]) {
            _currentPage = [result[@"currentPage"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        }
        
        // 获取充值记录并分组
        NSArray<RechargeRecordModel *> *records = [RechargeRecordModel convertFromArray:result[@"rechargeList"]];
        
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_rechargeRecordView refreshDataSource:records];
        } else {
            [_rechargeRecordView addDataSource:records];
        }
        
        if (_currentPage >= totalPage) {
            [_rechargeRecordView removeFooter];
        } else {
            [_rechargeRecordView addFooter];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"selectRechargeTag"]) {
        [_rechargeRecordView endRefreshing];
        [_rechargeRecordView hideFooter];
        
        if (_currentPage <= startPage) {
            [_rechargeRecordView refreshDataSource:nil];
        } else {
            [_rechargeRecordView addDataSource:@[]];
        }
        
        _currentPage--;
    }
}

#pragma mark - getter/setter

- (CRechargeRecordView *) rechargeRecordView {
    if (!_rechargeRecordView) {
        _rechargeRecordView = [[CRechargeRecordView alloc] init];
        
        @weakify(self)
        [_rechargeRecordView setRefreshRecordDataListener:^(BOOL isRequestFailure) {
            @strongify(self)
            
            if (isRequestFailure) {
                [self showHub];
            }
            
            self.currentPage = startPage - 1;
            [self selectRecharge];
        }];
        [_rechargeRecordView setLoadRecordDataListener:^ {
            @strongify(self)
            
            [self selectRecharge];
        }];
    }
    
    return _rechargeRecordView;
}

#pragma mark - network

// 用户余额查询
- (void)selectRecharge {
    // 请求下一页数据
    _currentPage++;
    [_walletNetData selectRechargeWithToken:self.loginModel.token
                                     userId:self.loginModel.loginID
                                       page:_currentPage
                                        tag:@"selectRechargeTag"];
}

@end
