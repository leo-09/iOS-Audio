//
//  ModifyPasswordViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "LoginInfoLocalData.h"
#import "DES3Util.h"

@implementation ModifyPasswordViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Setting" bundle:nil] instantiateViewControllerWithIdentifier:@"ModifyPasswordViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改密码";
    CTXViewBorderRadius(_saveLabel, 5.0, 0, [UIColor clearColor]);
    
    self.settingNetData = [[SettingNetData alloc] init];
    self.settingNetData.delegate = self;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {// 确认保存
        [self.oldPswTextField resignFirstResponder];
        [self.pswTextField1 resignFirstResponder];
        [self.pswTextField2 resignFirstResponder];
        
        NSString *oldPsw = self.oldPswTextField.text;
        newPassword = self.pswTextField1.text;
        NSString *newPsw2 = self.pswTextField2.text;
        
        if ([oldPsw isEqualToString:@""]) {
            [self showTextHubWithContent:@"请输入原密码"];
            return;
        }
        
        if ([newPassword isEqualToString:@""]) {
            [self showTextHubWithContent:@"请输入新密码"];
            return;
        }
        
        if ([newPsw2 isEqualToString:@""]) {
            [self showTextHubWithContent:@"请输入确认密码"];
            return;
        }
        
        if (newPassword.length < 6) {
            [self showTextHubWithContent:@"您输入的密码少于6位"];
            return;
        }
        
        if ([DES3Util checkIsHaveNumAndLetter:newPassword] != 3) {
            [self showTextHubWithContent:@"密码必须由数字和字母组成"];
            return;
        }
        
        if (![newPassword isEqualToString:newPsw2]) {
            [self showTextHubWithContent:@"两次输入的密码不一样"];
            return;
        }
        
        [self showHubWithLoadText:@"修改密码中..."];
        
        NSString *token = self.loginModel.token;
        [self.settingNetData updatePasswordWithToken:token oldPassword:oldPsw newPassword:newPassword tag:@"updatePasswordTag"];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"updatePasswordTag"]) {
        [self hideHub];
        
        // 保存最新密码
        [[LoginInfoLocalData sharedInstance] updateNewPassword:newPassword];
        
        [self showTextHubWithContent:@"密码修改完成"];
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
