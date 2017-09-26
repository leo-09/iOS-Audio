//
//  CarInspectOnlinePayViewController.h
//  AcrossAnHui
//
//  Created by ztd on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "SubscribeModel.h"

/**
 车检预约 在线支付
 */
@interface CarInspectOnlinePayViewController : CTXBaseTableViewController

@property (nonatomic,retain) SubscribeModel * model;

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *orderPayLab;
@property (weak, nonatomic) IBOutlet UILabel *oederTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *plateLab;
@property (weak, nonatomic) IBOutlet UILabel *stationInfoLab;
@property (weak, nonatomic) IBOutlet UIImageView *stationImg;
@property (weak, nonatomic) IBOutlet UIImageView *alipayIV;
@property (weak, nonatomic) IBOutlet UIImageView *webChatIV;

- (instancetype) initWithStoryboard;

@end
