//
//  BalanceViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "BalanceViewController.h"
#import "RechargeViewController.h"
#import "RechargeRecordViewController.h"
#import "ParkingBalanceModel.h"
#import "WalletNetData.h"

@interface BalanceViewController ()

@property (nonatomic, retain) ParkingBalanceModel *model;
@property (nonatomic, retain) WalletNetData *walletNetData;

@end

@implementation BalanceViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Wallet" bundle:nil] instantiateViewControllerWithIdentifier:@"BalanceViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"余额";
    
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"充值记录" style:UIBarButtonItemStyleDone target:self action:@selector(recharge)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:15.0f] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    CTXViewBorderRadius(_rechargeLabel, 3.0, 0, [UIColor clearColor]);
    
    _walletNetData = [[WalletNetData alloc] init];
    _walletNetData.delegate = self;
    
    if (self.ubalance) {
        self.balanceLabel.hidden = NO;
        self.balanceLabel.text = [NSString stringWithFormat:@"%.2f元", [self.ubalance doubleValue]];
    } else {
        self.balanceLabel.hidden = YES;
        [self selectBalance];
    }
    
    // 充值成功，再重新请求数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectBalance) name:ParkingRechargeSuccessNotificationName object:nil];
}

- (void) recharge {
    RechargeRecordViewController *controller = [[RechargeRecordViewController alloc] init];
    [self basePushViewController:controller];
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {// 去充值
        RechargeViewController *controller = [[RechargeViewController alloc] initWithStoryboard];
        controller.ubalance = self.ubalance;
        [self basePushViewController:controller];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
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
    
    if ([tag isEqualToString:@"selectBalanceTag"]) {
        self.balanceLabel.hidden = YES;
    }
}

#pragma mark - netWork

// 用户余额查询
- (void)selectBalance {
    [_walletNetData selectBalanceWithToken:self.loginModel.token tag:@"selectBalanceTag"];
}

@end
