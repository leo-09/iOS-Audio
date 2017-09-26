//
//  CarFreeInspectPayViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "SubscribeModel.h"

/**
 六年免检 订单支付
 */
@interface CarFreeInspectPayViewController : CTXBaseTableViewController

@property (nonatomic, retain) SubscribeModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *alipayIV;
@property (weak, nonatomic) IBOutlet UIImageView *webChatIV;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;

- (instancetype) initWithStoryboard;

@end
