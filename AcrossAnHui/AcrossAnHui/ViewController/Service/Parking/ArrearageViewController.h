//
//  ArrearageViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseViewController.h"

/**
 欠费补缴
 */
@interface ArrearageViewController : CTXBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *walletPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherPayBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (instancetype) initWithStoryboard;

@end
