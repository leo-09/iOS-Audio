//
//  RegisterViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "RegisterViewController.h"
#import "CRegisterView.h"
#import "SettingNetData.h"
#import "CTXWebViewController.h"
#import "AccountNetData.h"
#import "HWWeakTimer.h"
#import "LoginInfoLocalData.h"

@interface RegisterViewController ()

@property (nonatomic, retain) CRegisterView *registerView;

@property (nonatomic, retain) SettingNetData *settingNetData;
@property (nonatomic, retain) AccountNetData *accountNetData;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeCount = 121;// 倒计时120秒
    
    [self.view addSubview:self.registerView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.settingNetData = [[SettingNetData alloc] init];
    self.settingNetData.delegate = self;
    
    self.accountNetData = [[AccountNetData alloc] init];
    self.accountNetData.delegate = self;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.settingNetData.delegate = nil;
    self.settingNetData = nil;
    
    self.accountNetData.delegate = nil;
    self.accountNetData = nil;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:NO];
    
    [self invalidate];
}

- (BOOL) gestureRecognizerShouldBegin {
    return NO;  // 关闭侧滑
}

#pragma mark - getter/setter

- (CRegisterView *) registerView {
    if (!_registerView) {
        _registerView = [[CRegisterView alloc] initWithMyFrame:self.view.bounds isRegister:YES];
        
        @weakify(self)
        [_registerView setBackListener:^{
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [_registerView setLoginListener:^{
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [_registerView setShowProtocolListener:^{
            @strongify(self)
            // 用户协议
            CTXWebViewController *controller = [[CTXWebViewController alloc] init];
            controller.naviTitle = @"用户协议";
            controller.address = @"userProtocol";
            [self basePushViewController:controller];
        }];
        [_registerView setGainCodeListener:^(id result) {
            @strongify(self)
            [self showHubWithLoadText:@"获取验证码..."];
            [self.settingNetData captchaSendWithPhone:(NSString *)result msgType:@"REGISTER" tag:@"captchaSendTag"];
        }];
        [_registerView setRegisterListener:^(NSString *phone, NSString *code, NSString *psw){
            @strongify(self)
            
            self.account = phone;
            self.psw = psw;
            
            [self showHubWithLoadText:@"注册中..."];
            [self.accountNetData registerWithPhone:phone passsword:psw verify:code tag:@"registerTag"];
        }];
    }
    
    return _registerView;
}

- (void) updateTimer {
    self.timeCount--;
    
    if (self.timeCount <= 0) {
        [self.registerView updateGainCodeBtnWithTitle:@"获取验证码" backgroundColor:UIColorFromRGB(CTXThemeColor) isEnabled:YES];
        
        [self invalidate];
    } else {
        NSString *title = [NSString stringWithFormat:@"%d秒", self.timeCount];
        [self.registerView updateGainCodeBtnWithTitle:title backgroundColor:UIColorFromRGBA(0x000000, 0.5) isEnabled:NO];
    }
}

- (void) invalidate {
    if (self.timer) {
        self.timeCount = 121;
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"captchaSendTag"]) {
        // 倒计时
        self.timer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
    
    if ([tag isEqualToString:@"registerTag"]) {
        [self showTextHubWithContent:tint];
        
        // 保存最新账户信息
        [self updateLoginModelWithResult:(NSDictionary *)result];
        // 保存新帐号
        [[LoginInfoLocalData sharedInstance] saveAccount:self.account psw:self.psw];
        
        [self showTextHubWithContent:@"注册完成"];
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RegisterNotificationName object:nil userInfo:nil];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    [self showTextHubWithContent:tint];
}

@end
