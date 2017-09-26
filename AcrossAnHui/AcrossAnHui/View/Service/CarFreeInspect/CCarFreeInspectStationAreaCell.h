//
//  CCarFreeInspectStationAreaCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/29.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCarFreeInspectStationAreaCell : UITableViewCell

@property (nonatomic, retain) UILabel *label;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void) setAreaName:(NSString *)areaName isLastCell:(BOOL)isLastCell;

@end
