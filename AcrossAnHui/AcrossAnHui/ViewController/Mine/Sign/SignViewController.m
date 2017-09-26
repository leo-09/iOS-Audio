//
//  SignViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "SignViewController.h"
#import "LuckCenterViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "MineNetData.h"
#import "CSignView.h"
#import "SignModel.h"
#import "SignDialogView.h"

@interface SignViewController ()

@property (nonatomic, retain) SignModel *model;

@property (nonatomic, retain) MineNetData *mineNetData;
@property (nonatomic, retain) CSignView *signView;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.signView];
    [self.signView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.navigationItem.title = @"签到有奖";
    
    // rightBarButtonItem
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right_share"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    shareItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = shareItem;
    
    _mineNetData = [[MineNetData alloc] init];
    _mineNetData.delegate = self;
    
    [self showHub];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_mineNetData signInfoWithToken:self.loginModel.token userId:self.loginModel.loginID tag:@"signInfoTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    // 获取签到信息
    if ([tag isEqualToString:@"signInfoTag"]) {
        self.model = [SignModel convertFromDict:(NSDictionary *)result];
        self.signView.model = self.model;
    }
    
    if ([tag isEqualToString:@"userSignTag"]) {
        // 重设值
        SignList *sign = [[SignList alloc] init];
        sign.signDate = [NSString stringWithFormat:@"%@", result[@"curDate"]];
        [self.model.signList addObject:sign];
        self.model.isSign = YES;
        self.model.curMonthSignNum = [NSString stringWithFormat:@"%@", result[@"curMonthSignNum"]];
        self.model.curMonthSignTotalNum = [NSString stringWithFormat:@"%@", result[@"curMonthSignTotalNum"]];
        
        // 更新UI
        self.signView.model = self.model;
        
        // 弹框提醒
        SignDialogView *dialogView = [[SignDialogView alloc] init];
        NSString *title = [NSString stringWithFormat:@"本月已累计签到%lu天", (unsigned long)self.model.signList.count];
        [dialogView setTitle:title btnTitle:@"分享有惊喜"];
        [dialogView showViewWithSuperView:self.view];
        [dialogView setBottomBtnListener:^ {
            [self share];
        }];
    }
    
    if ([tag isEqualToString:@"shareWayTag"]) {
        // 分享成功 不需要提醒用户
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    
    [self showTextHubWithContent:tint];
}

#pragma mark - getter/setter

- (CSignView *) signView {
    if (!_signView) {
        _signView = [[CSignView alloc] init];
        
        @weakify(self)
        [_signView setSignListener:^ {
            @strongify(self)
            
            if (self.model.isSign) {
                SignDialogView *dialogView = [[SignDialogView alloc] init];
                [dialogView setTitle:@"您今日已签到，明天再来吧" btnTitle:@"知道了"];
                [dialogView showViewWithSuperView:self.view];
                [dialogView setBottomBtnListener:^ {
                    // nothing
                }];
            } else {
                [self showHubWithLoadText:@"签到中..."];
                [self.mineNetData userSignWithToken:self.loginModel.token tag:@"userSignTag"];
            }
        }];
        
        [_signView setPrideListener:^ {
            // 暂时没有活动
            @strongify(self)
            
            [self showTextHubWithContent:@"暂无活动"];
//            LuckCenterViewController *controller = [[LuckCenterViewController alloc] init];
//            [self basePushViewController:controller];
        }];
    }
    
    return _signView;
}

#pragma mark - 分享

- (void) share {
    // 分享
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType];
    }];
}

#pragma mark - 分享

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    // 创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    // 创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.shareTitle
                                                                             descr:self.model.shareContent
                                                                         thumImage:[UIImage imageNamed:@"app_logo"]];
    //设置网页地址
    shareObject.webpageUrl = self.model.shareLink;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"Share fail with error %@", error);
        } else {
            if ((platformType == UMSocialPlatformType_WechatSession) ||
                (platformType == UMSocialPlatformType_WechatTimeLine)) {
                // 微信相关分享
                [_mineNetData shareWayWithToken:self.loginModel.token state:@"1" tag:@"shareWayTag"];
            }else if((platformType == UMSocialPlatformType_QQ) ||
                     (platformType == UMSocialPlatformType_Qzone)){
                // QQ相关分享
                [_mineNetData shareWayWithToken:self.loginModel.token state:@"2" tag:@"shareWayTag"];
            }
        }
    }];
}

@end
