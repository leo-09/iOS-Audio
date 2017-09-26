//
//  SubscribeEventViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/2.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"

/**
 订阅事件
 */
@interface SubscribeEventViewController : CTXBaseTableViewController

@property (weak, nonatomic) IBOutlet UISwitch *eventSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *timeSwitch;

- (instancetype) initWithStoryboard;

@end
