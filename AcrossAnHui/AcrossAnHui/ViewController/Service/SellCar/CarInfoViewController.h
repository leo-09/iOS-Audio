//
//  CarInfoViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"

/**
 车辆信息
 */
@interface CarInfoViewController : CTXBaseTableViewController

@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *kliTextField;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (instancetype) initWithStoryboard;

@end
