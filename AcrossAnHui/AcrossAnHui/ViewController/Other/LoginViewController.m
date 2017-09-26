//
//  LoginViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPasswordViewController.h"
#import "RegisterViewController.h"
#import "AccountNetData.h"
#import "CLoginView.h"
#import "LoginModel.h"
#import "LoginInfoLocalData.h"
#import "UseInfoLocalData.h"
#import "CoreServeNetData.h"

@interface LoginViewController ()

@property (nonatomic, retain) CLoginView *loginView;

@property (nonatomic, retain) AccountNetData *accountNetData;

@end

@implementation LoginViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.loginView];
    
    NSString *account = [[LoginInfoLocalData sharedInstance] getAccount];
    NSString *password = [[LoginInfoLocalData sharedInstance] getPassword];
    [_loginView setAccount:account password:password];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:RegisterNotificationName object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _accountNetData = [[AccountNetData alloc] init];
    _accountNetData.delegate = self;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _accountNetData.delegate = nil;
    _accountNetData = nil;

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:NO];
}

// 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) loginSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotificationName object:nil userInfo:nil];
    
    // 登录页消失
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 回调之前的操作
    if (self.loginSuccessBlock) {
        self.loginSuccessBlock(self.loginModel.token);
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    if ([tag isEqualToString:toLoginTag]) {
        [self showTextHubWithContent:tint];
        
        // 保存最新账户信息
        [self updateLoginModelWithResult:(NSDictionary *)result];
        // 保存帐号信息
        [[LoginInfoLocalData sharedInstance] saveAccount:self.account psw:self.psw];
        
        // 绑定极光
        CoreServeNetData *coreServeNetData = [[CoreServeNetData alloc] init];
        coreServeNetData.delegate = self;
        [coreServeNetData bindingJpushUrlWithToken:self.loginModel.token tag:@"bindingJpushUrlTag"];
    }
    
    if ([tag isEqualToString:@"bindingJpushUrlTag"]) {
        [self hideHub];
        
        [[UseInfoLocalData sharedInstance] setJPushBindSuccess];
        
        [self loginSuccess];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    [self hideHub];
    
    if (!tint || [tint isEqualToString:@""]) {
        tint = @"用户名或密码错误";
    }
    [self showTextHubWithContent:tint];
    
    if ([tag isEqualToString:@"bindingJpushUrlTag"]) {
        [self loginSuccess];
    }
}

#pragma mark - getter/setter

- (CLoginView *) loginView {
    if (!_loginView) {
        _loginView = [[CLoginView alloc] initWithMyFrame:self.view.bounds];
        
        @weakify(self);
        [_loginView setLoginListener:^(NSString *account, NSString *psw){
            @strongify(self)
            
            self.account = account;
            self.psw = psw;
            
            [self showHubWithLoadText:@"登录中..."];
            [self.accountNetData loginWithPhone:account passsword:psw tag:toLoginTag];
        }];
        [_loginView setForgetPasswordistener:^{
            @strongify(self)
            ForgetPasswordViewController *controller = [[ForgetPasswordViewController alloc] init];
            [self basePushViewController:controller];
        }];
        [_loginView setRegisterListener:^{
            @strongify(self)
            RegisterViewController *controller = [[RegisterViewController alloc] init];
            [self basePushViewController:controller];
        }];
        [_loginView setBackListener:^{
            @strongify(self)
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    
    return _loginView;
}

@end
