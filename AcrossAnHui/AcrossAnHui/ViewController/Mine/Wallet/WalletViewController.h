//
//  WalletViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"

/**
 我的钱包
 */
@interface WalletViewController : CTXBaseTableViewController

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UISwitch *autoPaySwitch;

- (instancetype) initWithStoryboard;

@end
