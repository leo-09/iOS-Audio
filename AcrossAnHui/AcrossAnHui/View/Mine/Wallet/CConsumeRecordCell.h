//
//  CConsumeRecordCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsumeRecordModel.h"

@interface CConsumeRecordCell : UITableViewCell

@property (nonatomic, retain) ConsumeRecordModel *model;

@property (nonatomic, retain) UILabel *weekLabel;           // 周几
@property (nonatomic, retain) UILabel *dateLabel;           // 月日
@property (nonatomic, retain) UILabel *carNumberLabel;      // 车牌
@property (nonatomic, retain) UILabel *carNameLabel;        // 车架号
@property (nonatomic, retain) UILabel *moneyLabel;          // 金额
@property (nonatomic, retain) UILabel *descLabel;           // 充值描述
@property (nonatomic, retain) UIView *lineView;             // 底线

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void) setModel:(ConsumeRecordModel *)model isLastCell:(BOOL) isLast;

@end
