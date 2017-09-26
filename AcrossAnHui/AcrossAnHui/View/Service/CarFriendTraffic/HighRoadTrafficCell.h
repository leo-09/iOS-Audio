//
//  HighRoadTrafficCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighTraficModel.h"

@interface HighRoadTrafficCell : UITableViewCell

@property (nonatomic, retain) HighTraficModel *model;

@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *contentLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)heightForModel:(HighTraficModel *)model;

@end
