//
//  HighRoadTrafficViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "HighRoadTrafficViewController.h"
#import "CoreServeNetData.h"
#import "HighTraficModel.h"

#define startPage 1

@interface HighRoadTrafficViewController ()

@property (nonatomic, retain) CoreServeNetData *serveNetData;

@end

@implementation HighRoadTrafficViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"高速路况";
    
    [self.view addSubview:self.highRoadTrafficView];
    [self.highRoadTrafficView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    // 当前页
    _currentPage = startPage - 1;
    // 必须在请求数据前，显示加载动画
    [self showHub];
    
    _serveNetData = [[CoreServeNetData alloc] init];
    _serveNetData.delegate = self;
    [self getHighSpeed];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getHighSpeedTag"]) {
        [_highRoadTrafficView endRefreshing];
        [self hideHub];
        
        NSDictionary *dict = (NSDictionary *)result;
        int pages = [dict[@"pageCount"] intValue];// 总页数
        _currentPage = [dict[@"offset"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        NSArray *highTrafics = [HighTraficModel convertFromArray:result[@"data"]];
        
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_highRoadTrafficView refreshDataSource:highTrafics];
        } else {// 加载
            [_highRoadTrafficView addDataSource:highTrafics page:_currentPage];
        }
        
        if (_currentPage >= pages) {
            // 删除加载提示
            [_highRoadTrafficView removeFooter];
        } else {
            [_highRoadTrafficView addFooter];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    
    if ([tag isEqualToString:@"getHighSpeedTag"]) {
        [self hideHub];
        [_highRoadTrafficView endRefreshing];
        [_highRoadTrafficView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新的时候才能展示nil界面
            [_highRoadTrafficView refreshDataSource:nil];
        } else {// 加载
            [_highRoadTrafficView addDataSource:@[] page:_currentPage];
        }
        
        _currentPage--;
    }
}

#pragma mark - getter/setter

- (CHighRoadTrafficView *) highRoadTrafficView {
    if (!_highRoadTrafficView) {
        _highRoadTrafficView = [[CHighRoadTrafficView alloc] init];
        
        @weakify(self)
        [_highRoadTrafficView setRefreshNewsInfoDataListener:^(BOOL isRequestFailure) {
            @strongify(self);
            
            // 点击刷新需要显示加载动画
            if (isRequestFailure) {
                [self showHub];
            }
            self.currentPage = startPage - 1;
            [self getHighSpeed];
        }];
        [_highRoadTrafficView setLoadNewsInfoDataListener:^{
            @strongify(self);
            [self getHighSpeed];
        }];
    }
    
    return _highRoadTrafficView;
}

- (void) getHighSpeed {
    // 请求下一页数据
    _currentPage++;
    [_serveNetData getHighSpeedWithPage:_currentPage tag:@"getHighSpeedTag"];
}

@end
