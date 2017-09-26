//
//  CCarAgencyRecordView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/16.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"
#import "CarInspectAgencyRecordModel.h"

/**
 车检代办记录列表View
 */
@interface CCarAgencyRecordView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, assign) CGFloat offsetY;

@property (nonatomic, copy) SelectCellModelListener selectAgencyRecordCellListener;
@property (nonatomic, copy) RefreshDataListener refreshAgencyRecordDataListener;
@property (nonatomic, copy) LoadDataListener loadAgencyRecordDataListener;
@property (nonatomic, copy) ClickListener toCarAgencyRecordListener;

@property (nonatomic, copy) SelectCellModelListener commentModelListener;
@property (nonatomic, copy) SelectCellModelListener payForModelListener;
@property (nonatomic, copy) SelectCellModelListener completeModelListener;

- (void) hideFooter;
- (void) endRefreshing;
- (void) removeFooter;
- (void) addFooter;

// 确认订单后，更新cell
- (void) updateCurrentModel:(CarInspectAgencyRecordModel *) model;

- (void) addDataSource:(NSArray *)data;
- (void) refreshDataSource:(NSArray *)data;

@end
