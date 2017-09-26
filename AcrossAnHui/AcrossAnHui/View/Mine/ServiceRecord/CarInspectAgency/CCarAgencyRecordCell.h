//
//  CCarAgencyRecordCell.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInspectAgencyRecordModel.h"

typedef void (^SelectCellModelListener)(id result);

@interface CCarAgencyRecordCell : UITableViewCell {
    BOOL isShowCountDown;
}

@property (nonatomic, retain) CarInspectAgencyRecordModel *model;

@property (nonatomic, retain) UILabel * licenseLab;
@property (nonatomic, retain) UILabel * stationNameLab;
@property (nonatomic, retain) UILabel * orderTimeLab;
@property (nonatomic, retain) UILabel * receivingOrderStateLab;
@property (nonatomic, retain) UIButton * rightBtn;
@property (nonatomic, retain) UIButton * payBtn;

@property (nonatomic, copy) SelectCellModelListener commentModelListener;
@property (nonatomic, copy) SelectCellModelListener payForModelListener;
@property (nonatomic, copy) SelectCellModelListener completeModelListener;
@property (nonatomic, copy) SelectCellModelListener waitPayTimeListener;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)heightForModel:(CarInspectAgencyRecordModel *)model;

@end
