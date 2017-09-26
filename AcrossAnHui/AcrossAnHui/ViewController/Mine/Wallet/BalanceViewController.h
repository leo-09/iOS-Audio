//
//  BalanceViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"

/**
 余额
 */
@interface BalanceViewController : CTXBaseTableViewController

@property (nonatomic, copy) NSString *ubalance;  // 用户余额

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rechargeLabel;

- (instancetype) initWithStoryboard;

@end
