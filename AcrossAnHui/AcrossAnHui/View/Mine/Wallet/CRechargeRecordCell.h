//
//  CRechargeRecordCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/18.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeRecordModel.h"

@interface CRechargeRecordCell : UITableViewCell

@property (nonatomic, retain) RechargeRecordModel *model;

@property (nonatomic, retain) UILabel *weekLabel;       // 周几
@property (nonatomic, retain) UILabel *dateLabel;       // 月日
@property (nonatomic, retain) UIImageView *iv;          // 支付宝／微信的商标
@property (nonatomic, retain) UILabel *moneyLabel;      // 充值金额
@property (nonatomic, retain) UILabel *timeLabel;       // 充值时间
@property (nonatomic, retain) UIView *lineView;         // 底线

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void) setModel:(RechargeRecordModel *)model isLastCell:(BOOL) isLast;

@end
