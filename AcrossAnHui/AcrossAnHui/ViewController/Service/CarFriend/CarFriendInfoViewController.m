//
//  CarFriendInfoViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFriendInfoViewController.h"
#import "CCarFriendInfoView.h"
#import "CoreServeNetData.h"
#import "CarFriendCardModel.h"
#import "CarFriendUserCommentModel.h"
#import "FriendListViewController.h"
#import "CarFriendGoodResultModel.h"
#import "CarFriendDialogView.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

@interface CarFriendInfoViewController ()

@property (nonatomic, retain) CoreServeNetData *coreServeNetData;
@property (nonatomic, retain) CCarFriendInfoView *carFriendInfoView;

@property (nonatomic, retain) NSString *totalRecords;                   // 实际评论总数
@property (nonatomic, retain) CarFriendCardModel *currentModel;
@property (nonatomic, retain) CarFriendCardModel *goodCardModel;        // 点赞的对象
@property (nonatomic, retain) CarFriendCardModel *goodChangModel;       // 点赞的对象
@property (nonatomic, retain) CarFriendUserCommentModel *commentModel;  // 点赞回复的对象

@end

#define startPage 1

@implementation CarFriendInfoViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"话题内容";
    [self addRightBarButtonItem];
    
    [self.view addSubview:self.carFriendInfoView];
    [self.carFriendInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _coreServeNetData = [[CoreServeNetData alloc] init];
    _coreServeNetData.delegate = self;
    
    [self showHub];
    [self refreshData];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    CarFriendCardModel *model = _carFriendInfoView.model;
    [[NSNotificationCenter defaultCenter] postNotificationName:CarFriendInfoNotificationName object:model userInfo:nil];
}

- (void) addRightBarButtonItem {
    if (!self.navigationItem.rightBarButtonItem) {
        // rightBarButtonItem
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"caidan_d"] style:UIBarButtonItemStyleDone target:self action:@selector(menu)];
        [rightBarButtonItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
}

// 刷新数据
- (void) refreshData {
    _currentPage = startPage - 1;
    
    [self getmycarddetail];
    [self getmorecardcomment];
}

