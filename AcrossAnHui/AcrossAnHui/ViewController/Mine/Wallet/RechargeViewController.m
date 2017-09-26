//
//  RechargeViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "RechargeViewController.h"
#import "ParkingBalanceModel.h"
#import "CarInspectRecordNetData.h"
#import "WalletNetData.h"
#import "TextViewContentTool.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface RechargeViewController ()

@property (nonatomic, retain) CarInspectRecordNetData *recordNetData;

@property (nonatomic, retain) ParkingBalanceModel *model;
@property (nonatomic, assign) BOOL isWeChatPay;// 是否微信支付 还是 支付宝支付

@end

@implementation RechargeViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Wallet" bundle:nil] instantiateViewControllerWithIdentifier:@"RechargeViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    
    // 默认支付宝支付
    self.isWeChatPay = NO;
    
    CTXViewBorderRadius(_payLabel, 3.0, 0, [UIColor clearColor]);
    
    moneyBtnArray = @[ _money20Btn, _money50Btn, _money100Btn, _money500Btn ];
    for (UIButton *btn in moneyBtnArray) {
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:UIColorFromRGB(CTXThemeColor) forState:UIControlStateNormal];
        CTXViewBorderRadius(btn, 3.0, 1, UIColorFromRGB(CTXThemeColor));
    }
    
    if (self.ubalance) {
        self.balanceLabel.hidden = NO;
        self.balanceLabel.text = [NSString stringWithFormat:@"%.2f元", [self.ubalance doubleValue]];
    } else {
        self.balanceLabel.hidden = YES;
        [self selectBalance];
    }
    
    _recordNetData = [[CarInspectRecordNetData alloc] init];
    _recordNetData.delegate = self;
}

- (void) close:(id)sender {
    [self.moneyTextField resignFirstResponder];
    
    [super close:sender];
}

#pragma mark - event response

- (IBAction)money20:(id)sender {
    self.moneyTextField.text = @"20.0";
    [self selectCurrentBtn:_money20Btn];
}

- (IBAction)money50:(id)sender {
    self.moneyTextField.text = @"50.0";
    [self selectCurrentBtn:_money50Btn];
}

- (IBAction)money100:(id)sender {
    self.moneyTextField.text = @"100.0";
    [self selectCurrentBtn:_money100Btn];
}

- (IBAction)money500:(id)sender {
    self.moneyTextField.text = @"500.0";
    [self selectCurrentBtn:_money500Btn];
}

- (void) selectCurrentBtn:(UIButton *)currentBtn {
    for (UIButton *btn in moneyBtnArray) {
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:UIColorFromRGB(CTXThemeColor) forState:UIControlStateNormal];
        CTXViewBorderRadius(btn, 3.0, 1, UIColorFromRGB(CTXThemeColor));
    }
    
    currentBtn.backgroundColor = UIColorFromRGB(CTXThemeColor);
    [currentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CTXViewBorderRadius(currentBtn, 3.0, 0, [UIColor clearColor]);
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {// 支付宝
        self.isWeChatPay = NO;
        _alipayIV.image = [UIImage imageNamed:@"goux_car"];
        _webChatIV.image = [UIImage imageNamed:@"weigoux_car"];
    } else if (indexPath.row == 3) {// 微信
        self.isWeChatPay = YES;
        _alipayIV.image = [UIImage imageNamed:@"weigoux_car"];
        _webChatIV.image = [UIImage imageNamed:@"goux_car"];
    } else if (indexPath.row == 5) {// 立即充值
        [self pay];
    }
}

#pragma mark - 支付

- (void) pay {
    NSString *moneyStr = self.moneyTextField.text;
    
    if (!moneyStr || [moneyStr isEqualToString:@""]) {
        [self showTextHubWithContent:@"请输入充值金额"];
        
        return;
    }
    
    if ([moneyStr doubleValue] < 0.01) {
        [self showTextHubWithContent:@"充值金额必须大于1分钱"];
        
        return;
    }
    
    if (![TextViewContentTool isDoubleNumber:moneyStr]) {
        
        [self showTextHubWithContent:@"请输入正确的金额"];
        return;
    }
    
    NSString *desc = @"钱包充值";
    
    if (self.isWeChatPay) {
        [self wxPayAPPWithDesc:desc payFee:moneyStr];
    } else {
        [self alipayPayWithDesc:desc payFee:moneyStr];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"aliPayTag"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webChatPayResult:) name:PayResultNotificationName object:nil];
        
        // 调用支付宝支付
        [[AlipaySDK defaultService] payOrder:(NSString *) result fromScheme:@"comahkeliAcrossAnHui2" callback:^(NSDictionary *resultDic) {
            int resultStatus = [resultDic[@"resultStatus"] intValue];
            if (resultStatus == 9000) {// 支付成功
                [self refreshDataAgain];
            } else {
                [self showTextHubWithContent:@"支付失败"];
            }
        }];
    }
    
    if ([tag isEqualToString:@"weChatPayTag"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webChatPayResult:) name:PayResultNotificationName object:nil];
        
        // 支付参数
        NSDictionary *dict = (NSDictionary *)result;
        
        PayReq * request = [[PayReq alloc] init];
        request.partnerId = dict[@"partnerid"];                 // 客户id
        request.prepayId = dict[@"prepayid"];                   // prepayid
        request.package = dict[@"package"];                     // 请求包
        request.nonceStr = dict[@"noncestr"];                   // 字符串
        request.timeStamp = [dict[@"timestamp"] doubleValue];   // 时间戳
        request.sign = dict[@"sign"];                           // 签名
        
        [WXApi sendReq:request];
    }
    
    if ([tag isEqualToString:@"selectBalanceTag"]) {
        self.model = [ParkingBalanceModel convertFromDict:result];
        
        self.balanceLabel.hidden = NO;
        self.balanceLabel.text = [NSString stringWithFormat:@"%.2f元", self.model.ubalance];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
}

#pragma mark - netWork

// 支付宝APP支付
- (void) alipayPayWithDesc:(NSString *)desc payFee:(NSString *)payFee {
    [self showHubWithLoadText:@"充值中..."];
    
    [_recordNetData aliPayWithToken:self.loginModel.token BusinessCode:nil
                               desc:desc payFee:payFee tag:@"aliPayTag"];
}

// 微信APP支付
- (void) wxPayAPPWithDesc:(NSString *)desc payFee:(NSString *)payFee {
    [self showHubWithLoadText:@"充值中..."];
    
    [_recordNetData weChatPayWithToken:self.loginModel.token BusinessCode:nil
                                  desc:desc payFee:payFee tag:@"weChatPayTag"];
    
}

// 用户余额查询
- (void)selectBalance {
    WalletNetData *walletNetData = [[WalletNetData alloc] init];
    walletNetData.delegate = self;
    
    [walletNetData selectBalanceWithToken:self.loginModel.token tag:@"selectBalanceTag"];
}

#pragma mark - private method

// 微信支付结果的通知
- (void) webChatPayResult:(NSNotification *)noti {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([noti.userInfo[@"result"] boolValue]) { // 跟最新代码 不一样的地方!!!!
        [self refreshDataAgain];
    } else {
        [self showTextHubWithContent:@"支付失败"];
    }
}

// 支付成功后的操作
- (void) refreshDataAgain {
    [self showHubWithLoadText:@"余额更新中..."];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 block:^(NSTimer * _Nonnull timer) {
        [self hideHub];
        // 更新余额
        [self selectBalance];
        // 发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:ParkingRechargeSuccessNotificationName object:self userInfo:nil];
    } repeats:NO];
}

@end
