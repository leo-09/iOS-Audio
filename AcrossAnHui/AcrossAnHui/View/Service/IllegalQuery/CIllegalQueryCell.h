//
//  CIllegalQueryCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/6/17.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarIllegalInfoModel.h"

/**
 违章查询 View的cell
 */
@interface CIllegalQueryCell : UITableViewCell

@property (nonatomic, retain) ViolationInfoModel *model;

@property (nonatomic, retain) UILabel *countLabel;      // cell的计数
@property (nonatomic, retain) UILabel *timeLabel;       // 违章时间
@property (nonatomic, retain) UIImageView *iv;
@property (nonatomic, retain) UILabel *scoreLabel;      // 扣分
@property (nonatomic, retain) UILabel *moneyLabel;      // 罚款金额
@property (nonatomic, retain) UILabel *addressLabel;    // 违章地点

@property (nonatomic, retain) UIView *leftTopLineView;      // 左边的线 上半部分
@property (nonatomic, retain) UIView *leftBottomLineView;   // 左边的线 下半部分
@property (nonatomic, retain) UIView *bottomLineView;       // 底部的线

+ (instancetype)cellWithTableView:(UITableView *)tableView;

// 隐藏线
- (void) showLeftTopLineView:(BOOL) hide;
- (void) showBottomLineView:(BOOL) hide;

// 设置计数
- (void) setCountLabelText:(NSString *)text;

@end
