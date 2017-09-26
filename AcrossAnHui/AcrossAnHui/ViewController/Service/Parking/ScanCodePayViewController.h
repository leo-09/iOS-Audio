//
//  ScanCodePayViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "ParkRecordModel.h"

/**
 停车支付
 */
@interface ScanCodePayViewController : CTXBaseTableViewController

@property (nonatomic, copy) NSString *ubalance;
@property (nonatomic, retain) ParkRecordModel *model;

@property (weak, nonatomic) IBOutlet UILabel *carInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *alipayIV;
@property (weak, nonatomic) IBOutlet UIImageView *webChatIV;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;

- (instancetype) initWithStoryboard;

@end