// 分享／收藏
- (void) menu {
    CarFriendDialogView *dialogView = [[CarFriendDialogView alloc] init];
    // 分享
    [dialogView setShareListener:^ {
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [self shareWebPageToPlatformType:platformType];
        }];
    }];
    // 收藏
    [dialogView setCollectionListener:^ {
        [_coreServeNetData operatinghourseWithToken:self.loginModel.token
                                             cardID:self.cardID
                                                tag:@"operatinghourseTag"];
    }];
    
    [dialogView showView];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [_carFriendInfoView endRefreshing];
    [self hideHub];
    
    if ([tag isEqualToString:@"getmycarddetailTag"]) {      // 帖子详情
        self.currentModel = [CarFriendCardModel convertFromDict:(NSDictionary *)result];
        if (self.totalRecords) {
            self.currentModel.commandCount = self.totalRecords;
        }
        
        _carFriendInfoView.model = self.currentModel;
        
        if (self.currentModel.cardID) {
            [self addRightBarButtonItem];
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
    if ([tag isEqualToString:@"getmorecardcommentTag"]) {   // 评论列表信息
        NSDictionary *dict = (NSDictionary *)result;
        
        // 更新评论总数
        self.totalRecords = dict[@"totalRecords"];
        if (self.currentModel) {
            self.currentModel.commandCount = self.totalRecords;
            _carFriendInfoView.model = self.currentModel;
        }
        
        int pages = [dict[@"pageCount"] intValue];// 总页数
        _currentPage = [dict[@"offset"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        NSArray *comments = [CarFriendUserCommentModel convertFromArray:dict[@"data"]];
        
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_carFriendInfoView refreshDataSource:comments];[self addRightBarButtonItem];
        } else {// 加载
            [_carFriendInfoView addDataSource:comments page:_currentPage];
        }
        
        if (_currentPage >= pages) {
            // 删除加载提示
            [_carFriendInfoView removeFooter];
        } else {
            [_carFriendInfoView addFooter];
        }
    }
    
    if ([tag isEqualToString:@"operatingpointlaudCardTag"]) {       // 点赞帖子
        // 当前小畅说的点赞数量
        CarFriendGoodResultModel *newModel = [CarFriendGoodResultModel convertFromDict:result];
        [_carFriendInfoView updateCardModel:self.goodCardModel withNewModel:newModel];
        
        self.goodCardModel = nil;// goodCardModel置nil，下次才可点击
    }
    
    if ([tag isEqualToString:@"operatingpointlaudChangTag"]) {      // 点赞小畅说
        // 当前小畅说的点赞数量
        CarFriendGoodResultModel *newModel = [CarFriendGoodResultModel convertFromDict:result];
        [_carFriendInfoView updateChangModel:self.goodChangModel withNewModel:newModel];
        
        self.goodChangModel = nil;// goodChangModel置nil，下次才可点击
    }
    
    if ([tag isEqualToString:@"operatingpointlaudCommentTag"]) {    // 点赞回复
        // 当前回复的点赞数量
        CarFriendGoodResultModel *newModel = [CarFriendGoodResultModel convertFromDict:result];
        [_carFriendInfoView updateCommentModel:self.commentModel withNewModel:newModel];
        
        self.commentModel = nil;// commentModel置nil，下次才可点击
    }
    
    if ([tag isEqualToString:@"publishTag"]) {
        [_carFriendInfoView clearCommentContent];
        // 评论成功,则重新刷新数据
        [self refreshData];
        
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:CarFriendCommentNotificationName object:nil userInfo:nil];
    }
    
    if ([tag isEqualToString:@"operatinghourseTag"]) {
        [self showTextHubWithContent:@"收藏成功"];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getmycarddetailTag"]) {  // 帖子详情
        _carFriendInfoView.model = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if ([tag isEqualToString:@"getmorecardcommentTag"]) {   // 评论列表信息
        [_carFriendInfoView endRefreshing];
        [_carFriendInfoView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新的时候才能展示nil界面
            [_carFriendInfoView refreshDataSource:nil];
        } else {// 加载
            [_carFriendInfoView addDataSource:@[] page:_currentPage];
        }
        
        _currentPage--;
    }
    
    if ([tag isEqualToString:@"operatingpointlaudChangTag"]) {  // 点赞
        [_carFriendInfoView updateChangModel:self.goodChangModel withNewModel:nil];
        self.goodChangModel = nil;// goodChangModel置nil，下次才可点击
    }
    
    if ([tag isEqualToString:@"operatingpointlaudCardTag"]) {  // 点赞
        [_carFriendInfoView updateCardModel:self.goodCardModel withNewModel:nil];
        self.goodCardModel = nil;// goodCardModel置nil，下次才可点击
    }
    
    if ([tag isEqualToString:@"operatingpointlaudCommentTag"]) {
        [_carFriendInfoView updateCommentModel:self.commentModel withNewModel:nil];
        self.commentModel = nil;// commentModel置nil，下次才可点击
    }
}

#pragma mark - getter/setter

- (CCarFriendInfoView *) carFriendInfoView {
    if (!_carFriendInfoView) {
        _carFriendInfoView = [[CCarFriendInfoView alloc] init];
        _carFriendInfoView.userPhoto = self.loginModel.photo;
        
        @weakify(self)
        
        // 刷新
        [_carFriendInfoView setRefreshCardListener:^(BOOL isRequestFailure) {
            @strongify(self)
            
            if (isRequestFailure) {
                [self showHub];
            }
            
            [self refreshData];
        }];
        
        // 加载
        [_carFriendInfoView setLoadCardListener:^ {
            @strongify(self)
            [self getmorecardcomment];
        }];
        
        // 好友列表
        [_carFriendInfoView setShowFriendListListener:^(id result) {
            @strongify(self)
            
            FriendListViewController *controller = [[FriendListViewController alloc] init];
            controller.cardID = (NSString *) result;
            [self basePushViewController:controller];
        }];
        
        // 点赞帖子
        [_carFriendInfoView setClickGoodCardListener:^(id result) {
            @strongify(self)
            
            // 当前点赞对象还存在，说明网络请求没有完成，不允许不停点赞
            if (!self.goodCardModel) {
                self.goodCardModel = (CarFriendCardModel *)result;
                
                // 点赞接口
                [self.coreServeNetData operatingpointlaudWithToken:self.loginModel.token
                                                          laudType:0
                                                         operateID:self.goodCardModel.cardID
                                                       isRecommend:(self.goodCardModel.isRecommend ? @"1" : @"0")
                                                               tag:@"operatingpointlaudCardTag"];
            }
        }];
        
        // 点赞小畅说
        [_carFriendInfoView setClickGoodChangListener:^(id result) {
            @strongify(self)
            
            // 当前点赞对象还存在，说明网络请求没有完成，不允许不停点赞
            if (!self.goodChangModel) {
                self.goodChangModel = (CarFriendCardModel *)result;
                
                // 点赞接口
                [self.coreServeNetData operatingpointlaudWithToken:self.loginModel.token
                                                          laudType:2
                                                         operateID:self.goodChangModel.cardID
                                                       isRecommend:nil
                                                               tag:@"operatingpointlaudChangTag"];
            }
        }];
        
        // 点赞回复
        [_carFriendInfoView setClickGoodCommentListener:^(id result) {
            @strongify(self)
            
            if (!self.commentModel) {
                self.commentModel = (CarFriendUserCommentModel *) result;
                
                // 点赞接口
                [self.coreServeNetData operatingpointlaudWithToken:self.loginModel.token
                                                          laudType:1
                                                         operateID:self.commentModel.commontID
                                                       isRecommend:nil
                                                               tag:@"operatingpointlaudCommentTag"];
            }
        }];
        
        // 发表评论
        [_carFriendInfoView setSubmitCommentListener:^(id result, NSString *content) {
            @strongify(self)
            CarFriendCardModel *model = (CarFriendCardModel *)result;
            
            [self showHubWithLoadText:@"发表评论中..."];
            [self.coreServeNetData publishreplyWithToken:self.loginModel.token cardID:model.cardID contents:content tag:@"publishTag"];
        }];
    }
    
    return _carFriendInfoView;
}

// 帖子详情
- (void) getmycarddetail {
    [_coreServeNetData getmycarddetailWithToken:self.loginModel.token cardID:self.cardID tag:@"getmycarddetailTag"];
}

// 获取评论列表
- (void) getmorecardcomment {
    // 请求下一页数据
    _currentPage++;
    [_coreServeNetData getmorecardcommentWithToken:self.loginModel.token cardID:self.cardID currentPage:_currentPage tag:@"getmorecardcommentTag"];
}

#pragma mark - 分享

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    NSString *title = self.currentModel.title ? self.currentModel.title : @"车友详情";
    NSString *descr = self.currentModel.contents ? self.currentModel.contents : @"";
    
    // 创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    // 创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title
                                                                             descr:descr
                                                                         thumImage:[UIImage imageNamed:@"app_logo"]];
    // 设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@", CarFriend_SHARE_Url, self.cardID];
    // 分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    // 调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        } else {
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                // 分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                // 第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            } else {
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

@end
