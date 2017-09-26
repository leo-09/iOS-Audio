//
//  NewsInfoViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "NewsInfoViewController.h"
#import "SearchNewsInfoViewController.h"
#import "ServiceNetData.h"
#import "NewsInfoModel.h"
#import "CTXWKWebViewController.h"

#define startPage 1

@interface NewsInfoViewController ()

@property (nonatomic, retain) ServiceNetData *serviceNetData;

@end

@implementation NewsInfoViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.naviTitle) {
        self.navigationItem.title = self.naviTitle;
    } else {
        self.navigationItem.title = @"新闻资讯";
        // rightBarButtonItem
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sousuo"] style:UIBarButtonItemStyleDone target:self action:@selector(searchNewInfo)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    
    [self.view addSubview:self.newsInfoView];
    [self.newsInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    // 当前页
    _currentPage = startPage - 1;
    // 必须在请求数据前，显示加载动画
    [self showHub];
    
    _serviceNetData = [[ServiceNetData alloc] init];
    _serviceNetData.delegate = self;
    // 进入则默认请求数据
    [self getNewsList];
}

// 搜索新闻
- (void) searchNewInfo {
    SearchNewsInfoViewController *controller = [[SearchNewsInfoViewController alloc] init];
    [self basePushViewController:controller];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getNewsListTag"]) {
        [_newsInfoView endRefreshing];
        [self hideHub];
        
        NSDictionary *dict = (NSDictionary *)result;
        int pages = [dict[@"pages"] intValue];// 总页数
        _currentPage = [dict[@"current"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        NSArray *newsInfos = [NewsInfoModel convertFromArray:dict[@"records"]]; // 请求的结果
        
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_newsInfoView refreshDataSource:newsInfos nilDataTint:_nilDataTint];
        } else {// 加载
            [_newsInfoView addDataSource:newsInfos page:_currentPage];
        }
        
        if (_currentPage >= pages) {
            // 删除加载提示
            [_newsInfoView removeFooter];
        } else {
            [_newsInfoView addFooter];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    
    if ([tag isEqualToString:@"getNewsListTag"]) {
        [self hideHub];
        [_newsInfoView endRefreshing];
        [_newsInfoView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新的时候才能展示nil界面
            [_newsInfoView refreshDataSource:nil nilDataTint:_nilDataTint];
        } else {// 加载
            [_newsInfoView addDataSource:@[] page:_currentPage];
        }
        
        _currentPage--;
    }
}

#pragma mark - getter/setter

- (CNewsInfoView *) newsInfoView {
    if (!_newsInfoView) {
        _newsInfoView = [[CNewsInfoView alloc] init];
        
        @weakify(self)
        [_newsInfoView setSelectNewsInfoCellListener:^(id result) {
            @strongify(self);
            NewsInfoModel *model = (NewsInfoModel *) result;
            CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
            controller.name = model.name;
            controller.url = model.appNewsUrl;
            controller.desc = model.title;
            [self basePushViewController:controller];
        }];
        
        [_newsInfoView setRefreshNewsInfoDataListener:^(BOOL isRequestFailure) {
            @strongify(self);
            
            if (isRequestFailure) {
                [self showHub];// 点击刷新需要显示加载动画
            }
            self.currentPage = startPage - 1;
            [self getNewsList];
        }];
        [_newsInfoView setLoadNewsInfoDataListener:^{
            @strongify(self);
            [self getNewsList];
        }];
    }
    
    return _newsInfoView;
}

- (void) getNewsList {
    // 请求下一页数据
    _currentPage++;
    [_serviceNetData getNewsListWithName:self.searchkeyWord currentPage:_currentPage tag:@"getNewsListTag"];
}

@end
