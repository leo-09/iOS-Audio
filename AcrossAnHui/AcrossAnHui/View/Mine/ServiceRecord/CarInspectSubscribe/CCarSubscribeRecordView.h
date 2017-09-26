//
//  CCarSubscribeRecordView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"

/**
 车检预约的记录View
 */
@interface CCarSubscribeRecordView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
    int countPerPage;// 每页的个数
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, assign) CGFloat offsetY;

@property (nonatomic, copy) RefreshDataListener refreshRecordDataListener;
@property (nonatomic, copy) LoadDataListener loadRecordDataListener;
@property (nonatomic, copy) ClickListener toInspectSubscribeListener;

@property (nonatomic, copy) SelectCellModelListener paySubscribeRecordListener;
@property (nonatomic, copy) SelectCellModelListener refundSubscribeRecordListener;
@property (nonatomic, copy) SelectCellModelListener evaluateSubscribeRecordListener;
@property (nonatomic, copy) SelectCellModelListener showEvaluateSubscribeRecordListener;
@property (nonatomic, copy) SelectCellModelListener cancelSubscribeRecordListener;

- (void) hideFooter;
- (void) endRefreshing;
- (void) removeFooter;
- (void) addFooter;

/**
 第一次加载数据
 
 @param data 第一页数据
 */
- (void) refreshDataSource:(NSArray *)data;

/**
 加载数据
 
 @param data 分页数据
 @param page 当前页码
 */
- (void) addDataSource:(NSArray *)data page:(int) page;

@end
