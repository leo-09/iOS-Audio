//
//  CCancelOrderReasonCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/23.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CancelOrderReasonModel.h"

@interface CCancelOrderReasonCell : UITableViewCell

@property (nonatomic, retain) CancelOrderReasonModel *model;

@property (nonatomic, retain) UIView *cellView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *iv;
@property (nonatomic, retain) UIView *lineView;

@property (nonatomic, retain) UILabel *submitLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void) setModel:(CancelOrderReasonModel *)model isLastCell:(BOOL) isLast;

@end
