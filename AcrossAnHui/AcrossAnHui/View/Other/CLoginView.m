//
//  LoginView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CLoginView.h"

@implementation CLoginView

- (instancetype) initWithMyFrame:(CGRect)frame {
    NSArray* nibArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self = [nibArray objectAtIndex:0];
    if (self) {
        [self setFrame:frame];
        [self setView];
    }
    
    return self;
}

- (void) setAccount:(NSString *) account password:(NSString *)password {
    BOOL isValue = YES;
    
    if (account && ![account isEqualToString:@""]) {
        self.accountTextField.text = account;
    } else {
        isValue = NO;
    }
    if (password && ![password isEqualToString:@""]) {
        self.pswTextField.text = password;
    } else {
        isValue = NO;
    }
    
    if (isValue) {
        _loginBtn.backgroundColor = UIColorFromRGBA(CTXThemeColor, 1);
    }
}

#pragma mark - private mehod

- (void) setView {
    _contentViewHeightConstraint.constant = self.frame.size.height + 1;
    
    // _loginBtn
    CTXViewBorderRadius(_loginBtn, 5, 0, [UIColor clearColor]);
    _loginBtn.backgroundColor = UIColorFromRGBA(CTXThemeColor, 0.5);
    
    // 监听TextField的输入
    [_accountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_pswTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void) textFieldDidChange:(UITextField *)theTextField {
    if (![_accountTextField.text isEqualToString:@""] && ![_pswTextField.text isEqualToString:@""]) {
        _loginBtn.backgroundColor = UIColorFromRGBA(CTXThemeColor, 1);
    } else {
        _loginBtn.backgroundColor = UIColorFromRGBA(CTXThemeColor, 0.5);
    }
}

#pragma mark - event response

- (IBAction)loginBack:(id)sender {
    if (self.backListener) {
        self.backListener();
    }
}

- (IBAction)registerAtNow:(id)sender {
    if (_registerListener) {
        _registerListener();
    }
}

- (IBAction)forgetPassword:(id)sender {
    if (_forgetPasswordistener) {
        _forgetPasswordistener();
    }
}

- (IBAction)login:(id)sender {
    [_accountTextField resignFirstResponder];
    [_pswTextField resignFirstResponder];
    
    NSString *account = _accountTextField.text;
    NSString *psw = _pswTextField.text;
    
    if ([account isEqualToString:@""]) {
        [self showTextHubWithContent:@"请输入帐号"];
        return;
    }
    
    if ([psw isEqualToString:@""]) {
        [self showTextHubWithContent:@"请输入密码"];
        return;
    }
    
    if (_loginListener) {
        _loginListener(account, psw);
    }
}

@end
