//
//  ArrearageViewController.m
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "ArrearageViewController.h"
#import "ParkCarSelectPayTableViewController.h"
#import "RechargeViewController.h"
#import "ParkingArrearageModel.h"
#import "ParkRecordAlertView.h"
#import "ParkingNetData.h"

@interface ArrearageViewController ()

@property (nonatomic, retain) ParkingArrearageModel *model;
@property (nonatomic, retain) ParkingNetData *parkingNetData;

@end

@implementation ArrearageViewController

- (instancetype) initWithStoryboard {
    return [[UIStoryboard storyboardWithName:@"Parking" bundle:nil] instantiateViewControllerWithIdentifier:@"ArrearageViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"欠费补缴";
    
    _moneyLabel.text = @"0元";
    CTXViewBorderRadius(_walletPayBtn, 4.0, 0, [UIColor clearColor]);
    CTXViewBorderRadius(_otherPayBtn, 4.0, 0, [UIColor clearColor]);
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _parkingNetData = [[ParkingNetData alloc] init];
    _parkingNetData.delegate = self;
    
    [self showHub];
    [self selectOdue];
    
    // 缴费成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upadteOdue) name:ParkingPaySuccessNotificationName object:nil];
}

// 支付成功，直接显示欠费为0
- (void) upadteOdue {
    self.model = nil;
    _moneyLabel.text = @"0元";
    [self.tableView reloadData];
}

#pragma mark - CTXNetDataDelegate

- (void) querySuccessWithTag:(NSString *)tag result:(id)result tint:(NSString *)tint {
    // 必须调用父类的querySuccess，确保token失效后的登录回调能够调用
    [super querySuccessWithTag:tag result:result tint:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"immediatePaymentTag"]) {
        [self showHubWithLoadText:@"补缴成功, 正在查询"];
        [self selectOdue];// 补缴成功,重新加载数据
    }
    
    if ([tag isEqualToString:@"selectOdueTag"]) {
        self.model = [ParkingArrearageModel convertFromDict:result];
        
        // 更新UI
        _moneyLabel.text = [NSString stringWithFormat:@"%.2f元", self.model.totalOdue];
        [self.tableView reloadData];
    }
}

- (void) queryFailureWithTag:(NSString *)tag tint:(NSString *)tint {
    // 必须调用父类的queryFailure，确保token失效后的登录回调能够调用
    [super queryFailureWithTag:tag tint:tint];
    [self showTextHubWithContent:tint];
    [self hideHub];
    
    if ([tag isEqualToString:@"selectOdueTag"]) {
        self.model = nil;
        _moneyLabel.text = @"0元";
        [self.tableView reloadData];
    }
}

#pragma mark - netWork

// 欠费金额查询
- (void)selectOdue {
    [_parkingNetData selectOdueWithToken:self.loginModel.token tag:@"selectOdueTag"];
}

// 补缴欠费
- (void)immediatePaymentFinish {
    [self showHubWithLoadText:@"补缴欠款中..."];
    
    [_parkingNetData immediatePaymentFinishWithToken:self.loginModel.token orderNum:_model.orderNum tag:@"immediatePaymentTag"];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model.odueList && self.model.odueList.count > 0) {
        return self.model.odueList.count + 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        NSString *headerCellIden = @"headerCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:headerCellIden];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellIden];
        }
    } else {
        static NSString *cellIden = @"cell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        }
        
        UILabel *cardLabel = [cell viewWithTag:111];
        UILabel *carNameLabel = [cell viewWithTag:112];
        UILabel *odueLabel = [cell viewWithTag:113];
        
        ArrearageInfoModel *model = self.model.odueList[indexPath.row-1];
        cardLabel.text = model.card ? model.card : @"";
        carNameLabel.text = model.carName ? model.carName : @"";
        odueLabel.text = [NSString stringWithFormat:@"欠费：%.2f元", [model.odue doubleValue]];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 50;
    } else {
        return 76;
    }
}

#pragma mark - event response

// 钱包支付
- (IBAction)walletPay:(id)sender {
    if (self.model && self.model.totalOdue > 0) {
        if (self.model.ubalance >= self.model.totalOdue) {
            // 帐户余额足够
            NSString * note = [NSString stringWithFormat:@"总欠款金额:%0.2f元,是否确定支付", self.model.totalOdue];
            ParkRecordAlertView * alertview = [[ParkRecordAlertView alloc] initWithFrame:self.view.bounds note:note title:@"确定缴费"];
            [alertview setSelectCellListener:^(BOOL selectPay) {
                if (selectPay) {
                    [self immediatePaymentFinish];
                }else{
                    [self selectPayTableViewController];
                }
            }];
            
            [self.view addSubview:alertview];
        } else {
            // 帐户余额不足
            NSString * note = [NSString stringWithFormat:@"目前账户余额为:%0.2f元,是否去充值", self.model.ubalance];
            ParkRecordAlertView * alertview = [[ParkRecordAlertView alloc] initWithFrame:self.view.bounds note:note title:@"余额不足"];
            [alertview setSelectCellListener:^(BOOL selectPay) {
                if (selectPay) {//充值
                    RechargeViewController * controller = [[RechargeViewController alloc] initWithStoryboard];
                    [self basePushViewController:controller];
                }else{
                    [self selectPayTableViewController];
                }
            }];
            [self.view addSubview:alertview];
        }
    } else {
        [self showTextHubWithContent:@"暂无欠费"];
    }
}

// 其他支付
- (IBAction)otherPay:(id)sender {
    if (self.model && self.model.totalOdue > 0) {
        [self selectPayTableViewController];
    } else {
        [self showTextHubWithContent:@"暂无欠费"];
    }
}

- (void) selectPayTableViewController {
    ParkCarSelectPayTableViewController * controller = [[ParkCarSelectPayTableViewController alloc] initWithStoryboard];
    controller.businessCode = self.model.orderNum;
    controller.payFee = self.model.totalOdue;
    [self basePushViewController:controller];
}

@end
