//
//  InvoiceInfoViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "InvoiceInfoViewController.h"
#import "WalletViewController.h"
#import "WalletNetData.h"

@interface InvoiceInfoViewController ()

@end

@implementation InvoiceInfoViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Wallet" bundle:nil] instantiateViewControllerWithIdentifier:@"InvoiceInfoViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发票详情";
    
    self.invoiceLabel.text = (_invoice ? _invoice : @"");
    self.moneyLabel.text = (_money ? _money : @"");
    self.addressLabel.text = (_address ? _address : @"");
    
    CTXViewBorderRadius(_sureBtn, 3.0, 0, [UIColor clearColor]);
    CTXViewBorderRadius(_editBtn, 3.0, 1, UIColorFromRGB(CTXThemeColor));
}

#pragma mark - event response

- (IBAction)submitOrder:(id)sender {
    [self addTicketSend];
}

- (IBAction)editOrder:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"addTicketSendTag"]) {
        [self showTextHubWithContent:@"申请发票成功"];
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[WalletViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
}

#pragma mark - network

// 添加发票记录
- (void)addTicketSend {
    [self showHubWithLoadText:@"申请发票中..."];
    
    WalletNetData *walletNetData = [[WalletNetData alloc] init];
    walletNetData.delegate = self;
    [walletNetData addTicketSendWithToken:self.loginModel.token petitionermoney:self.moneyLabel.text petitioner:self.invoiceLabel.text address:self.addressLabel.text tag:@"addTicketSendTag"];
}

@end
