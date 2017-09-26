//
//  CSelectBindedCarCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarIllegalInfoModel.h"

@interface CSelectBindedCarCell : UITableViewCell

@property (nonatomic, retain) CarIllegalInfoModel *model;
@property (nonatomic, assign) BOOL isLastCell;

@property (nonatomic, retain) UIView *addBgView;// 添加车辆cell的背景View
@property (nonatomic, retain) UIView *carBgView;// 车辆信息cell的背景View
@property (nonatomic, retain) UIImageView *iconIV;
@property (nonatomic, retain) UILabel *plateNumberLabel;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *illegalNameLabel;
@property (nonatomic, retain) UILabel *illegalLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void) setModel:(CarIllegalInfoModel *)model isLastCell:(BOOL) isLastCell;

@end
