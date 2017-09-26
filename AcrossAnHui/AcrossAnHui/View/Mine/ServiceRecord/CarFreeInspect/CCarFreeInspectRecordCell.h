//
//  CCarFreeInspectRecordCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubscribeModel.h"

typedef void (^SelectCellModelListener)(id result);

/**
 六年免检的记录Cell
 */
@interface CCarFreeInspectRecordCell : UITableViewCell

@property (nonatomic, retain) SubscribeModel *model;

@property (nonatomic, retain) UILabel *carLabel;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) UILabel *orderDescLabel;
@property (nonatomic, retain) UIView *btnView;
@property (nonatomic, retain) UIButton *leftBtn;
@property (nonatomic, retain) UIButton *rightBtn;

@property (nonatomic, copy) SelectCellModelListener paySubscribeRecordListener;
@property (nonatomic, copy) SelectCellModelListener refundSubscribeRecordListener;
@property (nonatomic, copy) SelectCellModelListener logisticsSubscribeRecordListener;
@property (nonatomic, copy) SelectCellModelListener cancelSubscribeRecordListener;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)heightForModel:(SubscribeModel *)model;

@end