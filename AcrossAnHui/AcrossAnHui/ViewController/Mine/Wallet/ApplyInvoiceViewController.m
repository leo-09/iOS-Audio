//
//  ApplyInvoiceViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ApplyInvoiceViewController.h"
#import "InvoiceRecordViewController.h"
#import "InvoiceInfoViewController.h"
#import "WalletNetData.h"
#import "TextViewContentTool.h"

@interface ApplyInvoiceViewController ()

@property (nonatomic, assign) double invoiceAmount;// 发票可申请金额

@end

@implementation ApplyInvoiceViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Wallet" bundle:nil] instantiateViewControllerWithIdentifier:@"ApplyInvoiceViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发票申请";
    
    // rightBarButtonItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"申请记录" style:UIBarButtonItemStyleDone target:self action:@selector(applyRecord)];
    [rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSDictionary *dict = @{ NSFontAttributeName: [UIFont systemFontOfSize:15.0f] };
    [rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    CTXViewBorderRadius(_applyLabel, 3.0, 0, [UIColor clearColor]);
    
    // 地址输入限制
    [self.addressTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self seleteTicketSendMoney];
}

// 申请记录
- (void) applyRecord {
    InvoiceRecordViewController *controller = [[InvoiceRecordViewController alloc] init];
    [self basePushViewController:controller];
}

- (void) textFieldDidChange:(UITextField *)theTextField {
    if (theTextField.text.length > 50) {
        self.addressTextField.text = [theTextField.text substringToIndex:50];
    }
}

#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {// 提交
        
        NSString *money = self.moneyTextField.text;
        
        if ([money isEqualToString:@""]) {
            [self showTextHubWithContent:@"请输入发票金额"];
            
            return;
        }
        
        if ([money doubleValue] > self.invoiceAmount) {
            [self showTextHubWithContent:@"发票金额不能大于可申请额度"];
            
            return;
        }
        
        if ([money doubleValue] < 0.01) {
            [self showTextHubWithContent:@"发票金额必须大于1分"];
            
            return;
        }
        
        if (![TextViewContentTool isDoubleNumber:money]) {
            
            [self showTextHubWithContent:@"请输入正确的金额"];
            return;
        }
        
        if ([self.invoiceTextField.text isEqualToString:@""]) {
            [self showTextHubWithContent:@"请输入发票开头"];
            
            return;
        }
        
        if ([self.addressTextField.text isEqualToString:@""]) {
            [self showTextHubWithContent:@"请输入邮寄地址"];
            
            return;
        }
        
        InvoiceInfoViewController *controller = [[InvoiceInfoViewController alloc] initWithStoryboard];
        controller.invoice = self.invoiceTextField.text;
        controller.money = self.moneyTextField.text;
        controller.address = self.addressTextField.text;
        [self basePushViewController:controller];
    }
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"seleteTicketSendMoneyTag"]) {
        self.invoiceAmount = [result[@"TSMoney"] doubleValue];
        
        self.balanceLabel.hidden = NO;
        self.balanceLabel.text = [NSString stringWithFormat:@"%.2f元", self.invoiceAmount];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"seleteTicketSendMoneyTag"]) {
        self.balanceLabel.hidden = YES;
    }
}

#pragma mark - network

// 查询发票申请余额
- (void)seleteTicketSendMoney {
    [self showHubWithLoadText:@"查询可申请余额中..."];
    
    WalletNetData *walletNetData = [[WalletNetData alloc] init];
    walletNetData.delegate = self;
    
    [walletNetData seleteTicketSendMoneyWithToken:self.loginModel.token tag:@"seleteTicketSendMoneyTag"];
}

@end
