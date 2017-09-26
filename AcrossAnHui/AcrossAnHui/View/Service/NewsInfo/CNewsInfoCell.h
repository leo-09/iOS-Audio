//
//  CNewsInfoCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/5/25.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNewsInfoCell : UITableViewCell

@property (nonatomic, retain) UIImageView *iconIV;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIView *lineView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void) isLastCell:(BOOL) isLast;

@end
