//
//  CollectionRecordViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/8/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CollectionRecordViewController.h"
#import "CarFriendInfoViewController.h"
#import "CCollectionRecordView.h"
#import "CarFriendRecordNetData.h"
#import "CarFriendCardModel.h"
#import "CarFriendCommentModel.h"

@interface CollectionRecordViewController ()

@property (nonatomic, retain) CCollectionRecordView *collectionRecordView;
@property (nonatomic, retain) CarFriendRecordNetData *carFriendRecordNetData;

@end

#define startPage 1

@implementation CollectionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"收藏";
    [self.view addSubview:self.collectionRecordView];
    [self.collectionRecordView makeConstraints:^(MASConstraintMaker *make) {
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
    [_collectionRecordView updateSelectModel:model];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getusercommentlistTag"]) {
        [_collectionRecordView endRefreshing];
        
        NSDictionary *dict = (NSDictionary *)result;
        int pages = [dict[@"pageCount"] intValue];// 总页数
        _currentPage = [dict[@"offset"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        NSArray *models = [CarFriendCommentModel convertFromArray:result[@"data"]];
        
        // 过滤掉 “老司机” “推荐”
        NSMutableArray *filterArray = [[NSMutableArray alloc] init];
        for (CarFriendCommentModel *model in models) {
            if ([model.cmsCard.classifyName isEqualToString:@"公告"] ||
                [model.cmsCard.classifyName isEqualToString:@"随手拍"] ||
                [model.cmsCard.classifyName isEqualToString:@"问小畅"]) {
                [filterArray addObject:model];
            }
        }
        
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_collectionRecordView refreshDataSource:filterArray];
        } else {// 加载
            [_collectionRecordView addDataSource:filterArray page:_currentPage];
        }
        
        if (_currentPage >= pages) {
            // 删除加载提示
            [_collectionRecordView removeFooter];
        } else {
            [_collectionRecordView addFooter];
        }
    }
    
    if ([tag isEqualToString:@"operatinghourseTag"]) {
        [_collectionRecordView updateDeleteModel];
        [[NSNotificationCenter defaultCenter] postNotificationName:CarFriendDeleteNotificationName object:nil userInfo:nil];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getusercommentlistTag"]) {
        [_collectionRecordView endRefreshing];
        [_collectionRecordView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新的时候才能展示nil界面
            [_collectionRecordView refreshDataSource:nil];
        } else {// 加载
            [_collectionRecordView addDataSource:@[] page:_currentPage];
        }
        
        _currentPage--;
    }
}

#pragma mark - getter/setter

- (CCollectionRecordView *) collectionRecordView {
    if (!_collectionRecordView) {
        _collectionRecordView = [[CCollectionRecordView alloc] init];
        
        @weakify(self)
        [_collectionRecordView setRefreshNewsInfoDataListener:^ (BOOL isRequestFailure) {
            @strongify(self)
            
            if (isRequestFailure) {
                [self showHub];
            }
            
            self.currentPage = startPage - 1;
            [self getmyrecommendcardlist];
        }];
        
        [_collectionRecordView setLoadNewsInfoDataListener:^ {
            @strongify(self)
            
            [self getmyrecommendcardlist];
        }];
        
        [_collectionRecordView setShowCarFriendInfoListener:^ (id result) {\
            @strongify(self)
            CarFriendCommentModel *model = (CarFriendCommentModel *) result;
            
            CarFriendInfoViewController *controller = [[CarFriendInfoViewController alloc] init];
            controller.cardID = model.cardID;
            [self basePushViewController:controller];
        }];
        
        [_collectionRecordView setDeleteTopicListener:^ (id result) {
            @strongify(self)
            
            CarFriendCommentModel *model = (CarFriendCommentModel *) result;
            [self deleteTopic:model];
            
        }];
    }
    
    return _collectionRecordView;
}

- (void) getmyrecommendcardlist {
    // 请求下一页数据
    _currentPage++;
    [_carFriendRecordNetData getusercommentlistWithToken:self.loginModel.token
                                                  userId:self.loginModel.loginID
                                                    type:1 
                                             currentPage:_currentPage
                                                     tag:@"getusercommentlistTag"];
}

// 删除话题
- (void) deleteTopic:(CarFriendCommentModel *)model {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                        message:@"确认取消收藏该话题吗？"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self showHubWithLoadText:@"取消中..."];
        [self.carFriendRecordNetData operatinghourseWithToken:self.loginModel.token
                                                       userID:model.userID
                                                       cardID:model.cardID
                                                     recordID:model.commentID
                                                          tag:@"operatinghourseTag"];
    }];
    [controller addAction:cancelAction];
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
