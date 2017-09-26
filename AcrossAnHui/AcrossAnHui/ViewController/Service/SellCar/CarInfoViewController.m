//
//  CarInfoViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CarInfoViewController.h"
#import "SelectCarTypeViewController.h"
#import "SelectCityViewController.h"
#import "CTXWKWebViewController.h"
#import "TextViewContentTool.h"
#import "PickerSelectorView.h"
#import "ServiceNetData.h"
#import "CarTypeModel.h"
#import "DES3Util.h"
#import "DateTool.h"

@interface CarInfoViewController ()<UITextFieldDelegate>

@property (nonatomic, retain) ServiceNetData *serviceNetData;

@end

@implementation CarInfoViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"SellCar" bundle:nil] instantiateViewControllerWithIdentifier:@"CarInfoViewController"];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"车辆信息";
    CTXViewBorderRadius(_submitBtn, 5, 0, [UIColor clearColor]);
    [_agreeBtn setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
    [_agreeBtn setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateSelected];
    
    _kliTextField.delegate = self;
    _contactTextField.delegate = self;
    _phoneTextField.delegate = self;
    
    [self.contactTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _serviceNetData = [[ServiceNetData alloc] init];
    _serviceNetData.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSelectCity:) name:SelectCityNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSelectCarType:) name:SelectCarTypeNotificationName object:nil];
}

- (void) setSelectCity:(NSNotification *)noti {
    self.cityLabel.text = noti.userInfo[@"city"];
}

- (void) setSelectCarType:(NSNotification *)noti {
    CBModel *carBrandModel = (CBModel *) noti.userInfo[@"carBrandModel"];
    CBModel *carTypeModel = (CBModel *) noti.userInfo[@"carTypeModel"];
    
    self.carTypeLabel.text = [NSString stringWithFormat:@"%@ %@", carBrandModel.name, carTypeModel.name];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {// 车辆类型
        SelectCarTypeViewController *controller = [[SelectCarTypeViewController alloc] init];
        [self basePushViewController:controller];
    }
    if (indexPath.row == 2) {// 首次上牌
        [self addSelectTimeView];
    }
    if (indexPath.row == 4) {// 所在城市
        SelectCityViewController *controller = [[SelectCityViewController alloc] init];
        controller.selectedCity = self.cityLabel.text;
        [self basePushViewController:controller];
    }
}

#pragma mark - 显示子view

- (void) addSelectTimeView {
    PickerSelectorView *pickerView = [[PickerSelectorView alloc] init];
    
    NSMutableArray *years = [[NSMutableArray alloc] init];
    for (int i = 1970; i <= [[DateTool sharedInstance] getCurrentYear]; i++) {
        [years addObject:[NSString stringWithFormat:@"%d年", i]];
    }
    
    NSArray *months = @[ @"01月", @"02月", @"03月", @"04月", @"05月", @"06月",
                        @"07月", @"08月", @"09月", @"10月", @"11月", @"12月" ];
    
    pickerView.dataSource = @[ years, months ];
    if ([self.carTimeLabel.text isEqualToString:@""]) {
        [pickerView setCurrentValue:@[ @"2015年", @"06月"]];
    } else {
        NSString *year = [self.carTimeLabel.text substringToIndex:5];
        NSString *month = [self.carTimeLabel.text substringWithRange:NSMakeRange(5, 3)];
        [pickerView setCurrentValue:@[ year, month]];
    }
    
    [pickerView setSelectorResultListener:^(id result) {
        NSArray *arr = (NSArray *)result;
        self.carTimeLabel.text = [arr componentsJoinedByString:@""];
    }];
    
    [pickerView showView];
}

#pragma mark - event response

// 畅行安徽二手车联盟商家
- (IBAction)protocolListener:(id)sender {
    CTXWKWebViewController *controller = [[CTXWKWebViewController alloc] init];
    controller.name = @"二手车联盟商家";
    controller.url = @"http://weixin.ah122.cn/sellCar/lmsj";
    controller.desc = nil;
    [self basePushViewController:controller];
}

// 同意将爱车信息提交到
- (IBAction)agreeListener:(id)sender {
    [self myResignFirstResponder];
    
    self.agreeBtn.selected = !self.agreeBtn.selected;
    
    if (self.agreeBtn.selected) {
        self.submitBtn.backgroundColor = UIColorFromRGB(CTXThemeColor);
        self.submitBtn.enabled = YES;
    } else {
        self.submitBtn.backgroundColor = UIColorFromRGB(0x999999);
        self.submitBtn.enabled = NO;
    }
}

// 提交申请
- (IBAction)submit:(id)sender {
    [self myResignFirstResponder];
    
    NSString *carType = self.carTypeLabel.text;
    if ([carType isEqualToString:@""]) {
        [self showTextHubWithContent:@"请选择车辆类型"];
        return;
    }
    
    NSString *carTime = self.carTimeLabel.text;
    if ([carTime isEqualToString:@""]) {
        [self showTextHubWithContent:@"请选择上牌时间"];
        return;
    }
    
    NSString *kliText = self.kliTextField.text;
    if ([kliText isEqualToString:@""]) {
        [self showTextHubWithContent:@"请填写行驶路程"];
        return;
    }
    
    if (![TextViewContentTool isDoubleNumber:kliText]) {
        [self showTextHubWithContent:@"请填写正确的行驶路程"];
        return;
    }
    
    NSString *city = self.cityLabel.text;
    if ([city isEqualToString:@""]) {
        [self showTextHubWithContent:@"请选择所在城市"];
        return;
    }
    
    NSString *contact = self.contactTextField.text;
    if ([contact isEqualToString:@""]) {
        [self showTextHubWithContent:@"请填写联系人"];
        return;
    }
    
    NSString *phone = self.phoneTextField.text;
    if (![DES3Util isMobileNumber:phone]) {
        [self showTextHubWithContent:@"请填写正确的手机号"];
        return;
    }
    
    if (!self.agreeBtn.selected) {
        [self showTextHubWithContent:@"请阅读并同意协议"];
        return;
    }
    
    NSString *year = [carTime substringToIndex:4];
    NSString *month = [carTime substringWithRange:NSMakeRange(5, 2)];
    NSString *time = [NSString stringWithFormat:@"%@-%@", year, month];
    
    [self showHubWithLoadText:@"提交申请中"];
    
    NSString *token = self.loginModel.token;
    [_serviceNetData saveAppSellInfoWithToken:token carType:carType carTime:time mileage:kliText
                                         city:city name:contact phone:phone tag:@"saveAppSellInfoTag"];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"saveAppSellInfoTag"]) {
        [self showTextHubWithContent:@"您的卖车申请已提交"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

- (void) myResignFirstResponder {
    [self.kliTextField resignFirstResponder];
    [self.contactTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}

#pragma mark - private method

- (void)textFieldDidChange:(UITextField *)textField {
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

@end
