//
//  CRegisterView.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CRegisterView.h"
#import "DES3Util.h"

@implementation CRegisterView

- (instancetype) initWithMyFrame:(CGRect)frame isRegister:(BOOL)isRegister {
    NSArray* nibArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self = [nibArray objectAtIndex:0];
    if (self) {
        [self setFrame:frame];
        
        if (!isRegister) {
            self.protocolView.hidden = YES;
            self.registerBtnMarginTop.constant = 20;
            self.loginBtn.hidden = YES;
            [self.registerBtn setTitle:@"确定" forState:UIControlStateNormal];
        }
        
        [self setView];
    }
    
    return self;
}

- (void) updateGainCodeBtnWithTitle:(NSString *)title backgroundColor:(UIColor *)color isEnabled:(BOOL)enabled {
    [self.gainCodeBtn setTitle:title forState:UIControlStateNormal];
    self.gainCodeBtn.backgroundColor = color;
    self.gainCodeBtn.enabled = enabled;
}

#pragma mark - private mehod

- (void) setView {
    _contentViewHeightConstraint.constant = self.frame.size.height + 1;
    
    CTXViewBorderRadius(_registerBtn, 5, 0, [UIColor clearColor]);
    CTXViewBorderRadius(_gainCodeBtn, 3, 0, [UIColor clearColor]);
    
    [self.selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"not_select"] forState:UIControlStateSelected];
}

#pragma mark - event response

- (IBAction)registerBack:(id)sender {
    if (self.backListener) {
        self.backListener();
    }
}

- (IBAction)gainCode:(id)sender {
    [self textFieldResignFirstResponder];
    
    NSString *phone = self.phoneTextField.text;
    if ([phone isEqualToString:@""]) {
        [self showTextHubWithContent:@"请输入手机号码"];
        return;
    }
    if (![DES3Util isMobileNumber:phone]) {
        [self showTextHubWithContent:@"手机号格式不正确"];
        return;
    }
    
    if (self.gainCodeListener) {
        self.gainCodeListener(phone);
    }
}

- (IBAction)selectProtocol:(id)sender {
    self.selectBtn.selected = !self.selectBtn.selected;
    // _registerBtn
    if (!self.selectBtn.selected) {
        _registerBtn.enabled = YES;
        _registerBtn.backgroundColor = UIColorFromRGBA(CTXThemeColor, 1.0);
    } else {
        _registerBtn.enabled = NO;
        _registerBtn.backgroundColor = UIColorFromRGBA(CTXThemeColor, 0.5);
    }
}

- (IBAction)protocolBtn:(id)sender {
    if (self.showProtocolListener) {
        self.showProtocolListener();
    }
}

- (IBAction)registerAccount:(id)sender {
    [self textFieldResignFirstResponder];
    
    NSString *phone = _phoneTextField.text;
    NSString *code =_codeTextField.text;
    NSString *psw1 =_pswTextField1.text;
    NSString *psw2 =_pswTextField2.text;
    
    if ([phone isEqualToString:@""]) {
        [self showTextHubWithContent:@"请输入手机号码"];
        return;
    }
    
    if ([code isEqualToString:@""]) {
        [self showTextHubWithContent:@"请输入验证码"];
        return;
    }
    
    if (psw1.length < 6) {
        [self showTextHubWithContent:@"您输入的密码少于6位"];
        return;
    }
    
    if (psw2.length < 6) {
        [self showTextHubWithContent:@"请输入确认密码"];
        return;
    }
    
    if ([DES3Util checkIsHaveNumAndLetter:psw1] != 3) {
        [self showTextHubWithContent:@"密码必须由数字和字母组成"];
        return;
    }
    
    if (![psw1 isEqualToString:psw2]) {
        [self showTextHubWithContent:@"两次输入的密码不一样"];
        return;
    }
    
    if (self.registerListener) {
        self.registerListener(phone, code, psw1);
    }
}

- (IBAction)loginAtNow:(id)sender {
    if (self.loginListener) {
        self.loginListener();
    }
}

#pragma mark - private method

- (void) textFieldResignFirstResponder {
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.pswTextField1 resignFirstResponder];
    [self.pswTextField2 resignFirstResponder];
}

@end
