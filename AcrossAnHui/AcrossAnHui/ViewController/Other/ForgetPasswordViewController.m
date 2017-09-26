//
//  ForgetPasswordViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "CRegisterView.h"
#import "SettingNetData.h"
#import "AccountNetData.h"
#import "HWWeakTimer.h"
#import "LoginInfoLocalData.h"

@interface ForgetPasswordViewController ()

@property (nonatomic, retain) CRegisterView *forgetPswView;

@property (nonatomic, retain) SettingNetData *settingNetData;
@property (nonatomic, retain) AccountNetData *accountNetData;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeCount = 121;// 倒计时120秒
    
    [self.view addSubview:self.forgetPswView];
    
    self.settingNetData = [[SettingNetData alloc] init];
    self.settingNetData.delegate = self;
    
    self.accountNetData = [[AccountNetData alloc] init];
    self.accountNetData.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:NO];
    
    [self invalidate];
}

- (BOOL) gestureRecognizerShouldBegin {
    return NO;  // 关闭侧滑
}

#pragma mark - getter/setter

- (CRegisterView *) forgetPswView {
    if (!_forgetPswView) {
        _forgetPswView = [[CRegisterView alloc] initWithMyFrame:self.view.bounds isRegister:NO];
        
        @weakify(self)
        [_forgetPswView setBackListener:^{
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [_forgetPswView setGainCodeListener:^(id result) {
            @strongify(self)
            [self showHubWithLoadText:@"获取验证码..."];
            [self.settingNetData captchaSendWithPhone:(NSString *)result msgType:@"FORGETPWD" tag:@"captchaSendTag"];
        }];
        [_forgetPswView setRegisterListener:^(NSString *phone, NSString *code, NSString *psw){
            @strongify(self)
            
            self.account = phone;
            self.psw = psw;
            
            [self showHubWithLoadText:@"更新密码..."];
            [self.accountNetData forgetPasswordWithPhone:phone passsword:psw verify:code tag:@"forgetPasswordTag"];
        }];
    }
    
    return _forgetPswView;
}

- (void) updateTimer {
    self.timeCount--;
    
    if (self.timeCount <= 0) {
        [self.forgetPswView updateGainCodeBtnWithTitle:@"获取验证码" backgroundColor:UIColorFromRGB(CTXThemeColor) isEnabled:YES];
        
        [self invalidate];
    } else {
        NSString *title = [NSString stringWithFormat:@"%d秒", self.timeCount];
        [self.forgetPswView updateGainCodeBtnWithTitle:title backgroundColor:UIColorFromRGBA(0x000000, 0.5) isEnabled:NO];
    }
}

- (void) invalidate {
    if (self.timer) {
        // 停止当前的运行循环
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
    
    if ([tag isEqualToString:@"forgetPasswordTag"]) {
        [self showTextHubWithContent:tint];
        
        // 保存最新账户信息
        [self updateLoginModelWithResult:(NSDictionary *)result];
        // 保存新帐号
        [[LoginInfoLocalData sharedInstance] saveAccount:self.account psw:self.psw];
        
        [self showTextHubWithContent:@"密码修改完成"];
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
