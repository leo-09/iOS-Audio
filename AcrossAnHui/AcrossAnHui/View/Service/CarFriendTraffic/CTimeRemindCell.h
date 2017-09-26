//
//  CTimeRemindCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/5.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderRoadModel.h"

typedef void (^ClickButtonListener)(id result);

@interface CTimeRemindCell : UITableViewCell

@property (nonatomic, retain) OrderRoadModel *model;

@property (nonatomic, retain) UILabel *timeLabel;   // 时间
@property (nonatomic, retain) UILabel *weekLabel;   // 周一-周日
@property (nonatomic, retain) UILabel *pathLabel;   // 起始点
@property (nonatomic, retain) UIButton *editBtn;    // 编辑
@property (nonatomic, retain) UIButton *showBtn;    // 查看

@property (nonatomic, copy) ClickButtonListener editRoadInfoCellListener;
@property (nonatomic, copy) ClickButtonListener showRoadInfoCellListener;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)heightForModel:(OrderRoadModel *)model;

@end
