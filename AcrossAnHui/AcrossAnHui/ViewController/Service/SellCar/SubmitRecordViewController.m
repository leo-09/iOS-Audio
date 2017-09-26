//
//  submitRecordViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SubmitRecordViewController.h"
#import "ServiceNetData.h"
#import "SubmitRecordModel.h"

#define startPage 1

@interface SubmitRecordViewController ()

@property (nonatomic, retain) ServiceNetData *serviceNetData;

@end

@implementation SubmitRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提交记录";
    [self.view addSubview:self.submitRecordView];
    [self.submitRecordView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self showHub];
    _currentPage = startPage - 1;
    
    _serviceNetData = [[ServiceNetData alloc] init];
    _serviceNetData.delegate = self;
    [self getAPPSellCarList];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getAPPSellCarListTag"]) {
        [_submitRecordView endRefreshing];
        [self hideHub];
        
        NSDictionary *dict = (NSDictionary *)result;
        int pages = [dict[@"pageCount"] intValue];// 总页数
        _currentPage = [dict[@"offset"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        NSArray *dataSource = [SubmitRecordModel convertFromArray:dict[@"data"]];
        
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_submitRecordView refreshDataSource:dataSource];
        } else {// 加载
            [_submitRecordView addDataSource:dataSource];
        }
        
        if (_currentPage >= pages) {
            // 删除加载提示
            [_submitRecordView removeFooter];
        } else {
            [_submitRecordView addFooter];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    
    if ([tag isEqualToString:@"getAPPSellCarListTag"]) {
        [self hideHub];
        [_submitRecordView endRefreshing];
        [_submitRecordView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新
            [_submitRecordView refreshDataSource:nil];
        } else {// 加载
            [_submitRecordView addDataSource:@[]];
        }
        
        _currentPage--;
    }
}

#pragma mark - getter/setter

- (CSubmitRecordView *) submitRecordView {
    if (!_submitRecordView) {
        _submitRecordView = [[CSubmitRecordView alloc] init];
    }
    
    @weakify(self)
    
    [_submitRecordView setRefreshSubmitRecordDataListener:^(BOOL isRequestFailure) {
        @strongify(self);
        
        if (isRequestFailure) {
            [self showHub];// 点击刷新需要显示加载动画
        }
        
        self.currentPage = startPage - 1;
        [self getAPPSellCarList];
    }];
    
    [_submitRecordView setLoadSubmitRecordDataListener:^{
        @strongify(self);
        [self getAPPSellCarList];
    }];
    
    return _submitRecordView;
}

- (void) getAPPSellCarList {
    // 请求下一页数据
    _currentPage++;
    [_serviceNetData getAPPSellCarListWithToken:self.loginModel.token userId:self.loginModel.loginID page:_currentPage tag:@"getAPPSellCarListTag"];
}

@end
