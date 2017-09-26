//
//  EventMessageViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "EventMessageViewController.h"
#import "MessageCenterInfoViewController.h"
#import "CEventMessageView.h"
#import "MineNetData.h"
#import "MessageCenterModel.h"

@interface EventMessageViewController ()

@property (nonatomic, retain) MineNetData *mineNetData;
@property (nonatomic, assign) int currentPage;

@property (nonatomic, retain) CEventMessageView *eventMessageView;

@end

#define startPage 1

@implementation EventMessageViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提醒通知";
    
    [self.view addSubview:self.eventMessageView];
    [self.eventMessageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    // 当前页
    _currentPage = startPage - 1;
    // 必须在请求数据前，显示加载动画
    [self showHub];
    
    _mineNetData = [[MineNetData alloc] init];
    _mineNetData.delegate = self;
    // 进入则默认请求数据
    [self getMsgList];
    
    // 读了未读的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readMessage:) name:ReadMessageNotificationName object:nil];
}

- (void) readMessage:(NSNotification *)noti {
    NSString * messageID = noti.userInfo[@"messageID"];
    [self.eventMessageView reloadMessageCenterModel:messageID];
}

// 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getMsgListTag"]) {
        [_eventMessageView endRefreshing];
        [self hideHub];
        
        NSDictionary *dict = (NSDictionary *)result;
        int pages = [dict[@"pageCount"] intValue];// 总页数
        _currentPage = [dict[@"offset"] intValue];// 获取最新的当前页，重新联网后的请求就不会出错了
        NSArray<MessageCenterModel *> *models = [MessageCenterModel convertFromArray:dict[@"data"]];
        
        if (_currentPage <= startPage) {// 刷新
            _currentPage = startPage;// 因为网络请求失败了之后，_currentPage减1，则会出现小于startPage的情况
            [_eventMessageView refreshDataSource:models];
        } else {// 加载
            [_eventMessageView addDataSource:models page:_currentPage];
        }
        
        if (_currentPage >= pages) {
            // 删除加载提示
            [_eventMessageView removeFooter];
        } else {
            [_eventMessageView addFooter];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    
    if ([tag isEqualToString:@"getMsgListTag"]) {
        [self hideHub];
        [_eventMessageView endRefreshing];
        [_eventMessageView hideFooter];
        
        if (_currentPage <= startPage) {// 刷新
            [_eventMessageView refreshDataSource:nil];
        } else {// 加载
            [_eventMessageView addDataSource:@[] page:_currentPage];
        }
        
        _currentPage--;
    }
}

#pragma mark - getter/setter

- (CEventMessageView *) eventMessageView {
    if (!_eventMessageView) {
        _eventMessageView = [[CEventMessageView alloc] init];
        
        @weakify(self)
        [_eventMessageView setSelectEventMsgCellListener:^(id result) {
            @strongify(self);
            MessageCenterModel *model = (MessageCenterModel *)result;
            
            MessageCenterInfoViewController *controller = [[MessageCenterInfoViewController alloc] init];
            controller.messageID = model.messageID;
            controller.tag = Message_systemContent;
            controller.isUnreadMessage = ([model.read isEqualToString:@"1"] ? YES : NO);
            [self basePushViewController:controller];
        }];
        
        [_eventMessageView setRefreshEventMsgDataListener:^(BOOL isRequestFailure) {
            @strongify(self);
            
            // 点击刷新需要显示加载动画
            if (isRequestFailure) {
                [self showHub];
            }
            self.currentPage = startPage - 1;
            [self getMsgList];
        }];
        [_eventMessageView setLoadEventMsgDataListener:^{
            @strongify(self);
            [self getMsgList];
        }];
    }
    
    return _eventMessageView;
}

- (void) getMsgList {
    // 请求下一页数据
    _currentPage++;
    [_mineNetData getMsgListWithToken:self.loginModel.token
                               userId:self.loginModel.loginID
                                 type:@"1"
                               offset:_currentPage
                                  tag:@"getMsgListTag"];
}

@end
