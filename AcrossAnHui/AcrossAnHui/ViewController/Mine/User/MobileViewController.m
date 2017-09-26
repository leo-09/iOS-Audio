//
//  MobileViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "MobileViewController.h"
#import "LoginInfoLocalData.h"
#import "DES3Util.h"
#import "HWWeakTimer.h"

@implementation MobileViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Setting" bundle:nil] instantiateViewControllerWithIdentifier:@"MobileViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeCount = 121;// 倒计时120秒
    
    self.navigationItem.title = @"修改手机号码";
    
    CTXViewBorderRadius(_codeBtn, 3.0, 0, [UIColor clearColor]);
    CTXViewBorderRadius(_modifyLabel, 5.0, 0, [UIColor clearColor]);
    
    self.settingNetData = [[SettingNetData alloc] init];
    self.settingNetData.delegate = self;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.timer) {
        self.timeCount = 121;
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void) dealloc {
    if (self.timer) {
        [self.timer invalidate];
        NSLog(@"%@ dealloc", NSStringFromClass([self class]));
        self.timer = nil;
    }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {// 确认修改
        [self.mobileTextField resignFirstResponder];
        [self.codeTextField resignFirstResponder];
        
        NSString *code = self.codeTextField.text;
        if ([code isEqualToString:@""]) {
            [self showTextHubWithContent:@"请输入验证码"];
            return;
        }
        
        [self showHubWithLoadText:@"修改手机号码..."];
        
        NSString *token = self.loginModel.token;
        [self.settingNetData updatePhoneWithToken:token phone:account verify:code tag:@"updatePhoneTag"];
    }
}

#pragma mark - event response

// 获取验证码
- (IBAction)getCode:(id)sender {
    [self.mobileTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    
    account = self.mobileTextField.text;
    if ([account isEqualToString:@""]) {
        [self showTextHubWithContent:@"请输入手机号码"];
        return;
    }
    if (![DES3Util isMobileNumber:account]) {
        [self showTextHubWithContent:@"手机号格式不正确"];
        return;
    }

    [self showHubWithLoadText:@"获取验证码..."];
    [self.settingNetData captchaSendWithPhone:account msgType:@"UPDATEPHONE" tag:@"captchaSendTag"];
}

- (void) updateTimer {
    self.timeCount--;
    
    if (self.timeCount <= 0) {
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeBtn.backgroundColor = UIColorFromRGB(CTXThemeColor);
        self.codeBtn.enabled = YES;
        
        self.timeCount = 121;
        // 停止当前的运行循环
        [self.timer invalidate];
        self.timer = nil;
    } else {
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%d秒", self.timeCount] forState:UIControlStateNormal];
        self.codeBtn.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        self.codeBtn.enabled = NO;
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
    
    if ([tag isEqualToString:@"updatePhoneTag"]) {
        // 保存最新账户信息
        [self updateLoginModelWithResult:(NSDictionary *)result];
        // 保存新帐号
        [[LoginInfoLocalData sharedInstance] updateNewAccount:account];
        
        // 通知帐号更新，即手机号
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotificationName object:nil userInfo:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    [self showTextHubWithContent:tint];
}

@end
