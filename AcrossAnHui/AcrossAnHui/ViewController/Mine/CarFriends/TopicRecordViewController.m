//
//  TopicRecordViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "TopicRecordViewController.h"
#import "CTopicRecordView.h"
#import "CarFriendRecordNetData.h"
#import "CarFriendCardModel.h"
#import "CarFriendTopicModel.h"
#import "CarFriendInfoViewController.h"

#define startPage 1

@interface TopicRecordViewController ()

@property (nonatomic, retain) CTopicRecordView *topicRecordView;
@property (nonatomic, retain) CarFriendRecordNetData *carFriendRecordNetData;

@end

@implementation TopicRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"话题";
    
    [self.view addSubview:self.topicRecordView];
    [self.topicRecordView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _carFriendRecordNetData = [[CarFriendRecordNetData alloc] init];
    _carFriendRecordNetData.delegate = self;
    
    [self showHub];
    _currentPage = startPage - 1;
    [self getmyrecommendcardlist];
    
    // 帖子详情页返回的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelectModel:) name:CarFriendInfoNotificationName object:nil];
}

// 帖子详情页返回后，需要更新该model的属性
- (void) updateSelectModel:(NSNotification *)noti {
    CarFriendCardModel *model = (CarFriendCardModel *) noti.object;
    [_topicRecordView updateSelectModel:model];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getmyrecommendcardlistTag"]) {
        [_topicRecordView endRefreshing];
        
        NSDictionary *dict = (NSDictionary *)result;
        int pages = [dict[@"pageCount"] intValue];// 总页数
        _currentPage = [dict[@"offset"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        NSArray *models = [CarFriendTopicModel convertFromArray:result[@"data"]];
        
        // 过滤掉 “老司机” “推荐”
        NSMutableArray *filterArray = [[NSMutableArray alloc] init];
        for (CarFriendTopicModel *model in models) {
            if ([model.classifyName isEqualToString:@"公告"] ||
                [model.classifyName isEqualToString:@"随手拍"] ||
                [model.classifyName isEqualToString:@"问小畅"]) {
                [filterArray addObject:model];
            }
        }
        
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_topicRecordView refreshDataSource:filterArray];
        } else {// 加载
            [_topicRecordView addDataSource:filterArray page:_currentPage];
        }
        
        if (_currentPage >= pages) {
            // 删除加载提示
            [_topicRecordView removeFooter];
        } else {
            [_topicRecordView addFooter];
        }
    }
    
    if ([tag isEqualToString:@"deleteusercommenorcardtlistTag"]) {
        [_topicRecordView updateDeleteModel];
        [[NSNotificationCenter defaultCenter] postNotificationName:CarFriendDeleteNotificationName object:nil userInfo:nil];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getmyrecommendcardlistTag"]) {
        [_topicRecordView endRefreshing];
        [_topicRecordView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新的时候才能展示nil界面
            [_topicRecordView refreshDataSource:nil];
        } else {// 加载
            [_topicRecordView addDataSource:@[] page:_currentPage];
        }
        
        _currentPage--;
    }
}

#pragma mark - getter/setter

- (CTopicRecordView *) topicRecordView {
    if (!_topicRecordView) {
        _topicRecordView = [[CTopicRecordView alloc] init];
        
        @weakify(self)
        [_topicRecordView setRefreshNewsInfoDataListener:^ (BOOL isRequestFailure) {
            @strongify(self)
            
            if (isRequestFailure) {
                [self showHub];
            }
            
            self.currentPage = startPage - 1;
            [self getmyrecommendcardlist];
        }];
        
        [_topicRecordView setLoadNewsInfoDataListener:^ {
            @strongify(self)
            
            [self getmyrecommendcardlist];
        }];
        
        [_topicRecordView setShowCarFriendInfoListener:^ (id result) {\
            @strongify(self)
            CarFriendTopicModel *model = (CarFriendTopicModel *) result;
            
            CarFriendInfoViewController *controller = [[CarFriendInfoViewController alloc] init];
            controller.cardID = model.topicID;
            [self basePushViewController:controller];
        }];
        
        [_topicRecordView setDeleteTopicListener:^ (id result) {
            @strongify(self)
            
            CarFriendTopicModel *model = (CarFriendTopicModel *) result;
            [self deleteTopic:model];
            
        }];
    }
    
    return _topicRecordView;
}

- (void) getmyrecommendcardlist {
    // 请求下一页数据
    _currentPage++;
    [_carFriendRecordNetData getmyrecommendcardlistWithToken:self.loginModel.token
                                                      userId:self.loginModel.loginID
                                                 currentPage:_currentPage
                                                         tag:@"getmyrecommendcardlistTag"];
}

// 删除话题
- (void) deleteTopic:(CarFriendTopicModel *)model {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                        message:@"确认删除该条话题吗？"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self showHubWithLoadText:@"删除中..."];
        [self.carFriendRecordNetData deleteusercommenorcardtlistWithToken:self.loginModel.token
                                                                  topicID:model.topicID
                                                                      tag:@"deleteusercommenorcardtlistTag"];
    }];
    [controller addAction:cancelAction];
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
