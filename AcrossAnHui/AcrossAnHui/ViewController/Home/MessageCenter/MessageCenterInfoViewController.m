//
//  MessageCenterInfoViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "MessageCenterInfoViewController.h"
#import "MineNetData.h"
#import "MessageContentModel.h"
#import "CMessageCenterInfoView.h"

@interface MessageCenterInfoViewController ()

@property (nonatomic, retain) MineNetData *mineNetData;

@property (nonatomic, retain) CMessageCenterInfoView *messageCenterInfoView;

@end

@implementation MessageCenterInfoViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息内容";
    [self.view addSubview:self.messageCenterInfoView];
    [self.messageCenterInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(CTXBarHeight + CTXNavigationBarHeight);
    }];
    
    _mineNetData = [[MineNetData alloc] init];
    _mineNetData.delegate = self;
    
    if (self.pushMsgDict) {
        MessageContentModel *model = [MessageContentModel convertFromDict:self.pushMsgDict];
        
        if (model.messageID) {
            self.messageID = model.messageID;
            [self clickRead];
        } else {
            _messageCenterInfoView.model = model;
        }
    } else {
        [self clickRead];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.isUnreadMessage) {
        NSDictionary *userInfo = @{@"messageID" : self.messageID};
        [[NSNotificationCenter defaultCenter] postNotificationName:ReadMessageNotificationName object:nil userInfo:userInfo];
        
        // 发送 ”推送“ 通知
        [[NSNotificationCenter defaultCenter] postNotificationName:PushMessageNotificationName object:self userInfo:nil];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"clickReadTag"]) {
        NSDictionary *dict = (NSDictionary *)result;
        MessageContentModel *model = [MessageContentModel convertFromDict:dict[@"info"]];
        _messageCenterInfoView.model = model;
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    [self showTextHubWithContent:tint];
    
    _messageCenterInfoView.model = nil;
}

#pragma mark - getter/setter
- (CMessageCenterInfoView *)messageCenterInfoView {
    if (!_messageCenterInfoView) {
        _messageCenterInfoView = [[CMessageCenterInfoView alloc] init];
    }
    
    return _messageCenterInfoView;
}

- (void) clickRead {
    [self showHub];
    [_mineNetData clickReadWithToken:self.loginModel.token type:self.tag msgID:self.messageID tag:@"clickReadTag"];
}

@end
