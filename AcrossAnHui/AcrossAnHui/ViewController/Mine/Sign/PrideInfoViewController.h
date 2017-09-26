//
//  PrideInfoViewController.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/6.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseTableViewController.h"
#import "PrideModel.h"

/**
 奖品详情
 */
@interface PrideInfoViewController : CTXBaseTableViewController

@property (nonatomic, retain) PrideModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLeftConstraint;

- (instancetype) initWithStoryboard;

@end
