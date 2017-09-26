//
//  CCarInspectLogisticsCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/8/21.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInspectLogistics.h"

@interface CCarInspectLogisticsCell : UITableViewCell

@property (nonatomic, retain) CarInspectLogistics *model;

@property (nonatomic, retain) UIView *topLine;
@property (nonatomic, retain) UIView *circleView;
@property (nonatomic, retain) UILabel *descLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIView *bottomLine;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void) setModel:(CarInspectLogistics *)model isFirstCell:(BOOL)isFirstCell isLastCell:(BOOL)isLastCell;
- (CGFloat)heightForModel:(CarInspectLogistics *)model isFirstCell:(BOOL)isFirstCell;

@end
