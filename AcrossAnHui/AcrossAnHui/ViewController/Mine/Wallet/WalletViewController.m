//
//  WalletViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "WalletViewController.h"
#import "ConsumeRecordViewController.h"
#import "ApplyInvoiceViewController.h"
#import "BalanceViewController.h"
#import "ParkingBalanceModel.h"
#import "AutoPayTintView.h"
#import "WalletDialogView.h"
#import "WalletNetData.h"

@interface WalletViewController () {
    BOOL isShowWalletDialogView;
}

@property (nonatomic, retain) ParkingBalanceModel *model;
@property (nonatomic, retain) WalletNetData *walletNetData;

@end

@implementation WalletViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Wallet" bundle:nil] instantiateViewControllerWithIdentifier:@"WalletViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isShowWalletDialogView = YES;
    self.navigationItem.title = @"我的钱包";
    
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"消费记录" style:UIBarButtonItemStyleDone target:self action:@selector(consumeRecord)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:15.0f] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.autoPaySwitch.on = NO;
    
    _walletNetData = [[WalletNetData alloc] init];
    _walletNetData.delegate = self;
    
    [self showHub];
    [self selectBalance];
    
    // 充值成功，再重新请求数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectBalance) name:ParkingRechargeSuccessNotificationName object:nil];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isShowWalletDialogView) {
        isShowWalletDialogView = NO;
        // 钱包功能目前仅支持蚌埠停车业务的缴费支付，请谨慎充值使用！
        WalletDialogView *walletDialogView = [[WalletDialogView alloc] init];
        [walletDialogView setBackListener:^ {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [walletDialogView showView];
    }
}

// 消费记录
- (void) consumeRecord {
    ConsumeRecordViewController *controller = [[ConsumeRecordViewController alloc] init];
    [self basePushViewController:controller];
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {// 余额
        BalanceViewController *controller = [[BalanceViewController alloc] initWithStoryboard];
        controller.ubalance = (self.model ? [NSString stringWithFormat:@"%.2f", self.model.ubalance] : nil);
        [self basePushViewController:controller];
    }
    
    if (indexPath.row == 2) {// 发票申请
        ApplyInvoiceViewController *controller = [[ApplyInvoiceViewController alloc] initWithStoryboard];
        [self basePushViewController:controller];
    }
}

- (IBAction)autoPaySwitch:(id)sender {
    if (self.autoPaySwitch.on) {
        // 自动付款
        AutoPayTintView *autoPayTintView = [[AutoPayTintView alloc] init];
        
        [autoPayTintView setOpenAutoPayListener:^ {
            [self updatePayType:YES];
        }];
        [autoPayTintView setCancelAutoPayListener:^ {
            self.autoPaySwitch.on = NO;
        }];
        
        [autoPayTintView showView];
    } else {
        // 关闭自动付款
        [self updatePayType:NO];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"updatePayTypeTag"]) {
        if (self.model.payType) {
            [self showTextHubWithContent:@"关闭自动付款"];
            self.model.payType = NO;
        } else {
            [self showTextHubWithContent:@"开启自动付款"];
            self.model.payType = YES;
        }
    }
    
    if ([tag isEqualToString:@"selectBalanceTag"]) {
        self.model = [ParkingBalanceModel convertFromDict:result];
        
        self.moneyLabel.hidden = NO;
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元", self.model.ubalance];
        if (self.model.payType) {
            self.autoPaySwitch.on = YES;
        } else {
            self.autoPaySwitch.on = NO;
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"selectBalanceTag"]) {
        self.moneyLabel.hidden = YES;
        self.autoPaySwitch.on = NO;
    }
}

#pragma mark - network

- (void) updatePayType:(BOOL)payType {    
    if (self.model.payType == payType) {
        return;
    }
    
    if (payType) {
        [self showHubWithLoadText:@"正在开启自动付款"];
    } else {
        [self showHubWithLoadText:@"正在关闭自动付款"];
    }
    
    [_walletNetData updatePayTypeWithToken:self.loginModel.token payType:(payType ? @"1" : @"0") tag:@"updatePayTypeTag"];
}

// 用户余额查询
- (void)selectBalance {
    [_walletNetData selectBalanceWithToken:self.loginModel.token tag:@"selectBalanceTag"];
}

@end
