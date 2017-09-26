//
//  SearchParkingViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SearchParkingViewController.h"
#import "SiteModel.h"
#import "CSearchParkingView.h"
#import "ParkingMapViewController.h"
#import "ParkingSiteSearchLocalData.h"
#import "ParkingNetData.h"

#define startPage 1

@interface SearchParkingViewController ()

@property (nonatomic, copy) NSString *searchKeyword;
@property (nonatomic, retain) CSearchParkingView *searchParkingView;

@property (nonatomic, retain) ParkingNetData *parkingNetData;

@end

@implementation SearchParkingViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.searchParkingView];
    [self.searchParkingView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _parkingNetData = [[ParkingNetData alloc] init];
    _parkingNetData.delegate = self;
    
    // 显示历史记录
    NSMutableArray *siteList = [[ParkingSiteSearchLocalData sharedInstance] queryAllRecord];
    [self.searchParkingView refreshDataSource:siteList isRecord:YES];
    [self.searchParkingView removeFooter];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"selectSiteListTag"]) {
        [_searchParkingView endRefreshing];
        
        int totalPage = [result[@"totalPage"] intValue];
        _currentPage = [result[@"currentPage"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        NSArray *siteList = [SiteModel convertFromArray:result[@"siteList"]];
        
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_searchParkingView refreshDataSource:siteList isRecord:NO];
        } else {
            [_searchParkingView addDataSource:siteList];
        }
        
        if (_currentPage >= totalPage) {
            [_searchParkingView removeFooter];// 删除加载提示
        } else {
            [_searchParkingView addFooter];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"selectSiteListTag"]) {
        [_searchParkingView endRefreshing];
        [_searchParkingView hideFooter];
        
        if (_currentPage <= startPage) {
            [_searchParkingView refreshDataSource:nil isRecord:NO];
        } else {
            [_searchParkingView addDataSource:@[]];
        }
        
        _currentPage--;
    }
}

#pragma mark - network

// 查询附近列表页
- (void) queryParkListWithSiteName:(NSString *)sitename {
    // 请求下一页数据
    _currentPage++;
    [_parkingNetData selectSiteListWithSitename:sitename longitude:_coordinate.longitude latitude:_coordinate.latitude page:_currentPage tag:@"selectSiteListTag"];
}

#pragma mark - getter/setter

- (CSearchParkingView *) searchParkingView {
    if (!_searchParkingView) {
        _searchParkingView = [[CSearchParkingView alloc] init];
        
        @weakify(self)
        [_searchParkingView setBackListener:^ {
            @strongify(self)
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [_searchParkingView setSearchSiteListener:^(id result) {
            @strongify(self)
            self.searchKeyword = (NSString *)result;
            
            self.currentPage = startPage - 1;
            [self showHub];
            [self queryParkListWithSiteName:self.searchKeyword];
        }];
        
        [_searchParkingView setLoadParkDataListener:^ {
            @strongify(self)
            
            [self queryParkListWithSiteName:self.searchKeyword];
        }];
        
        [_searchParkingView setRefreshParkDataListener:^(BOOL isRequestFailure) {
            @strongify(self)
            
            if (isRequestFailure) {
                [self showHub];
            }
            
            self.currentPage = startPage - 1;
            [self queryParkListWithSiteName:self.searchKeyword];
        }];
        
        [_searchParkingView setSelectListener:^(id result) {
            @strongify(self);
            
            SiteModel *model = (SiteModel *) result;
            
            // 记录选择的目的地／停车场
            [[ParkingSiteSearchLocalData sharedInstance] addRecord:model];
            
            ParkingMapViewController *controller = [[ParkingMapViewController alloc] init];
            controller.siteModel = model;
            [self basePushViewController:controller];
        }];
        
        [_searchParkingView setCleanRecordListener:^ {
            [[ParkingSiteSearchLocalData sharedInstance] removeAllRecord];
        }];
    }
    
    return _searchParkingView;
}

@end
