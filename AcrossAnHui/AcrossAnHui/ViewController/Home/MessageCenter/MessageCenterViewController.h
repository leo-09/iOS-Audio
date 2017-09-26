//
//  MessageCenterViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/27.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"

/**
 消息中心
 */
@interface MessageCenterViewController : CTXBaseTableViewController

@property (weak, nonatomic) IBOutlet UILabel *eventMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *sysMsgLabel;

- (instancetype) initWithStoryboard;

@end
