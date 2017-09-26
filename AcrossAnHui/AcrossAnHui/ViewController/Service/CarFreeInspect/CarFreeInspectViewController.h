//
//  CarFreeInspectViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "LMJDropdownMenu.h"
#import "BoundCarModel.h"

/**
 六年免检 提交申请
 */
@interface CarFreeInspectViewController : CTXBaseTableViewController<LMJDropdownMenuDelegate>

@property (nonatomic, retain) BoundCarModel *model;
@property (nonatomic, copy) NSString *subscribeDate;          // 预约时间(格式:yyyy-MM-dd HH:mm:ss)

@property (weak, nonatomic) IBOutlet UITextField *contactNameText;
@property (weak, nonatomic) IBOutlet UITextField *contactPhoneText;
@property (weak, nonatomic) IBOutlet UITextField *fetchAddressText;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;          // 地址相同
@property (weak, nonatomic) IBOutlet UITextField *receiveAddressText;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;    // 优惠码

@property (weak, nonatomic) IBOutlet UITableViewCell *typeCell;
@property (weak, nonatomic) IBOutlet LMJDropdownMenu *dropDownMenu;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UITextField *fetchCode;
@property (weak, nonatomic) IBOutlet UITextField *receiveCode;
@property (weak, nonatomic) IBOutlet UILabel *submitLabel;

- (instancetype) initWithStoryboard;

@end
