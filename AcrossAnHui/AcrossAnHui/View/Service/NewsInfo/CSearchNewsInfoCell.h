//
//  CSearchNewsInfoCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/26.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSearchNewsInfoCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIView *lineView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void) lineWidth;
- (void) updateLastLineWidth;

@end
