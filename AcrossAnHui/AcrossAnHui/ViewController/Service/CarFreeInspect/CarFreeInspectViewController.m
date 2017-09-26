//
//  CarFreeInspectViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarFreeInspectViewController.h"
#import "CarFreeInspectAddressViewController.h"
#import "CarFreeInspectPayViewController.h"
#import "PayResultViewController.h"
#import "CarInspectNetData.h"
#import "SubscribeModel.h"
#import "AreaModel.h"

@interface CarFreeInspectViewController () {
    BOOL isShunFeng;// 邮寄方式：是否顺丰
}

@property (nonatomic, retain) CarInspectNetData *carInspectNetData;

@property (nonatomic, retain) CarFreeInspectAddressModel *fetchAddressModel;
@property (nonatomic, retain) CarFreeInspectAddressModel *receiveAddressModel;

@property (nonatomic, copy) NSString *couponCodeID;

@end

@implementation CarFreeInspectViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"CarFreeInspect" bundle:nil] instantiateViewControllerWithIdentifier:@"CarFreeInspectViewController"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"六年免检";
    
    [_contactNameText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.fetchAddressText.enabled = NO;
    self.receiveAddressText.enabled = NO;
    [_addressBtn setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
    [_addressBtn setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateSelected];
    CTXViewBorderRadius(self.submitLabel, 5.0, 0, [UIColor clearColor]);
    
    // 计算typeCell上的dropDownMenu相对于tableView的frame
    CGRect frame = [self.typeCell convertRect:self.dropDownMenu.frame toView:self.view];
    NSArray *menuTitles = @[ @"顺丰" ];//@[ @"顺丰", @"邮政" ];
    [self.dropDownMenu setMenuTitles:menuTitles rowHeight:30 superView:self.view convertRect:frame];
    self.dropDownMenu.delegate = self;
    isShunFeng = YES;// 默认是顺风
    
    if (self.loginModel.phone) {
        self.contactPhoneText.text = self.loginModel.phone;
    }
    
    _carInspectNetData = [[CarInspectNetData alloc] init];
    _carInspectNetData.delegate = self;
    
    // 输入的限制 (非中文，字母大写)
    self.codeTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.codeTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;//所有字母都大写;
    
    // 通知获得 选择的取件地址
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCarInspectAddressModel:) name:SelectAddressNotificationName object:nil];
}

- (void) getCarInspectAddressModel:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    
    if ([userInfo[@"fetchAddress"] isEqualToString:@"fetchAddress"]) {// 取件地址
        self.fetchAddressModel = (CarFreeInspectAddressModel *) userInfo[@"model"];
        NSString *addr = [NSString stringWithFormat:@"%@%@%@", self.fetchAddressModel.currentCity.areaName, self.fetchAddressModel.currentTown.areaName, self.fetchAddressModel.addrInfo];
        
        self.fetchAddressText.text = addr;
        if (_addressBtn.selected) {
            self.receiveAddressText.text = self.fetchAddressText.text;
        }
    } else {
        self.receiveAddressModel = (CarFreeInspectAddressModel *) userInfo[@"model"];
        NSString *addr = [NSString stringWithFormat:@"%@%@%@", self.receiveAddressModel.currentCity.areaName, self.receiveAddressModel.currentTown.areaName, self.receiveAddressModel.addrInfo];
        
        self.receiveAddressText.text = addr;
        if (_addressBtn.selected) {
            self.fetchAddressText.text = self.receiveAddressText.text;
        }
    }
}

