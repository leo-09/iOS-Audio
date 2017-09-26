//
//  CCarFreeInspectRecordView.h
//  AcrossAnHui
//
//  Created by liyy on 2017/7/12.
//  Copyright © 2017年 安徽畅通行. All rights reserved.
//

#import "CTXBaseView.h"
#import "PromptView.h"

/**
 六年免检的记录View
 */
@interface CCarFreeInspectRecordView : CTXBaseView<UITableViewDelegate, UITableViewDataSource> {
    PromptView *promptView;
    
    int countPerPage;// 每页的个数
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, assign) CGFloat offsetY;

@property (nonatomic, copy) RefreshDataListener refreshRecordDataListener;
@property (nonatomic, copy) LoadDataListener loadRecordDataListener;
@property (nonatomic, copy) ClickListener toCarFreeInspectListener;

@property (nonatomic, copy) SelectCellModelListener paySubscribeRecordListener;
@property (nonatomic, copy) SelectCellModelListener refundSubscribeRecordListener;
@property (nonatomic, copy) SelectCellModelListener logisticsSubscribeRecordListener;
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
