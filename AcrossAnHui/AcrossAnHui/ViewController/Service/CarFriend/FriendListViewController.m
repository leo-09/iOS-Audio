//
//  FriendListViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "FriendListViewController.h"
#import "CFriendListView.h"
#import "CoreServeNetData.h"
#import "CarFriendHeadImageModel.h"

#define startPage 1

@interface FriendListViewController ()

@property (nonatomic, retain) CoreServeNetData *coreServeNetData;
@property (nonatomic, retain) CFriendListView *friendListView;

@end

@implementation FriendListViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"好友列表";
    [self.view addSubview:self.friendListView];
    [self.friendListView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    [self showHub];
    _currentPage = startPage - 1;
    
    _coreServeNetData = [[CoreServeNetData alloc] init];
    _coreServeNetData.delegate = self;
    [self getmorecardlauduserphoto];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getmorecardlauduserphotoTag"]) {
        [_friendListView endRefreshing];
        [self hideHub];
        
        NSDictionary *dict = (NSDictionary *)result;
        int pages = [dict[@"pageCount"] intValue];// 总页数
        _currentPage = [dict[@"offset"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        NSArray * models = [CarFriendHeadImageModel convertFromArray:(NSArray *)dict[@"data"]];
        
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_friendListView refreshDataSource:models];
        } else {// 加载
            [_friendListView addDataSource:models];
        }
        
        if (_currentPage >= pages) {
            // 删除加载提示
            [_friendListView removeFooter];
        } else {
            [_friendListView addFooter];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    
    if ([tag isEqualToString:@"getmorecardlauduserphotoTag"]) {
        [self hideHub];
        [_friendListView endRefreshing];
        [_friendListView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新的时候才能展示nil界面
            [_friendListView refreshDataSource:nil];
        } else {// 加载
            [_friendListView addDataSource:@[]];
        }
        
        _currentPage--;
    }
}

#pragma mark - getter/setter

- (CFriendListView *) friendListView {
    if (!_friendListView) {
        _friendListView = [[CFriendListView alloc] init];
        
        @weakify(self)
        [_friendListView setRefreshFriendDataListener:^(BOOL isRequestFailure) {
            @strongify(self)
            
            if (isRequestFailure) {
                [self showHub];
            }
            
            self.currentPage = startPage - 1;
            [self getmorecardlauduserphoto];
        }];
        
        [_friendListView setLoadFriendDataListener:^ {
            @strongify(self)
            [self getmorecardlauduserphoto];
        }];
    }
    
    return _friendListView;
}

- (void) getmorecardlauduserphoto {
    // 请求下一页数据
    _currentPage++;
    [_coreServeNetData getmorecardlauduserphotoWithCardID:self.cardID currentPage:_currentPage tag:@"getmorecardlauduserphotoTag"];
}

@end
