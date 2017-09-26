//
//  PayResultViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"

typedef enum {
    ChannelPay_CarInspectSubscribePay = 0,  // 车检预约支付成功
    ChannelPay_CarInspectSubscribe = 1,     // 车检预约成功
    ChannelPay_CarFreeInspect = 2           // 6年免检支付成功
} ChannelPay;

/**
 微信／支付宝 支付成功页面
 */
@interface PayResultViewController : CTXBaseTableViewController

// 支付的来源
@property (nonatomic, assign) ChannelPay tag;
@property (nonatomic, copy) NSString *businessId;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;

- (instancetype) initWithStoryboard;

@end
