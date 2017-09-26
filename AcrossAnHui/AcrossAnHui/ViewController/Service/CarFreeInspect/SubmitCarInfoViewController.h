//
//  SubmitCarInfoViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "BoundCarModel.h"
#import "CarInspectNetData.h"

/**
 填写车辆信息 进行 六年免检、车检代办、车检预约
 */
@interface SubmitCarInfoViewController : CTXBaseTableViewController

@property (nonatomic, copy) NSString *fromViewController;
@property (nonatomic, retain) BoundCarModel *model;

@property (nonatomic, retain) CarInspectNetData *carInspectNetData;

@property (weak, nonatomic) IBOutlet UITextField *plateNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *frameNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UIButton *FrameNumberBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *bindLabel;
@property (weak, nonatomic) IBOutlet UIButton *userProtocol;
@property (weak, nonatomic) IBOutlet UIButton *understandProtocol;

@property (weak, nonatomic) IBOutlet UITableViewCell *insuranceDateCell;// 交强险终止日期
@property (weak, nonatomic) IBOutlet UITableViewCell *userProtocolCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *understandProtocolCell;

- (instancetype) initWithStoryboard;

@end
