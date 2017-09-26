//
//  CSelectCarTypeCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/14.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSelectCarTypeCell : UITableViewCell

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIView *lineView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
