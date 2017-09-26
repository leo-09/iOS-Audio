//
//  CarFriendRecordViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/13.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"

/**
 随手拍 记录
 */
@interface CarFriendRecordViewController : CTXBaseTableViewController

@property (weak, nonatomic) IBOutlet UILabel *topicCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *trafficCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionCountLabel;

- (instancetype) initWithStoryboard;

@end
