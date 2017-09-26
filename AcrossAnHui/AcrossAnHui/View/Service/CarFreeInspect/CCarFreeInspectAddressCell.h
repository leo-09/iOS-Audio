//
//  CCarFreeInspectAddressCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/4.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCarFreeInspectAddressCell : UITableViewCell

@property (nonatomic, copy) NSString *areaName;

@property (nonatomic, retain) UILabel *label;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
