//
//  MessageCenterViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MineNetData.h"
#import "EventMessageViewController.h"
#import "SystemMessageViewController.h"

@interface MessageCenterViewController ()

@property (nonatomic, retain) MineNetData *mineNetData;

@end

@implementation MessageCenterViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageCenterViewController"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息中心";
    
    CTXViewBorderRadius(_eventMsgLabel, 10, 0, [UIColor clearColor]);
    CTXViewBorderRadius(_sysMsgLabel, 10, 0, [UIColor clearColor]);
    _eventMsgLabel.hidden = YES;
    _sysMsgLabel.hidden = YES;
    
    _mineNetData = [[MineNetData alloc] init];
    _mineNetData.delegate = self;
    [self getMessageCount];
    
    // 推送消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageCount) name:PushMessageNotificationName object:nil];
}

// 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) getMessageCount {
    [_mineNetData getMsgCountWithToken:self.loginModel.token tag:@"getMsgCountTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"getMsgCountTag"]) {
        NSDictionary *dict = (NSDictionary *)result;
        int eventMsgCount = [dict[@"eventMsgCount"] intValue];
        int sysMsgCount = [dict[@"sysMsgCount"] intValue];
        
        if (eventMsgCount > 0) {
            _eventMsgLabel.text = [NSString stringWithFormat:@"%d", eventMsgCount];
            _eventMsgLabel.hidden = NO;
        } else {
            _eventMsgLabel.hidden = YES;
        }
        
        if (sysMsgCount > 0) {
            _sysMsgLabel.text = [NSString stringWithFormat:@"%d", sysMsgCount];;
            _sysMsgLabel.hidden = NO;
        } else {
            _sysMsgLabel.hidden = YES;
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {// 提醒通知
        EventMessageViewController *controller = [[EventMessageViewController alloc] init];
        [self basePushViewController:controller];
    } else if (indexPath.row == 2) {// 平台公告
        SystemMessageViewController *controller = [[SystemMessageViewController alloc] init];
        [self basePushViewController:controller];
    }
}

@end