// 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 姓名不超过4个字
- (void) textFieldDidChange:(UITextField *)textField {
    // 联系人
    if (textField == _contactNameText) {
        NSInteger kMaxLength = 4;
        NSString *toBeString = textField.text;
        
        //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
        NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
        
        if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
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
    
    // 优惠码
    if (textField == _codeTextField) {
        if (_codeTextField.text.length == 8) {  // 优惠码是8位
            [_codeTextField resignFirstResponder];
            [_carInspectNetData isCouponCodeWithCouponCode:_codeTextField.text tag:@"isCouponCodeTag"];
        } else {
            self.couponCodeID = nil;
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row == 0) || indexPath.row == 10) {
        return 10;
    } else if ((indexPath.row == 1) || (indexPath.row == 2) || (indexPath.row == 3) ||
               (indexPath.row == 5) || (indexPath.row == 6) || (indexPath.row == 9)) {
        return 60;
    } else if (indexPath.row == 4) {
        return 35;
    } else if(indexPath.row == 11) {
        return 40;
    } else if (indexPath.row == 12) {
        if (isShunFeng) {// 保证按钮不被隐藏
            return 30;
        }  else {
            return 60;
        }
    } else {// row = 9／10
        if (isShunFeng) {
            return 0;
        }  else {
            return 60;
        }
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {// 上门取件地址
        CarFreeInspectAddressViewController *controller = [[CarFreeInspectAddressViewController alloc] init];
        controller.model = self.fetchAddressModel;
        controller.fetchAddress = @"fetchAddress";
        [self basePushViewController:controller];
    } else if (indexPath.row == 5) {// 收件地址
        CarFreeInspectAddressViewController *controller = [[CarFreeInspectAddressViewController alloc] init];
        controller.fetchAddress = @"receiveAddress";
        controller.model = self.receiveAddressModel;
        [self basePushViewController:controller];
    } else if (indexPath.row == 11) {// 立即申请
        [self apply];
    }
}

- (void) apply {
    if ([self.contactNameText.text isEqualToString:@""]) {
        [self showTextHubWithContent:@"请输入联系人姓名"];
        return;
    }
    
    if (![DES3Util isMobileNumber:self.contactPhoneText.text]) {
        [self showTextHubWithContent:@"请输入正确的手机号码"];
        return;
    }
    
    if ([self.fetchAddressText.text isEqualToString:@""]) {
        [self showTextHubWithContent:@"请选择上门取件地址"];
        return;
    }
    
    if ([self.receiveAddressText.text isEqualToString:@""]) {
        [self showTextHubWithContent:@"请选择收件地址"];
        return;
    }
    
    if (!isShunFeng) {
        if ([self.fetchCode.text isEqualToString:@""]) {
            [self showTextHubWithContent:@"请填写寄件编码"];
            return;
        }
        
        if ([self.receiveCode.text isEqualToString:@""]) {
            [self showTextHubWithContent:@"请填写取件编码"];
            return;
        }
    }
    
    if ((_codeTextField.text.length > 0) && !self.couponCodeID) {
        [self showTextHubWithContent:@"请检查优惠码是否填写正确"];
        return;
    }
    
    // 组织参数
    SaveSubscribeModel *model = [[SaveSubscribeModel alloc] init];
    [model setCarLisence:self.model.plateNumber];
    [model setLastFrame:self.model.frameNumber];
    [model setJdarea:self.fetchAddressModel.currentTown.areaid];
    [model setDetailAddr:self.fetchAddressText.text];
    [model setSjareaid:self.receiveAddressModel.currentTown.areaid];
    [model setSjDetailAdd:self.receiveAddressText.text];
    [model setContactPerson:self.contactNameText.text];
    [model setContactPhone:self.contactPhoneText.text];
    [model setCarType:self.model.plateType];
    [model setSubscribeDate:self.subscribeDate];
    [model setAvator:self.loginModel.photo];
    [model setPaymethod:@"0"];
    [model setBusinessType:@"2"];
    [model setCouponcodeid:self.couponCodeID];
    
    if (isShunFeng) {
        [model setPostCode:@""];
        [model setSjPostCode:@""];
        [model setExpressType:@"1"];
    } else {
        [model setPostCode:self.fetchCode.text];
        [model setSjPostCode:self.receiveCode.text];
        [model setExpressType:@"2"];
    }
    
    [self showHubWithLoadText:@"保存预约记录中..."];
    [_carInspectNetData saveSubscribeWithToken:self.loginModel.token
                                 subscribeMode:model
                                      cityName:self.fetchAddressModel.currentCity.areaName
                                           tag:@"saveSubscribeTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"isCouponCodeTag"]) {
        NSDictionary *dict = (NSDictionary *)result;
        self.couponCodeID = dict[@"id"];
    }
    
    if ([tag isEqualToString:@"saveSubscribeTag"]) {
        SubscribeModel *model = [SubscribeModel convertFromDict:(NSDictionary *)result];
        
        if (model.payfee <= 0) {
            // 支付金额不大于0，则订单完成，不需要支付，跳转到支付成功页面
            PayResultViewController *controller = [[PayResultViewController alloc] initWithStoryboard];
            controller.tag = ChannelPay_CarFreeInspect;
            controller.businessId = model.businessid;
            [self basePushViewController:controller];
        } else {
            // 跳转到支付界面
            CarFreeInspectPayViewController *controller = [[CarFreeInspectPayViewController alloc] initWithStoryboard];
            controller.model = model;
            [self basePushViewController:controller];
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self hideHub];
    [self showTextHubWithContent:tint];
}

#pragma mark - private method

- (IBAction)addressListener:(id)sender {
    if ([self.fetchAddressText isEqual:@""]) {
        [self showTextHubWithContent:@"请选择上门取件地址"];
        return;
    }
    
    _addressBtn.selected = !_addressBtn.selected;
    if (_addressBtn.selected) {
        self.receiveAddressText.text = self.fetchAddressText.text;
        self.receiveAddressModel = self.fetchAddressModel;
    }
}

// 选择邮寄方式，原来会显示 对应车检站的邮寄价格
- (void) setMoneyLabelText {
    if (!self.moneyLabel) {
        return;
    }
}

#pragma mark - LMJDropdownMenuDelegate

- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number {
    if (number == 0) {// 顺丰
        isShunFeng = YES;
    } else {
        isShunFeng = NO;
    }
    
    [self setMoneyLabelText];
    
    [self.tableView reloadData];
}

@end
