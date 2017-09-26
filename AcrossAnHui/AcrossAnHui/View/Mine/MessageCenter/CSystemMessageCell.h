//
//  CSystemMessageCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/19.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCenterModel.h"

@interface CSystemMessageCell : UITableViewCell

@property (nonatomic, retain) MessageCenterModel *model;

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIView *lineView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void) setModel:(MessageCenterModel *)model isLast:(BOOL)isLast;

@end
