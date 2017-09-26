//
//  SubscribeEventViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SubscribeEventViewController.h"
#import "CoreServeNetData.h"
#import "EventDetailViewController.h"
#import "TimeRemindViewController.h"
#import "UseInfoLocalData.h"

@interface SubscribeEventViewController()

@property (nonatomic, retain) CoreServeNetData *coreServeNetData;

@end

@implementation SubscribeEventViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"CarFriendTraffic" bundle:nil] instantiateViewControllerWithIdentifier:@"SubscribeEventViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订阅";
    [self showHub];
    
    _coreServeNetData = [[CoreServeNetData alloc] init];
    _coreServeNetData.delegate = self;
    
    [self bindingJpushUrl];
    // 获取开关状态
    [_coreServeNetData getJpushStateWithToken:self.loginModel.token userId:self.loginModel.loginID tag:@"getJpushStateTag"];
    
    // 订阅成功，开启事件订阅开关
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openEvent) name:AddEventNotificationName object:nil];
    // 编辑／添加路况的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openTimeRemind) name:TimeRemindNotificationName object:nil];
}

- (void) openEvent {
    if (!_eventSwitch.isOn) {
        _eventSwitch.on = YES;
        [self eventSwitch:nil];
    }
}

- (void) openTimeRemind {
    if (!_timeSwitch.isOn) {
        _timeSwitch.on = YES;
        [self timeSwitch:nil];
    }
}

// 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {// 事件订阅
        EventDetailViewController *controller = [[EventDetailViewController alloc] init];
        [self basePushViewController:controller];
    } else if (indexPath.row == 2) {// 时间提醒
        TimeRemindViewController *controller = [[TimeRemindViewController alloc] init];
        [self basePushViewController:controller];
    }
}

- (IBAction)eventSwitch:(id)sender {
    if ([[UseInfoLocalData sharedInstance] isJPushBindSuccess]) {
        if (_eventSwitch.isOn) {
            [self showHubWithLoadText:@"开启事件订阅推送"];
        } else {
            [self showHubWithLoadText:@"关闭事件订阅推送"];
        }
        
        [_coreServeNetData updateJpushStateWithToken:self.loginModel.token eventState:_eventSwitch.isOn raodState:_timeSwitch.isOn tag:@"updateJpushStateTag"];
    } else {
        [self showTextHubWithContent:@"绑定推送服务异常,请稍后重试"];
        _eventSwitch.on = !_eventSwitch.on;
    }
}

- (IBAction)timeSwitch:(id)sender {
    if ([[UseInfoLocalData sharedInstance] isJPushBindSuccess]) {
        if (_timeSwitch.isOn) {
            [self showHubWithLoadText:@"开启时间提醒推送"];
        } else {
            [self showHubWithLoadText:@"关闭时间提醒推送"];
        }
        
        [_coreServeNetData updateJpushStateWithToken:self.loginModel.token eventState:_eventSwitch.isOn raodState:_timeSwitch.isOn tag:@"updateJpushStateTag"];
    } else {
        [self showTextHubWithContent:@"绑定推送服务异常,请稍后重试"];
        _timeSwitch.on = !_timeSwitch.on;
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"getJpushStateTag"]) {
        if ([result[@"eventState"] intValue] == 1) {
            [_eventSwitch setOn:YES];;
        } else {
            [_eventSwitch setOn:NO];
        }
        
        if ([result[@"roadState"] intValue] == 1) {
            [_timeSwitch setOn:YES];
        } else {
            [_timeSwitch setOn:NO];
        }
    }
    
    if ([tag isEqualToString:@"updateJpushStateTag"]) {
        [self showTextHubWithContent:@"更新成功"];
    }
    
    if ([tag isEqualToString:@"bindingJpushUrlTag"]) {
        [[UseInfoLocalData sharedInstance] setJPushBindSuccess];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    [self showTextHubWithContent:tint];
    
    if ([tag isEqualToString:@"bindingJpushUrlTag"]) {
        [self bindingJpushUrl];
    }
}

// 绑定极光
- (void) bindingJpushUrl {
    // 绑定极光不成功，则重新绑定极光
    if (![[UseInfoLocalData sharedInstance] isJPushBindSuccess]) {
        [_coreServeNetData bindingJpushUrlWithToken:self.loginModel.token tag:@"bindingJpushUrlTag"];
    }
}

@end
