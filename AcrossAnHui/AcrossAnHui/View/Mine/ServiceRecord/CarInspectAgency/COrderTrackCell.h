//
//  COrderTrackCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInspectAgencyOrderTrackModel.h"

@interface COrderTrackCell : UITableViewCell

@property (nonatomic, retain) CarInspectAgencyOrderTrackModel *model;

@property (nonatomic, retain) UIView *topLine;
@property (nonatomic, retain) UIView *bottomLine;

@property (nonatomic, retain) UIImageView *iv;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *timeLabel;

- (void) setModel:(CarInspectAgencyOrderTrackModel *)model isFirstCell:(BOOL)isFirstCell isLastCell:(BOOL)isLastCell;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
