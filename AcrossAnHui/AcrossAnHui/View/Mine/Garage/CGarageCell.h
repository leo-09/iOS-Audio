//
//  CGarageCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/15.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoundCarModel.h"

@interface CGarageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, retain) BoundCarModel *model;

@property (nonatomic, retain) UIButton *selectBtn;
@property (nonatomic, retain) UIImageView *parkingIV;
@property (nonatomic, retain) UIImageView *iconIV;
@property (nonatomic, retain) UILabel *noteLabel;
@property (nonatomic, retain) UILabel *defaultCarLabel;
@property (nonatomic, retain) UILabel *plateNumberLabel;
@property (nonatomic, retain) UILabel *nameLabel;

@end
