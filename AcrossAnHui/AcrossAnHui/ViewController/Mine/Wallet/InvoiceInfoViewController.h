//
//  InvoiceInfoViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"

/**
 发票详情
 */
@interface InvoiceInfoViewController : CTXBaseTableViewController

@property (nonatomic, copy) NSString *invoice;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *address;

@property (weak, nonatomic) IBOutlet UILabel *invoiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

- (instancetype) initWithStoryboard;

@end
