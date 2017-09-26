//
//  MineViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "MineViewController.h"
#import "SettingViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "CTXSegmentedPagerViewController.h"
#import "CTXRecordPagerViewController.h"
#import "CarFriendRecordViewController.h"
#import "WalletViewController.h"
#import "GarageViewController.h"
#import "PrideViewController.h"
#import "CarSubscribeRecordViewController.h"
#import "CarFreeInspectRecordViewController.h"
#import "CarAgencyRecordViewController.h"
#import "ParkingRecordViewController.h"
#import "AccountViewController.h"
#import "SignViewController.h"

@implementation MineViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"MineViewController"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat height = CTXScreenHeight - 64 - CTXTabBarHeight + 1;
    if (height < 615) {
        self.contentViewHeightConstraint.constant = 615;
    } else {
        self.contentViewHeightConstraint.constant = height;
    }
    
    [self mineClickLisnener];
    [self updateAccountInfo];
    
    // 发送通知： 登录或者退出需要发送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAccountInfo) name:LoginNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAccountInfo) name:LogoffNotificationName object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.parentViewController.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.parentViewController.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - private method

- (void) updateAccountInfo {
    // 更新信息
    self.mobileLabel.text = self.loginModel.phone;
    
//    self.headerBtn setImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
}

#pragma mark - event response

// 用户信息
- (IBAction)userInfo:(id)sender {
    if (!self.loginModel.token) {
        [self loginFirstWithBlock:^(id newToken) {
            [self userInfo:nil];
        }];
    } else {
        AccountViewController *controller = [[AccountViewController alloc] initWithStoryboard];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

// 列表事件
- (void) mineClickLisnener {
    // 每日签到
    self.signView.alphaCount = 0.0;
    [self.signView setDefaultColor:0xFFFFFF];
    [self.signView setClickListener:^(id result) {
        if (!self.loginModel.token) {
            [self loginFirstWithBlock:^(id newToken) {
                self.signView.clickListener(result);
            }];
        } else {
            SignViewController *controller = [[SignViewController alloc] init];
            [self basePushViewController:controller];
        }
    }];
    
    // 我的车库
    [self.garageView setClickListener:^(id sender) {
        if (!self.loginModel.token) {
            [self loginFirstWithBlock:^(id newToken) {
                self.garageView.clickListener(sender);
            }];
        } else {
            GarageViewController *controller = [[GarageViewController alloc] init];
            [self basePushViewController:controller];
        }
    }];
    
    // 我的服务
    [self.serveView setClickListener:^(id sender) {
        if (!self.loginModel.token) {
            [self loginFirstWithBlock:^(id newToken) {
                self.serveView.clickListener(sender);
            }];
        } else {
            [self toServiceRecord];
        }
    }];
    
    // 我的上报
    [self.reportView setClickListener:^(id sender) {
        if (!self.loginModel.token) {
            [self loginFirstWithBlock:^(id newToken) {
                self.reportView.clickListener(sender);
            }];
        } else {
            CarFriendRecordViewController *controller = [[CarFriendRecordViewController alloc] initWithStoryboard];
            [self basePushViewController:controller];
        }
    }];
    
    // 我的钱包
    [self.walletView setClickListener:^(id sender) {
        if (!self.loginModel.token) {
            [self loginFirstWithBlock:^(id newToken) {
                self.walletView.clickListener(sender);
            }];
        } else {
            WalletViewController *controller = [[WalletViewController alloc] initWithStoryboard];
            [self basePushViewController:controller];
        }
    }];
    
    // 我的奖品
    [self.prideView setClickListener:^(id sender) {
        if (!self.loginModel.token) {
            [self loginFirstWithBlock:^(id newToken) {
                self.prideView.clickListener(sender);
            }];
        } else {
            CTXSegmentedPagerViewController *controller = [[CTXSegmentedPagerViewController alloc] init];
            controller.title = @"我的奖品";
            
            // 添加ViewController集合
            NSMutableArray *pages = [NSMutableArray new];
            
            PrideViewController *unclaimedController = [[PrideViewController alloc] init];
            unclaimedController.viewTitle = @"未领取";
            [pages addObject:unclaimedController];
            
            PrideViewController *receivedController = [[PrideViewController alloc] init];
            receivedController.viewTitle = @"已领取";
            [pages addObject:receivedController];
            
            PrideViewController *expiredController = [[PrideViewController alloc] init];
            expiredController.viewTitle = @"已过期";
            [pages addObject:expiredController];
            
            [controller setPages:pages];
            
            [self basePushViewController:controller];
        }
    }];
    
    // 分享
    [self.shareView setClickListener:^(id sender) {
        // 分享好友：显示分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [self shareWebPageToPlatformType:platformType];
        }];
    }];
    
    // 设置
    [self.settingView setClickListener:^(id sender) {
        SettingViewController *controller = [[SettingViewController alloc] initWithStoryboard];
        [self basePushViewController:controller];
    }];
}

// 全部服务
- (void) toServiceRecord {
    CTXRecordPagerViewController *controller = [[CTXRecordPagerViewController alloc] init];
    controller.title = @"全部服务";
    
    // 添加ViewController集合
    NSMutableArray *pages = [NSMutableArray new];
    
    CarSubscribeRecordViewController *subscribeController = [[CarSubscribeRecordViewController alloc] init];
    subscribeController.viewTitle = @"车检预约";
    [pages addObject:subscribeController];
    
    CarFreeInspectRecordViewController *inspectController = [[CarFreeInspectRecordViewController alloc] init];
    inspectController.viewTitle = @"六年免检";
    [pages addObject:inspectController];
    
    CarAgencyRecordViewController *agencyController = [[CarAgencyRecordViewController alloc] init];
    agencyController.viewTitle = @"车检代办";
    [pages addObject:agencyController];
    
    ParkingRecordViewController *parkingController = [[ParkingRecordViewController alloc] init];
    parkingController.viewTitle = @"停车记录";
    [pages addObject:parkingController];
    
    [controller setPages:pages];
    
    [self basePushViewController:controller];
}

#pragma mark - 分享

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    // 创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    // 创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"畅行安徽，你的车主管家"
                                                                             descr:@"查违章、缴罚款、车检预约，安徽车主都在用，快来下载"
                                                                         thumImage:[UIImage imageNamed:@"app_logo"]];
    // 设置网页地址
    shareObject.webpageUrl = @"http://www.ah122.cn/App/appdownload.html";
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
