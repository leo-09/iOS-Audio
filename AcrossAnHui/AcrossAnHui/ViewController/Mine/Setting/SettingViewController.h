//
//  SettingViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"

/**
 设置
 */
@interface SettingViewController : CTXBaseTableViewController

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UILabel *quitLoginLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *quitLoginCell;

- (instancetype) initWithStoryboard;

@end
