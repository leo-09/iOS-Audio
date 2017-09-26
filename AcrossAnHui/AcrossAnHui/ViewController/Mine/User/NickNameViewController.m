//
//  NickNameViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/6/11.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "NickNameViewController.h"
#import "TextViewContentTool.h"

@implementation NickNameViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Setting" bundle:nil] instantiateViewControllerWithIdentifier:@"NickNameViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改昵称";
    CTXViewBorderRadius(_saveLabel, 5.0, 0, [UIColor clearColor]);
    
    self.settingNetData = [[SettingNetData alloc] init];
    self.settingNetData.delegate = self;
    
    [self.nickNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if (self.loginModel.loginName) {
        self.nickNameTextField.text = self.loginModel.loginName;
    }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {// 确认保存
        [self.nickNameTextField resignFirstResponder];
        
        NSString *content = [TextViewContentTool isContaintContent:self.nickNameTextField.text];
        if (!content) {
            [self showTextHubWithContent:@"请输入昵称"];
            return;
        }
        
        [self showHubWithLoadText:@"修改昵称中..."];
        [self.settingNetData updateUserWithToken:self.loginModel.token photo:nil gender:nil nickName:content tag:@"updateUserNickNameTag"];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    
    if ([tag isEqualToString:@"updateUserNickNameTag"]) {
        [self hideHub];
        
        // 保存最新账户信息
        [self updateLoginModelWithResult:(NSDictionary *)result];
        
        [self showTextHubWithContent:@"昵称修改完成"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    
    [self hideHub];
    [self showTextHubWithContent:tint];
}

#pragma mark - private method

- (void)textFieldDidChange:(UITextField *)textField {
    NSInteger kMaxLength = 10;
    NSString *toBeString = textField.text;
    
    //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        // 获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        } else {
            //有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
        //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}

@end
