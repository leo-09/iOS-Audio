//
//  CIllegalQueryEmptyDataCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 违章查询 View的 空数据 cell
 */
@interface CIllegalQueryEmptyDataCell : UITableViewCell

@property (nonatomic, retain) UILabel *label;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void) setLabelText:(NSString *)text;

@end
