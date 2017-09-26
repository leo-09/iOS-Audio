//
//  ActivityZoneViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ActivityZoneViewController.h"
#import "CTXWKWebViewController.h"
#import "ServiceNetData.h"
#import "ActivityZoneModel.h"

#define startPage 0

@interface ActivityZoneViewController ()

@property (nonatomic, retain) ServiceNetData *serviceNetData;

@end

@implementation ActivityZoneViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"活动专区";
    [self.view addSubview:self.activityZoneView];
    
    // 必须在请求数据前，显示加载动画
    [self showHub];
    
    _serviceNetData = [[ServiceNetData alloc] init];
    _serviceNetData.delegate = self;
    
    // 进入则默认请求数据
    _currentPage = startPage - 1;
    [self getActivityZone];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getActivityZoneListTag"]) {
        [_activityZoneView endRefreshing];
        [self hideHub];
        
        NSArray *activityZones = [ActivityZoneModel convertFromArray:(NSArray *)result];
        
        // 没有回传最新当前页码，重新联网后的请求就会出错
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_activityZoneView refreshDataSource:activityZones];
        } else {// 加载
            [_activityZoneView addDataSource:activityZones page:_currentPage];
        }
        
        if (activityZones.count < 10) {
            // 删除加载提示
            [_activityZoneView removeFooter];
        } else {
            [_activityZoneView addFooter];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    
    if ([tag isEqualToString:@"getActivityZoneListTag"]) {
        [self hideHub];
        [_activityZoneView endRefreshing];
        [_activityZoneView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新的时候才能展示nil界面
            [_activityZoneView refreshDataSource:nil];
        } else {// 加载
            [_activityZoneView addDataSource:@[] page:_currentPage];
        }
        
        _currentPage--;
    }
}

#pragma mark - getter/setter

- (CActivityZoneView *) activityZoneView {
    if (!_activityZoneView) {
        CGRect frame = CGRectMake(0, 0, CTXScreenWidth, (CTXScreenHeight - CTXNavigationBarHeight - CTXBarHeight));
        _activityZoneView = [[CActivityZoneView alloc] initWithFrame:frame];
        
        @weakify(self)
        [_activityZoneView setSelectActivityCellListener:^(id result) {
            @strongify(self);
            ActivityZoneModel *model = (ActivityZoneModel *) result;
            CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
            controller.name = model.title;
            if (model.outsideUrl && ![model.outsideUrl isEqualToString:@""]) {
                controller.url = model.outsideUrl;
            } else {
                controller.url = model.linkUrl;
            }
            controller.desc = model.remark;
            [self basePushViewController:controller];
        }];
        
        [_activityZoneView setRefreshActivityDataListener:^(BOOL isRequestFailure) {
            @strongify(self);
            
            // 点击刷新需要显示加载动画
            if (isRequestFailure) {
                [self showHub];
            }
            self.currentPage = startPage - 1;
            [self getActivityZone];
        }];
        [_activityZoneView setLoadActivityDataListener:^{
            @strongify(self);
            [self getActivityZone];
        }];
    }
    
    return _activityZoneView;
}

- (void) getActivityZone {
    // 请求下一页数据
    _currentPage++;
    [_serviceNetData getActivityZoneListWithStartPage:_currentPage tag:@"getActivityZoneListTag"];
}

@end
