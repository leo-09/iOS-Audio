//
//  CHelpCenterCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpCenterModel.h"

@interface CHelpCenterCell : UITableViewCell

@property (nonatomic, retain) HelpCenterModel *model;

@property (nonatomic, retain) UILabel *conentLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)heightForModel:(HelpCenterModel *)model;

@end
