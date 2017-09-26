//
//  CSearchParkingCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/22.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteModel.h"

@interface CSearchParkingCell : UITableViewCell

@property (nonatomic, retain) SiteModel *model;

@property (nonatomic, retain) UILabel *roadNameLabel;
@property (nonatomic, retain) UILabel *areaNameLabel;
@property (nonatomic, retain) UILabel *distanceLabel;
@property (nonatomic, retain) UIView *lineView;

@property (nonatomic, retain) UILabel *tintLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
